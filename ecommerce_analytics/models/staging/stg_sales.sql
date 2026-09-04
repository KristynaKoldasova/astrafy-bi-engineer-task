SELECT 
date_date as order_date,
customer_id ,
order_id,
products_id as product_id,
cast(net_sales as NUMERIC) as net_sales,
qty
from {{source('raw','sales')}}