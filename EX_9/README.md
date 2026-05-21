# EX_9 — BigQuery + Looker Studio Lab

In this exercise you build a small cloud analytics dashboard workflow using **Google BigQuery** and **Looker Studio** with the public **Superstore CSV** dataset.

You will:
- Create or select a Google Cloud project
- Create a BigQuery dataset named `analytics_lab`
- Download and upload the Superstore CSV dataset
- Create a native BigQuery table named `superstore`
- Use schema auto-detection during CSV upload
- Run SQL queries for counts, KPIs, sales by region, profit by category, and sales over time
- Create a clean reporting view named `vw_superstore_clean`
- Connect Looker Studio to the BigQuery view
- Build a dashboard with KPI cards, charts, and filters

> Full instructions are in `EX_9_instructions.docx`

---

## Platform

This lab uses **Google BigQuery** and **Looker Studio**.

Notes:
- Use a Google Cloud project named something like `analytics-lab-yourname`.
- Create the BigQuery dataset in the **EU** region.
- Use `Auto detect` when uploading the CSV file.
- Use the clean view `vw_superstore_clean` as the Looker Studio data source.

---

## Dataset

This lab uses the public **Superstore CSV** dataset.

Download URL:

```text
https://raw.githubusercontent.com/plotly/datasets/master/superstore.csv
```

Save the file as:

```text
Superstore.csv
```

Main columns used in the lab:
- `Order ID`
- `Order Date`
- `Ship Date`
- `Ship Mode`
- `Customer Name`
- `Segment`
- `Region`
- `Category`
- `Sub-Category`
- `Sales`
- `Quantity`
- `Discount`
- `Profit`

---

## Lab workflow

1. Create or select a Google Cloud project
2. Create a BigQuery dataset named `analytics_lab`
3. Download `Superstore.csv`
4. Upload the CSV into BigQuery as a native table named `superstore`
5. Preview the uploaded table
6. Run the first SQL query
7. Count records
8. Create KPI summary query
9. Analyze sales by region
10. Analyze profit by category
11. Analyze sales over time
12. Create the clean reporting view `vw_superstore_clean`
13. Connect Looker Studio to BigQuery
14. Build the dashboard
15. Add dashboard filters
16. Complete at least two student exercises

---

## BigQuery setup

Dataset:

```text
analytics_lab
```

Table:

```text
superstore
```

View:

```text
vw_superstore_clean
```

First test query:

```sql
SELECT *
FROM `analytics_lab.superstore`
LIMIT 20;
```

If needed, use the full table name shown by BigQuery:

```sql
SELECT *
FROM `analytics-lab-yourname.analytics_lab.superstore`
LIMIT 20;
```

---

## Main SQL queries

Record count:

```sql
SELECT COUNT(*) AS total_rows
FROM `analytics_lab.superstore`;
```

KPI query:

```sql
SELECT
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  SUM(Quantity) AS total_quantity,
  COUNT(DISTINCT `Order ID`) AS total_orders
FROM `analytics_lab.superstore`;
```

Sales by region:

```sql
SELECT
  Region,
  ROUND(SUM(Sales), 2) AS total_sales
FROM `analytics_lab.superstore`
GROUP BY Region
ORDER BY total_sales DESC;
```

Profit by category:

```sql
SELECT
  Category,
  ROUND(SUM(Profit), 2) AS total_profit
FROM `analytics_lab.superstore`
GROUP BY Category
ORDER BY total_profit DESC;
```

Sales over time:

```sql
SELECT
  EXTRACT(YEAR FROM PARSE_DATE('%m/%d/%Y', `Order Date`)) AS order_year,
  ROUND(SUM(Sales), 2) AS total_sales
FROM `analytics_lab.superstore`
GROUP BY order_year
ORDER BY order_year;
```

---

## Clean reporting view

Create this view for Looker Studio:

```sql
CREATE OR REPLACE VIEW `analytics_lab.vw_superstore_clean` AS
SELECT
  `Order ID` AS order_id,
  PARSE_DATE('%m/%d/%Y', `Order Date`) AS order_date,
  Region AS region,
  Category AS category,
  `Sub-Category` AS sub_category,
  `Ship Mode` AS ship_mode,
  Segment AS segment,
  Sales AS sales,
  Profit AS profit,
  Quantity AS quantity,
  Discount AS discount
FROM `analytics_lab.superstore`;
```

Test the view:

```sql
SELECT *
FROM `analytics_lab.vw_superstore_clean`
LIMIT 20;
```

> If BigQuery auto-detects `Order Date` as a DATE field instead of text, use `` `Order Date` AS order_date `` instead of `PARSE_DATE(...) AS order_date`.

---

## Dashboard output

Create these Looker Studio elements:

KPI scorecards:
- Total Sales: `sales` → SUM
- Total Profit: `profit` → SUM
- Total Orders: `order_id` → COUNT_DISTINCT
- Total Quantity: `quantity` → SUM

Charts:
- Sales by region: bar chart, dimension `region`, metric `sales`, SUM
- Profit by category: column chart, dimension `category`, metric `profit`, SUM
- Sales over time: time series, dimension `order_date`, metric `sales`, SUM
- Sales by sub-category: table or bar chart, dimension `sub_category`, metric `sales`, SUM

Filters:
- `region`
- `category`
- `ship_mode`
- `segment`

---

## Student exercises

Complete at least two:

1. Add a profit margin calculated field.
2. Create a chart showing sales by segment.
3. Create a table showing sales and profit by sub-category.
4. Add a date range control.
5. Explain how this dashboard could support business decisions.

---

## Final submission

Each student submits:

- Screenshot of BigQuery table upload screen or table preview
- Screenshot of at least two SQL query results
- Screenshot of the Looker Studio dashboard
- Short answer: Which region has the highest sales?
- Short answer: Which category has the highest profit?
- Short answer: How do sales change over time?
- Short answer: How can this dashboard support business decisions?
- Notes for at least two completed student exercises

---

## Files in this folder

- `EX_9_instructions.docx`
- `README_EX_9.md`
