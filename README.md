# NYC Taxi Analytics
An end-to-end data engineering project analyzing ~10 million NYC yellow taxi using dbt and DuckDB.

## Project Overview
This project builds an analytic pipeline on NYC TLC yellow taxi trip data from January-March 2024, demonstrating data engineering skills including data modeling, incremental loading, data quality testing, and visualization.

## Live Dashboard
[View on Streamlit](https://erng-16-nyc-taxi-dbt-dashboard-00001.streamlit.app/)

## Tech Stack
| Tool | Purpose |
|---|---|
| **dbt** | Data transformation and modeling |
| **DuckDB** | Local Data Warehouse |
| **Python** | Data loading |
| **SQL** | Data transformation and analysis|
| **Streamlit** | Dashboard and visualization |
| **Plotly** | Interactive charts |

## Project Structure

```
nyc_taxi_analytics/
├── models/
│   ├── staging/
│   │   └── stage_yellow_taxi_details.sql  # cleaning, filtering
│   └── marts/
│       ├── fact_trips.sql                 # core fact table (incremental), trip_id generation + record deduplication
│       ├── hourly_demand.sql              # trips by hour and day of week
│       ├── monthly_trends.sql             # monthly aggregations
│       ├── trip_category_summary.sql      # analysis by trip distance category
│       └── schema.yml                     # tests and documentation
├── macros/
│   └── trip_category.sql                  # custom trip distance macro
├── packages.yml                           # dbt_utils dependency
└── dbt_project.yml                        # project configuration
```
## Data Quality Issues Found & Fixes
- **Timestamp anomolies:** raw data contained 19 records with years ranging from 2002 to 2023, possibly due to taxi meter malfunctions or clock resets when meters are replaced. Since the dataset is intended to cover only 2024 data and further confirmation is not possible without additional context from the source system, these records were filtered out in the staging layer. Given that these 19 records represent only 0.0002% of the total 9.5M trips, the impact on overall analysis is negligible.
- **Timezone edge cases** — 2 records appeared with an April 2024 timestamp, likely due to trips occurring near midnight on March 31st being recorded in UTC rather than Eastern Time. Since further confirmation is not possible without access to the source system's timezone configuration, and given that this project covers January to March 2024 only, these records were filtered out in the staging layer alongside the year filter using `tpep_pickup_datetime between '2024-01-01' and '2024-03-31'`. Given the negligible count of 2 records, the impact on overall analysis is negligible.
