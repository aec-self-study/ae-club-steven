{{ config(
    materialized="table"
)}}

SELECT
    DATE_TRUNC(first_order_at, MONTH) AS month_beginning,
    COUNT(DISTINCT customer_id) AS number_of_new_customers
FROM
    {{ref('customers')}}
GROUP BY
    month_beginning
