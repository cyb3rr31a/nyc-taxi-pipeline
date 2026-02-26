with trips as (
    SELECT * FROM {{ ref('stg_trips') }}
)

SELECT
    extract(hour from pickup_datetime)  as hour_of_day,
    count(*)                            as total_trips,
    round(avg(fare_amount), 2)          as avg_fare
FROM trips
group by hour_of_day
order by hour_of_day