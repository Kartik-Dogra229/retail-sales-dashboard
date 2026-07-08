# 📊 Retail Sales Performance Analysis

## 📌 Problem Statement
Retail sales data needed to be analyzed to understand which regions and
product categories were performing well and which were declining, in
order to guide business and inventory decisions.

## 🎯 Objective
Analyze retail sales data end-to-end — from raw data cleaning to an
interactive dashboard — to identify trends, top/bottom performing
regions and categories, and provide data-backed recommendations.

## 🗂️ Dataset
- File: `data/raw/retail_sales_raw.csv`
- Source: Provided during training
- Rows: 2100 | Columns: 8

## 🛠️ Tools Used
- **SQL** — data extraction & aggregation
- **Python (Pandas, Matplotlib, Seaborn)** — cleaning & exploratory data analysis
- **Power BI** — interactive dashboard

## 🔄 Project Workflow
1. Collected and reviewed raw sales data
2. Wrote SQL queries to aggregate revenue by region and identify top products
3. Cleaned and explored the data in Python (nulls, duplicates, trends, visualizations)
4. Built an interactive Power BI dashboard to visualize KPIs and trends

## 🧮 SQL Analysis
- Calculated total revenue by region
- Identified top-performing products by profit margin using ranking
👉 [View SQL file](./SQL/sales_analysis_queries.sql)

## 🐍 Python Analysis
- Cleaned the raw dataset (handled missing values and duplicates)
- Explored sales trends and category performance with visualizations
👉 [View notebook](./Python/data_cleaning_eda.ipynb)

## 📊 Power BI Dashboard
![Power BI Dashboard](./Images/dashboard_overview.png)

📂 [Download the .pbix file](./PowerBI/Sales_Dashboard.pbix)

## 💡 Key Insights
-Revenue is customer-concentrated: the top 10 customers (of 70 identified) drive 41% of total revenue — a retention risk if any are lost.
-Repeat purchase rate is low, at 8.6% — most customers in this window bought only once, reinforcing the concentration risk above.
-Products are broadly spread: the top 10 products account for only ~20% of revenue, so this isn't a single-hero-product business.
-Revenue is heavily UK-concentrated (89%), with Norway a distant second — worth flagging as either an intentional market focus or an unexplored growth gap.

## ✅ Business Recommendations
-Build a retention program targeting top customers (top 10 = 41% of revenue)
-Investigate why repeat purchase rate is low (8.6%)
-Push guest checkouts to create accounts (26% currently untracked)
-Decide if UK-heavy revenue (89%) is intentional or a growth gap
-Keep marketing spend spread across products, not concentrated on a few

## 🚀 Future Improvements
- Automate dashboard refresh with scheduled data updates
- Expand analysis with customer segmentation

## 📬 Contact
Kartik Dogra |www.linkedin.com/in/kartik-dogra-120019416 | kartikdogra229720@gmail.com
