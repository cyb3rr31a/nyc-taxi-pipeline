with trips as (
    select * from {{ ref('stg_trips') }}
)

SELECT
    date(pickup_datetime)       as trip_date,
    count(*)                    as total_trips,
    round(avg(fare_amount), 2)  as avg_fare,
    round(avg(trip_distance), 2) as avg_distance
FROM trips
group by trip_date
order by trip_date