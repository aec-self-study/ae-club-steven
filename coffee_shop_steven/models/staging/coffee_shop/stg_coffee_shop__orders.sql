with source as (

    select * from {{ source('coffee_shop', 'orders') }}

),

renamed as (

    select
        id,
        created_at AS ordered_at,
        customer_id,
        -- total,
        -- address,
        -- state,
        -- zip

    from source

)

select 
    *,
    DATE_TRUNC(ordered_at, WEEK) AS ordered_at_week_beginning,
    IF(
        ordered_at = FIRST_VALUE(ordered_at) OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
        , "new", "returning") AS customer_was_new_or_returning
from renamed