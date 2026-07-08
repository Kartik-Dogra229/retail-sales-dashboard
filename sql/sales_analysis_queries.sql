/*
retailpulse - sql analysis
dataset: cleaned online retail sales data (uk online retailer, dec 2010 slice)
tool: sql server / ssms

this script does two things:
1. creates the sales table and loads the cleaned csv (from the excel phase)
2. runs the core kpi queries used in the project: total revenue, average
   order value, repeat purchase rate, top customers, top products,
   top countries, monthly/quarterly trend, and target vs actual variance

note on filtering: every kpi below filters on orderstatus = 'completed'
and revenue > 0. this excludes cancelled orders (returns, not real sales)
and rows with unknown products or a missing/zero price (data entry errors
found during the excel cleaning phase). this keeps every number consistent
across excel, sql, python and power bi.
*/


-- 1. create database and table
create database retailpulse


use retailpulse


create table dbo.sales (
    invoiceno      varchar(20),
    stockcode      varchar(20),
    description    varchar(255),
    quantity       int,
    invoicedate    varchar(30),
    salesyear      int,
    salesmonth     varchar(20),
    salesquarter   int,
    unitprice      decimal(10,2),
    customerid     varchar(20),   -- text, not int: blank ids were labeled "guest" in excel
    country        varchar(50),
    orderstatus    varchar(20),
    revenue        decimal(12,2)
)



-- 2. load data
-- loaded via bulk insert from the cleaned csv (see bulk_insert_snippet.sql)
-- table is populated before running the queries below
bulk insert dbo.sales
from 'D:\retail-sales.csv'
with (
    format = 'csv',
    fieldquote = '"',
    fieldterminator = ',',
    rowterminator = '0x0a',
    firstrow = 2,
    tablock
)

-- 3. validate the import before trusting any numbers
select count(*) as totalrows from dbo.sales

select orderstatus, count(*) as rowcount
from dbo.sales
group by orderstatus

select top 10 * from dbo.sales



-- 4. kpi queries

-- total revenue
-- sum of all completed, validly priced sales
select sum(revenue) as totalrevenue
from dbo.sales
where orderstatus = 'completed' and revenue > 0



-- average order value (aov)
-- revenue per invoice, averaged - shows how much a typical order is worth
select avg(invoicerevenue) as averageordervalue
from (
    select invoiceno, sum(revenue) as invoicerevenue
    from dbo.sales
    where orderstatus = 'completed' and revenue > 0
    group by invoiceno
) as perinvoice



-- repeat purchase rate
-- % of known customers (excluding guest checkouts) who ordered more than once
select
    cast(count(distinct case when invoicecount > 1 then customerid end) as float)
    / count(distinct customerid) as repeatpurchaserate
from (
    select customerid, count(distinct invoiceno) as invoicecount
    from dbo.sales
    where orderstatus = 'completed' and revenue > 0 and customerid <> 'guest'
    group by customerid
) as customerorders



-- top 10 customers by revenue
select top 10
    customerid,
    sum(revenue) as totalrevenue,
    count(distinct invoiceno) as totalorders
from dbo.sales
where orderstatus = 'completed' and revenue > 0 and customerid <> 'guest'
group by customerid
order by totalrevenue desc


-- top 10 products by revenue
select top 10
    description,
    sum(quantity) as unitssold,
    sum(revenue) as totalrevenue
from dbo.sales
where orderstatus = 'completed' and revenue > 0
group by description
order by totalrevenue desc


-- revenue by country
select
    country,
    sum(revenue) as totalrevenue,
    count(distinct invoiceno) as totalorders
from dbo.sales
where orderstatus = 'completed' and revenue > 0
group by country
order by totalrevenue desc


-- monthly revenue trend
-- note: this dataset is a single-month slice (dec 2010), so this returns
-- one row here - kept in the script since it would extend automatically
-- if run against the full multi-month dataset
select
    salesyear,
    salesmonth,
    sum(revenue) as monthlyrevenue
from dbo.sales
where orderstatus = 'completed' and revenue > 0
group by salesyear, salesmonth


-- quarterly revenue trend
select
    salesyear,
    salesquarter,
    sum(revenue) as quarterlyrevenue
from dbo.sales
where orderstatus = 'completed' and revenue > 0
group by salesyear, salesquarter
order by salesyear, salesquarter



-- target vs actual + variance
-- this dataset has no real sales targets, so a simple assumption is used:
-- each month's target = first month's revenue, growing 5% month over month.
-- this assumption is stated here and in the project readme.
with monthlyactuals as (
    select
        salesyear,
        salesmonth,
        sum(revenue) as actualrevenue
    from dbo.sales
    where orderstatus = 'completed' and revenue > 0
    group by salesyear, salesmonth
),
rankedmonths as (
    select
        *,
        row_number() over (order by salesyear, salesmonth) as monthindex
    from monthlyactuals
),
firstmonthrevenue as (
    select actualrevenue as baserevenue
    from rankedmonths
    where monthindex = 1
)
select
    r.salesyear,
    r.salesmonth,
    r.actualrevenue,
    round(f.baserevenue * power(1.05, r.monthindex - 1), 2) as targetrevenue,
    round(r.actualrevenue - (f.baserevenue * power(1.05, r.monthindex - 1)), 2) as variance
from rankedmonths r
cross join firstmonthrevenue f
order by r.salesyear, r.monthindex

