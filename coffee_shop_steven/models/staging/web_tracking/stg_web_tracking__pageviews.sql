with source as (

    select * from {{ source('web_tracking', 'pageviews') }}

),

renamed as (

    select
        id AS pageview_id,
        visitor_id,
        device_type,
        timestamp AS viewed_at,
        customer_id,
        page AS page_viewed

    from source

)

select * from renamed