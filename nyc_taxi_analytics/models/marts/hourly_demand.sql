select
    pickup_hour,
    case pickup_dow
        when 0 then 'Sunday'
        when 1 then 'Monday'
        when 2 then 'Tuesday'
        when 3 then 'Wednesday'
        when 4 then 'Thursday'
        when 5 then 'Friday'
        when 6 then 'Saturday'
    end                             as day_of_week,
    count(*)                        as total_trips,
    avg(trip_duration_minutes)      as avg_duration_minutes,
    avg(total_amount)               as avg_fare,
    avg(tip_percentage)             as avg_tip_pct
from {{ ref('fact_trips') }}
group by 1, 2
order by 1                              