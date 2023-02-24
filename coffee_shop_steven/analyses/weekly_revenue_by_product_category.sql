SELECT
    ordered_at_week_beginning,
    product_category,
    SUM(revenue)
FROM {{ ref('sales') }} AS sales
GROUP BY ordered_at_week_beginning, product_category