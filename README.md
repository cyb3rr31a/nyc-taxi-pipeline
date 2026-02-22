# NYC Taxi Data Pipeline

An end-to-end data pipeline that ingests, cleans, and analyzes NYC Yellow Taxi trip data from the [TLC Trip Record Dataset](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page). Built as a portfolio project to demonstrate core data engineering skills.

## What it does

- **Extracts** raw taxi trip data from the NYC TLC dataset (Parquet format)
- **Transforms** and cleans the data using pandas — removing outliers, bad records, and out-of-range values
- **Loads** the cleaned data into a local SQLite database
- **Analyzes** the data with SQL queries
- **Visualizes** results with matplotlib

## Key findings

- Trips peak during **morning and evening rush hours** (8AM and 6PM)
- **Credit card** payments account for the vast majority of tips — cash tips are not digitally recorded
- A small number of location IDs account for a disproportionate share of pickups
- Average fares are consistent across passenger counts, suggesting distance matters more than group size

## Data cleaning steps

The raw dataset contains a number of quality issues that are addressed in the pipeline:

| Issue | Fix |
|---|---|
| `passenger_count` of 0 or null | Dropped |
| `trip_distance` of 0 or over 100 miles | Dropped |
| Negative `fare_amount` | Dropped |
| Trips outside January 2025 | Dropped |
| Negative or unrealistically long durations (3hr+) | Dropped |
| Derived column `trip_duration_minutes` | Added |

Approximately 15% of rows were removed during cleaning.

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/your-username/nyc-taxi-pipeline.git
cd nyc-taxi-pipeline
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Download the data

Go to [nyc.gov/site/tlc/about/tlc-trip-record-data.page](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page), scroll to 2025, and download the **Yellow Taxi** data for January. Save the file as `yellow_tripdata_2024-01.parquet` in the project folder.

### 4. Run the notebook

```bash
jupyter notebook
```

Open `nyc_taxi.ipynb` and run all cells from top to bottom.

## Project structure

```
nyc-taxi-pipeline/
├── nyc_taxi.ipynb              # Main notebook — cleaning, loading, queries, visualizations
├── .gitignore                  # Ignores large data files and local database
├── requirements.txt            # Python dependencies
└── README.md                   # This file
```

## Dependencies

- `pandas` — data manipulation and cleaning
- `pyarrow` — reading Parquet files
- `matplotlib` — visualizations
- `sqlite3` — built into Python, no install needed
- `jupyter` — running the notebook