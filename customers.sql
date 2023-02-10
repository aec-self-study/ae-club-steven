SELECT
  customers.id AS customer_id,
  name,
  email,
  MIN(orders.created_at) AS first_order_at,
  MAX(orders.created_at) AS last_order_at,
  COUNT(DISTINCT orders.id) AS number_of_orders
FROM
  `analytics-engineers-club.coffee_shop.customers` AS customers
LEFT JOIN
  `analytics-engineers-club.coffee_shop.orders` AS orders
ON
  customers.id = orders.customer_id
GROUP BY
  customers.id,
  name,
  email
ORDER BY
  first_order_at
LIMIT
  314
