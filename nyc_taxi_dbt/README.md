# nyc_taxi_dbt

The dbt transformation layer for the NYC Taxi Pipeline project. Takes raw Yellow Taxi trip data loaded into BigQuery and transforms it into clean, tested, analysis-ready tables.

> This is a subfolder of the [NYC Taxi Pipeline](../README.md) project. See the root README for the full project overview including the local pandas/SQLite pipeline.

![Lineage Graph](../assets/lineage.png)

## What it does

- **Stages** raw trip data into a clean, consistently named base model
- **Transforms** staged data into three analysis-ready mart tables
- **Tests** data quality automatically on every run
- **Documents** every model and column with auto-generated documentation

## Project structure

```
nyc_taxi_dbt/
├── models/
│   ├── staging/
│   │   ├── stg_trips.sql             # Cleans and renames raw data
│   │   ├── stg_trips.yml             # Column descriptions and tests
│   │   └── sources.yml               # Points dbt to the raw BigQuery table
│   └── marts/
│       ├── trips_daily.sql           # Trips and fares aggregated by day
│       ├── trips_by_hour.sql         # Trips and fares aggregated by hour
│       ├── trips_by_payment.sql      # Trips and tip % by payment type
│       └── marts.yml                 # Column descriptions and tests
├── tests/
│   └── assert_no_negative_fares.sql  # Custom data quality test
├── dbt_project.yml                   # Main dbt configuration
├── profiles.yml.example              # Connection config template
└── README.md                         # This file
```

## Data lineage

```
BigQuery (trips_raw)
    └── stg_trips (view)
            ├── trips_daily (table)
            ├── trips_by_hour (table)
            └── trips_by_payment (table)
```

Staging models are materialized as **views** — lightweight and always up to date. Mart models are materialized as **tables** — optimized for query performance.

## Models

### Staging

**`stg_trips`** — Base model that selects from the raw BigQuery table, renames columns to snake_case, and casts types. All downstream models build on this.

### Marts

**`trips_daily`** — Total trips, average fare, and average distance grouped by day. Useful for identifying weekly patterns and day-of-week trends.

**`trips_by_hour`** — Total trips and average fare grouped by hour of day. Shows peak demand periods throughout the day.

**`trips_by_payment`** — Trip counts and average tip percentage broken down by payment type. Highlights the difference in tipping behavior between cash and card.

## Data tests

| Test | Model | Column |
|---|---|---|
| not_null | stg_trips | pickup_datetime, dropoff_datetime, passenger_count, fare_amount, payment_type, trip_distance |
| accepted_values (1-6) | stg_trips | payment_type |
| not_null + unique | trips_daily | trip_date |
| not_null + unique | trips_by_hour | hour_of_day |
| not_null + unique | trips_by_payment | payment_type |
| no negative fares | stg_trips | fare_amount |

## Setup

### 1. Install dbt

```bash
pip install dbt-bigquery
```

### 2. Set up BigQuery

- Create a Google Cloud project at [console.cloud.google.com](https://console.cloud.google.com)
- Enable the BigQuery API
- Create a dataset called `nyc_taxi`
- Upload your cleaned parquet file as a table called `trips_raw`

### 3. Configure your profile

```bash
cp profiles.yml.example profiles.yml
```

Edit `profiles.yml` and replace `your-gcp-project-id` with your actual Google Cloud project ID:

```yaml
nyc_taxi_dbt:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: your-gcp-project-id
      dataset: nyc_taxi
      threads: 1
      timeout_seconds: 300
      location: US
```

### 4. Authenticate

```bash
gcloud auth application-default login
```

### 5. Test the connection

```bash
dbt debug
```

All checks should pass.

### 6. Run the pipeline

```bash
dbt build
```

Runs all models and tests in the correct order. You should see all models created and all tests passing.

### 7. View documentation

```bash
dbt docs generate
dbt docs serve
```

Opens a documentation site at `http://localhost:8080` with model descriptions, column definitions, and the interactive lineage graph.

## Dependencies

- `dbt-bigquery` — dbt core with the BigQuery connector
- Google Cloud account with BigQuery enabled