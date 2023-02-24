SELECT
    ordered_at_week_beginning,
    customer_was_new_or_returning,
    SUM(revenue)
FROM {{ ref('sales') }} AS sales
GROUP BY ordered_at_week_beginning, customer_was_new_or_returning