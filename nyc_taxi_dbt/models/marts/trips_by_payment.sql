with trips as (
    SELECT * FROM {{ ref('stg_trips') }}
)

select
    payment_type,
    count(*)                                                        as total_trips,
    round(avg(tip_amount / nullif(fare_amount, 0) * 100), 2)       as avg_tip_pct
from trips
group by payment_type
order by payment_type