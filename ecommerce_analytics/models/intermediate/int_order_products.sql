SELECT 

order_id ,
sum(qty) as qty_products,
from {{ ref('stg_sales') }}
group by order_id