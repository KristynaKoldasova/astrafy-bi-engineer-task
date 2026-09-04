{{
    config(
        materialized = 'table',
        partition_by = {
            "field": "order_date",
            "data_type": "date"
        },
        cluster_by = ["customer_id"]
    )
}}

with history_orders as 
 (

    select
        oo.order_id,
        count(o2.order_id) as p_orders_12m

    from {{ ref('stg_orders') }} oo

    left join {{ ref('stg_orders') }} o2
        on oo.customer_id = o2.customer_id
        and o2.order_date < oo.order_date
        and o2.order_date >= date_sub(oo.order_date, interval 12 month)

    group by oo.order_id

)
SELECT 
o.order_id,
o.order_date,
coalesce(p.qty_products,0) as qty_products,
CASE 
when ho.p_orders_12m =0 then "New"
when ho.p_orders_12m between 1 AND 3 then "Returning"
else  "VIP" end as order_segmentation,


o.customer_id,
o.net_sales


from {{ref('stg_orders')}} as o
left join {{ref('int_order_products')}} as p on o.order_id=p.order_id
left join history_orders as ho on ho.order_id=o.order_id