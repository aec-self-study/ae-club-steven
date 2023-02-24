{{ config(
    materialized="table"
)}}

SELECT
  customers.id AS customer_id,
  name,
  email,
  MIN(orders.ordered_at) AS first_order_at,
  MAX(orders.ordered_at) AS last_order_at,
  COUNT(DISTINCT orders.id) AS number_of_orders
FROM
  {{ ref('stg_coffee_shop__customers') }} AS customers
LEFT JOIN
  {{ ref('stg_coffee_shop__orders') }} AS orders
ON
  customers.id = orders.customer_id
GROUP BY
  customers.id,
  name,
  email
ORDER BY
  first_order_at
