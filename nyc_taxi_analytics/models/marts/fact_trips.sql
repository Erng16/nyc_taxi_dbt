{{
  config(
    materialized='incremental',
    unique_key='trip_id',
    on_schema_change='sync_all_columns'
  )
}}
with trips as (
select
    {{ dbt_utils.generate_surrogate_key([
    'pickup_at', 
    'dropoff_at', 
    'pickup_location_id', 
    'dropoff_location_id',
    'fare_amount',
    'trip_distance_miles',
    'total_amount'
    ]) }}                                       as trip_id,
    pickup_at,
    dropoff_at,
    pickup_date,
    pickup_hour,
    pickup_dow,
    pickup_week,
    pickup_month,
    pickup_year,
    passenger_count,
    trip_distance_miles,
    trip_duration_minutes,
    pickup_location_id,
    dropoff_location_id,
    fare_amount,
    extra_amount,
    tolls_amount,
    tip_amount,
    mta_tax,
    improvement_surcharge,
    congestion_surcharge,
    airport_fee,
    total_amount,
    tip_percentage,
    payment_method,
    {{ trip_category('trip_distance_miles') }}  as trip_category,
    round(total_amount / nullif(trip_duration_minutes, 0), 2) as revenue_per_minute

from {{ ref('stage_yellow_taxi_details') }}
),
deduped as (
    select *
    from (
        select *,
            row_number() over (partition by trip_id order by pickup_at) as rn
        from trips
    )
    where rn = 1
)

select * from deduped

{% if is_incremental() %}
  where pickup_at > (select max(pickup_at) from {{ this }})
{% endif %}