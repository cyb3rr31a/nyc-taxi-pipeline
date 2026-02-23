SELECT *
FROM {{ ref('stg_trips') }}
WHERE fare_amount < 0