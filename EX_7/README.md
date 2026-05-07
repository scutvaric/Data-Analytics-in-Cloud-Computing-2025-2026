# EX_7 — Databricks NYC Taxi Lab

In this exercise you build a small cloud analytics and machine learning workflow in **Databricks Free Edition** using the public **NYC TLC Yellow Taxi Trip Records** dataset.

You will:
- Create a Databricks Free Edition workspace and notebook
- Download and load the NYC TLC Yellow Taxi January 2023 Parquet dataset
- Explore and clean NYC Taxi trip data
- Save the cleaned dataset as a table named `nyc_taxi_clean`
- Use Spark SQL to analyze trips, fares, tips, and passenger count
- Create notebook visualizations and a dashboard
- Train a simple Spark MLlib regression model to predict fare amount
- Evaluate the model with RMSE and R²

> Full instructions are in `EX_7_instructions.docx`

---

## Platform

This lab uses **Databricks Free Edition**.

Notes:
- Free Edition is appropriate for this classroom exercise because it supports serverless notebooks and SQL/dashboard capabilities.
- Do not create custom compute resources or use GPU resources for this lab.
- Keep outputs small when needed by using `limit()`.
- Databricks Free Edition may block Spark from reading local files in `/tmp`, so this lab saves the dataset into the current Workspace folder before loading it.

---

## Dataset

This lab uses the **NYC TLC Yellow Taxi Trip Records** dataset.

File used:

- `yellow_tripdata_2023-01.parquet`

The file is downloaded from the public NYC TLC dataset URL and loaded into Databricks from the current Workspace folder.

Use this loading code:

```python
import os
import urllib.request

url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-01.parquet"

workspace_dir = os.getcwd()
local_path = f"{workspace_dir}/yellow_tripdata_2023-01.parquet"

urllib.request.urlretrieve(url, local_path)

df = spark.read.parquet("file:" + local_path)

display(df.limit(10))
df.printSchema()
```
Main columns used in the lab:
- `tpep_pickup_datetime`
- `tpep_dropoff_datetime`
- `trip_distance`
- `fare_amount`
- `tip_amount`
- `passenger_count`

---

## Lab workflow

1. Create a Databricks notebook named `NYC Taxi Cloud Analytics Lab`
2. Download and load the NYC TLC Yellow Taxi Parquet dataset
3. Inspect the schema and confirm the required columns are available
4. Prepare a cleaned dataset called `taxi_clean`
5. Save the cleaned dataset as a table named `nyc_taxi_clean`
6. Run SQL analysis queries against `nyc_taxi_clean`
7. Build visualizations from SQL outputs
8. Create a dashboard named `NYC Taxi Analytics Dashboard`
9. Train a simple linear regression model with Spark MLlib
10. Evaluate the model using RMSE and R²
11. Complete at least two student exercises
---


## Clean table

After cleaning the data, save it as a table:

```python
taxi_clean.write.mode("overwrite").saveAsTable("nyc_taxi_clean")
```
Use this table in all SQL and dashboard queries:

```sql
SELECT *
FROM nyc_taxi_clean
LIMIT 10;
```


## Dashboard output

Create at least three dashboard visualizations:

- Trips by pickup hour
- Average fare by pickup hour
- Trips by passenger count

The dashboard should help answer:
- When are taxi trips most common?
- When are fares higher?
- How does passenger count affect fare or distance?

---

## ML output

Goal: predict `fare_amount`.

Features used in the base model:
- `trip_distance`
- `passenger_count`
- `pickup_hour`
- `pickup_day`
- `pickup_month`

Metrics to report:
- RMSE
- R²

---

## Student exercises

Complete at least two:

1. Add `tip_amount` analysis to the dashboard.
2. Create a chart showing average fare by day of week.
3. Remove `passenger_count` from the ML features and compare RMSE.
4. Filter out very short trips with `trip_distance >= 1` and rerun the model.
5. Explain whether the model is ready for production use.

---

## Final submission

Each student submits:

- Screenshot of cleaned data table
- Screenshot of dashboard
- RMSE and R² values
- Short answer: What did the dashboard show?
- Short answer: What did the ML model try to predict?
- Short answer: Was the model accurate enough? Why or why not?
- Notes for at least two completed exercises

---

## Files in this folder

- `EX_7_instructions.docx`
- `README.md`
