{{ config(
    materialized="table"
)}}

SELECT
    session_id,
    visitor_id,
    user_id,
    MIN(viewed_at) AS session_start_time,
    MAX(viewed_at) AS session_end_time,
    COUNT(DISTINCT page_viewed) AS number_of_pages_visited,
    LOGICAL_OR(page_viewed = "order-confirmation") AS purchased
FROM {{ref('pageviews')}} AS pageviews
GROUP BY session_id, visitor_id, user_id