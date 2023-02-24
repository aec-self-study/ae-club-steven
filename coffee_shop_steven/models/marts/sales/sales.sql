{{ config(
    materialized="table"
)}}

SELECT
      order_items.id AS sale_id,
      orders.ordered_at,
      orders.ordered_at_week_beginning,
      orders.customer_id,
      orders.customer_was_new_or_returning,
      products.category AS product_category,
      product_prices.price AS revenue
FROM
    {{ ref('stg_coffee_shop__order_items') }} AS order_items
LEFT JOIN
    {{ ref('stg_coffee_shop__orders') }} AS orders
    ON order_items.order_id = orders.id
LEFT JOIN 
    {{ ref('stg_coffee_shop__products') }} AS products
    ON order_items.product_id = products.id
LEFT JOIN
    {{ ref('stg_coffee_shop__product_prices') }} AS product_prices
    ON products.id = product_prices.product_id
        AND orders.ordered_at >= product_prices.created_at
        AND (
            orders.ordered_at < product_prices.ended_at
            OR product_prices.ended_at IS NULL
            )
