{{ config(
    materialized="table"
)}}

WITH pageviews_with_stitched_user_ids AS (
SELECT
  pageview_id,
  visitor_id,
  customer_id,
  COALESCE(
    FIRST_VALUE(customer_id IGNORE NULLS)
        OVER (PARTITION BY visitor_id ORDER BY viewed_at ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
    visitor_id
    ) AS user_id,
  device_type,
  viewed_at,
  page_viewed
FROM
  {{ref('stg_web_tracking__pageviews')}} AS pageviews
),
pageviews_with_session_number_increment AS (
SELECT *,
  IF(
    TIMESTAMP_DIFF (
        viewed_at,
        LAG(viewed_at)
            OVER (PARTITION BY user_id ORDER BY viewed_at ASC),
        SECOND
        )>1800,
    1, 0
    ) AS session_number_increment
FROM pageviews_with_stitched_user_ids
),

pageviews_with_session_id AS (
SELECT * EXCEPT(session_number_increment),
  FARM_FINGERPRINT(
    USER_ID
    ||
    SUM(session_number_increment)
        OVER (PARTITION BY user_id ORDER BY viewed_at ASC)
    ) as session_id
FROM pageviews_with_session_number_increment
)
SELECT
    *,
    FIRST_VALUE(viewed_at)
        OVER (PARTITION BY session_id ORDER BY viewed_at ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
        AS session_start_time,
    LAST_VALUE(viewed_at)
        OVER (PARTITION BY session_id ORDER BY viewed_at ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
        AS session_end_time,
FROM pageviews_with_session_id