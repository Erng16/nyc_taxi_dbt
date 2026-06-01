with source as (
    select * from {{ source('raw', 'raw_yellow_taxi') }}
),
cleaned as (
    select 
        tpep_pickup_datetime                                            as pickup_at,
        tpep_dropoff_datetime                                           as dropoff_at,
        cast(tpep_pickup_datetime as date)                              as pickup_date,
        date_part('hour', tpep_pickup_datetime)                         as pickup_hour,
        date_part('dow', tpep_pickup_datetime)                          as pickup_dow,
        date_part('week', tpep_pickup_datetime)                         as pickup_week,
        date_part('month', tpep_pickup_datetime)                       as pickup_month,
        date_part('year', tpep_pickup_datetime)                         as pickup_year,

        passenger_count,
        round(trip_distance, 2)                                         as trip_distance_miles,
        date_diff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) as trip_duration_minutes,
        PULocationID                                                    as pickup_location_id,
        DOLocationID                                                    as dropoff_location_id,

        fare_amount,
        extra                                                           as extra_amount,
        tolls_amount,
        tip_amount,
        mta_tax,
        improvement_surcharge,
        congestion_surcharge,
        airport_fee,
        total_amount,
        round(tip_amount / nullif(fare_amount, 0), 2)                   as tip_percentage,

        case 
            when payment_type = 1 then 'Credit Card'
            when payment_type = 2 then 'Cash'
            when payment_type = 3 then 'No Charge'
            when payment_type = 4 then 'Dispute'
            when payment_type = 5 then 'Unknown'
            when payment_type = 6 then 'Voided Trip'
            else 'Other'
        end                                                             as payment_method

    from source
    where tpep_pickup_datetime is not null
    and tpep_dropoff_datetime is not null
    and tpep_pickup_datetime between '2024-01-01' and '2024-03-31'
    and tpep_dropoff_datetime > tpep_pickup_datetime
    and fare_amount > 0
    and trip_distance > 0
    and passenger_count > 0
    and total_amount > 0
    and tip_amount >= 0
    and extra >= 0
    and tolls_amount >= 0
    and mta_tax >= 0
    and improvement_surcharge >= 0
    and congestion_surcharge >= 0
    and airport_fee >= 0
    and date_diff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) between 1 and 180     
)

select * from cleaned