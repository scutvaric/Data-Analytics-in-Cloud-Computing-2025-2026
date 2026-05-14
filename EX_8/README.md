# EX_8 — Azure Synapse Analytics Lab

In this exercise you build a small cloud analytics workflow in **Azure Synapse Analytics** using a sample **NYC Taxi Cab Parquet dataset** stored in **Azure Data Lake Storage Gen2**.

You will:
- Create an Azure Synapse workspace
- Create or use an Azure Data Lake Storage Gen2 storage account and `users` file system
- Upload the NYC Taxi sample file named `NYCTripSmall.parquet`
- Query Parquet data with the Built-in serverless SQL pool
- Create a data exploration database and external data source
- Create a serverless Apache Spark pool named `Spark1`
- Analyze NYC Taxi data with Spark notebooks
- Load taxi data into a dedicated SQL pool named `SQLPOOL1`
- Create aggregate tables for passenger-count statistics
- Analyze files in the storage account with Spark and SQL
- Create and monitor a Synapse pipeline
- Connect Power BI to the Synapse workspace

> Full instructions are in `EX_8_instructions.docx`

---

## Platform

This lab uses **Azure Synapse Analytics** in the **Azure portal** and **Synapse Studio**.

Notes:
- You need access to an Azure subscription and a resource group where you have the **Owner** role.
- Some resources, especially dedicated SQL pools and Spark pools, can create Azure costs.
- Pause the dedicated SQL pool when it is no longer needed.
- Replace example names such as `contosolake`, `username-sws`, `users`, `Spark1`, and `SQLPOOL1` with the names used in your own Azure environment.
- If workspace creation fails in one region, try another supported region such as West Germany.

---

## Dataset

This lab uses a small **NYC Taxi Cab Parquet** dataset.

File used:

- `NYCTripSmall.parquet`

Upload the file to the primary storage account connected to your Synapse workspace.

Example storage paths:

```text
https://contosolake.dfs.core.windows.net/users/NYCTripSmall.parquet
abfss://users@contosolake.dfs.core.windows.net/NYCTripSmall.parquet
```

Use your own storage account name instead of `contosolake`.

---

## Lab workflow

1. Create an Azure Synapse workspace in the Azure portal
2. Open Synapse Studio
3. Upload `NYCTripSmall.parquet` to the primary ADLS Gen2 storage account
4. Query the Parquet file with the Built-in serverless SQL pool
5. Create a database named `DataExplorationDB`
6. Create an external data source named `ContosoLake`
7. Create a serverless Apache Spark pool named `Spark1`
8. Load and analyze the NYC Taxi data in a Spark notebook
9. Save Spark results into the `nyctaxi` database
10. Create a dedicated SQL pool named `SQLPOOL1`
11. Load the NYC Taxi data into `dbo.NYCTaxiTripSmall`
12. Create passenger-count aggregate results in `dbo.PassengerCountStats`
13. Write CSV and Parquet outputs back to storage
14. Create and run a Synapse pipeline with a notebook activity
15. Link Power BI to the Synapse workspace and create a report

---

## Serverless SQL output

Use the Built-in serverless SQL pool to query the uploaded Parquet file:

```sql
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://contosolake.dfs.core.windows.net/users/NYCTripSmall.parquet',
        FORMAT='PARQUET'
    ) AS [result];
```

Then create a data exploration database:

```sql
CREATE DATABASE DataExplorationDB
COLLATE Latin1_General_100_BIN2_UTF8;
```

Create an external data source:

```sql
CREATE EXTERNAL DATA SOURCE ContosoLake
WITH (
    LOCATION = 'https://contosolake.dfs.core.windows.net'
);
```

Query the file using the external data source:

```sql
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK '/users/NYCTripSmall.parquet',
        DATA_SOURCE = 'ContosoLake',
        FORMAT='PARQUET'
    ) AS [result];
```

---

## Spark output

Create a serverless Apache Spark pool named `Spark1`, then load the Parquet file in a notebook:

```python
%%pyspark

df = spark.read.load(
    'abfss://users@contosolake.dfs.core.windows.net/NYCTripSmall.parquet',
    format='parquet'
)

display(df.limit(10))
```

Check the schema:

```python
%%pyspark

df.printSchema()
```

Create a Spark database and save the trip data:

```python
%%pyspark

spark.sql("CREATE DATABASE IF NOT EXISTS nyctaxi")
df.write.mode("overwrite").saveAsTable("nyctaxi.trip")
```

Create passenger-count statistics:

```python
%%pyspark

df = spark.sql("""
    SELECT passenger_count,
           SUM(trip_distance) AS SumTripDistance,
           AVG(trip_distance) AS AvgTripDistance
    FROM nyctaxi.trip
    WHERE trip_distance > 0 AND passenger_count > 0
    GROUP BY passenger_count
    ORDER BY passenger_count
""")

display(df)
df.write.saveAsTable("nyctaxi.passengercountstats")
```

---

## Dedicated SQL pool output

Create a dedicated SQL pool named `SQLPOOL1` and load the NYC Taxi data into a table named:

```text
dbo.NYCTaxiTripSmall
```

Create passenger-count statistics:

```sql
SELECT
    passenger_count AS PassengerCount,
    SUM(trip_distance) AS SumTripDistance_miles,
    AVG(trip_distance) AS AvgTripDistance_miles
INTO dbo.PassengerCountStats
FROM dbo.NYCTaxiTripSmall
WHERE trip_distance > 0 AND passenger_count > 0
GROUP BY passenger_count;

SELECT *
FROM dbo.PassengerCountStats
ORDER BY PassengerCount;
```

Suggested visualization:

- View results as a chart
- Category column: `PassengerCount`
- Values: `SumTripDistance_miles` and `AvgTripDistance_miles`

---

## Storage output

Create CSV and Parquet files in the primary storage account from the Spark table:

```python
%%pyspark

df = spark.sql("SELECT * FROM nyctaxi.passengercountstats")
df = df.repartition(1)

df.write.mode("overwrite").csv("/NYCTaxi/PassengerCountStats_csvformat")
df.write.mode("overwrite").parquet("/NYCTaxi/PassengerCountStats_parquetformat")
```

Expected storage folders:

- `NYCTaxi/PassengerCountStats_csvformat`
- `NYCTaxi/PassengerCountStats_parquetformat`

Use Spark or serverless SQL to inspect the generated Parquet file.

---

## Pipeline output

Create a Synapse pipeline that runs a notebook activity.

Pipeline tasks:

1. Go to **Integrate** in Synapse Studio
2. Create a new pipeline
3. Add a **Notebook** activity
4. Select an existing notebook from the workspace
5. Create a trigger that runs every hour
6. Publish the pipeline
7. Use **Trigger now** to run it immediately
8. Monitor the pipeline run in the **Monitor** hub

---

## Power BI output

Create a Power BI workspace and link it to Azure Synapse.

Power BI tasks:

1. Create a Power BI workspace named `NYCTaxiWorkspace1` or similar
2. In Synapse Studio, go to **Manage → Linked Services**
3. Connect to Power BI
4. Create a Power BI dataset from `SQLPOOL1`
5. Load the `PassengerCountStats` table in Power BI Desktop
6. Create a line chart using:
   - Axis: `PassengerCount`
   - Values: `SumTripDistance_miles`, `AvgTripDistance_miles`
7. Publish the report back to the Power BI workspace
8. Open or edit the report from Synapse Studio



## Files in this folder

- `EX_8_instructions.docx`
- `README.md`
