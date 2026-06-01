select
    trip_category,
    count(*)                        as total_trips,
    avg(fare_amount)                as avg_fare,
    avg(tip_percentage)             as avg_tip_pct,
    avg(trip_duration_minutes)      as avg_duration,
    avg(revenue_per_minute)         as avg_revenue_per_minute
from {{ ref('fact_trips') }}
group by 1
order by avg_fare desc