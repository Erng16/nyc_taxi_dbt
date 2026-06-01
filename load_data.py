import duckdb

con = duckdb.connect("nyc_taxi.duckdb")

con.execute("""
  CREATE TABLE raw_yellow_taxi AS
  SELECT * FROM read_parquet([
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-02.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-03.parquet'
  ])
""")