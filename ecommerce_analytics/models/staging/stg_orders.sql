SELECT
orders_id as order_id,
date_date as order_date,
customers_id as customer_id,
CAST(net_sales AS NUMERIC) AS net_sales

from {{ source('raw', 'orders') }}
