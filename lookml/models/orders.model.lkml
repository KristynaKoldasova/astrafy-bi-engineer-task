connection: "bigquery_connection"

include: "/views/*.view.lkml"

explore: orders {
  label: "Orders"
  description: "Explore for analysing orders, sales and customer segmentation."
}