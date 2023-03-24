{%- set coffee_types=['coffee beans', 'merch', 'brewing supplies'] -%}
select
  date_trunc(ordered_at, month) as date_month,
  {%- for coffee_type in coffee_types %}
  sum(case when product_category = '{{coffee_type}}' then revenue end) as {{coffee_type | replace(" ", "_")}}_amount,
  {%- endfor %}
from {{ ref('sales') }}
group by 1