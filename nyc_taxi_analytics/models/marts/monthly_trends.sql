select
    pickup_year,
    pickup_month,
    count(*)                                as total_trips,
    sum(total_amount)                       as total_revenue,
    avg(total_amount)                       as avg_fare,
    avg(trip_distance_miles)                as avg_distance,
    avg(trip_duration_minutes)              as avg_duration,
    sum(passenger_count)                    as total_passengers,
    countif(payment_method = 'Credit Card') as credit_card_trips,
    countif(payment_method = 'Cash')        as cash_trips
from {{ ref('fact_trips') }}
group by 1, 2
order by 1, 2