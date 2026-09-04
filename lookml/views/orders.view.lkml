view: orders {

  sql_table_name: analytics.fct_orders ;;


dimension: order_id {
  primary_key: yes
  type: number
  sql: ${TABLE}.order_id ;;
  description: "Unique identifier of the order."
}

dimension_group:order_date {
    type:time
    timeframes: [date,week,month, quarter, year] 
    sql:${TABLE}.order_date;;
    description: "Order date"
}

dimension: customer_id {
  type: number
  sql: ${TABLE}.customer_id ;;
  description: "Unique identifier of the customer."
}

dimension:net_sales  {
    type:number
    sql:${TABLE}.net_sales ;;
    value_format_name:eur ;;
    description: "Net sale per the order"

}
dimension: order_segmentation {
    type:string
    sql: ${TABLE}.order_segmentation;;
    description: "Customer Segmentation  based on the number of previous orders placed during the last 12 months"
    
}
dimension:qty_products {
    type: number
    sql:${TABLE}.qty_products ;;
    description: " Number of products sold in the order"

}

measure: count_orders {
type:count

}

measure:average_products_per_order {
type:avarage
sql:${qty_products};;
}

measure:avarage_net_sales {
type:avarage
sql:${net_sales};;
value_format_name:eur
}

measure:total_sales {
    type:sum
    sql:${net_sales};;
    value_format_name:eur
}

}