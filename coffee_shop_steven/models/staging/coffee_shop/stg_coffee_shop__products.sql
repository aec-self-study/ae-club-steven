with source as (

    select * from {{ source('coffee_shop', 'products') }}

),

renamed as (

    select
        id,
        name,
        category,
        created_at

    from source

)

select * from renamed