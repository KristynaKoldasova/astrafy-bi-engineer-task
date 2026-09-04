# astrafy-bi-Take-Home-challenge
Take home challenge for Astrafy


## Project Overview
This repository contains my solution for the Astrafy BI Engineer Take-Home Challenge.

The solution consists of:

- dbt transformations on BigQuery
- A LookML semantic layer
- A dashboard proposal in data studio
- Sales forecast

---

The solution is built using:

- BigQuery
- dbt
- Git
- LookML 
- Data Studio
- Bigquery ML


## Project Structure

- `astrafy-bi-engineer-task/`
  - `ecommerce_analytics/`
    - `models/`
      - `staging/`
      - `intermediate/`
      - `marts/`
    - `dbt_project.yml`
  - `lookml/`
    - `orders.model.lkml`
    - `orders.view.lkml`
  - `README.md`

The dbt project follows a layered architecture that separates source preparation, reusable transformations, and business-ready models
- **Staging**: source cleaning and column standardization
- **Intermediate**: aggregates the sales table to order level by calculating the total number of products (`qty_products`) for each `order_id`
- **Marts**: final business models used for reporting

---

## Source Data

The source data consists of two tables:

- **orders** : one row per order
- **sales** : one row per product within an order

---

## Initial Data Validation

Before creating any dbt models, I explored the source data to understand its structure and validate its consistency.

The following checks were performed:

- row counts
- table grain
- reconciliation of `net_sales`
- matching `order_id` values between the two source tables

During this validation, I found one `order_id` present in the sales table that does not have a corresponding record in the orders table.

Since the objective of this challenge is to model the provided source data, I did not modify the raw data. The discrepancy is documented and all transformations are based on the original datasets.
I also noticed that the assignment documentation mentions data for 2022 - 2023, whereas the provided datasets contain orders for 2025 - 2026. Since the analytical exercises refer to 2026, I implemented the solution using the dates available in the provided source data.

## Data Modeling

The solution follows a layered dbt architecture

### Staging

- Standardizes raw source tables
- Renames columns using business-friendly naming

### Intermediate

- The int_order_products model aggregates product quantities to one row per order, allowing the fact table to remain at the correct grain

### Mart

- The final business model is: fct_orders

Grain:

- One row represents one order

The fact table contains:

- order_id
- customer_id
- order_date
- net_sales
- qty_products
- order_segmentation

The fact table is optimized for BigQuery by:

- Partitioning on `order_date`
- Clustering on `customer_id`


## Customer Segmentation

Customer segmentation is calculated using a rolling 12-month window.

Segments:

- New
- Returning
- VIP

The logic follows the definitions provided in the assignment.

---


## Data Quality

Generic dbt tests were implemented for key business fields, including:

- unique(order_id)
- not_null(order_id)
- not_null(customer_id)
- not_null(order_date)
- not_null(net_sales)
- not_null(qty_products)
- not_null(order_segmentation)

The project was successfully validated using:

```bash
dbt build
```

## LookML Semantic Layer

A semantic layer was created to provide business-friendly access to the transformed data

The LookML project contains:

- View
- Model
- Explore

The semantic layer exposes dimensions and measures that allow business users to analyse:

sales performance
customer behaviour
customer segmentation

without requiring SQL knowledge

## Dashboard

A business dashboard was created to support daily sales analysis for marketing team

The dashboard includes:

### KPIs

- Total Sales
- Total Orders
- Average Net Sales per Order
- Average Products per Order

## Visualizations
- Monthly Sales 
- Monthly Orders vs Avarage number of orders
- Orders by Customer Segment
- Revenue by Customer Segment

### Dashboard Link:
https://datastudio.google.com/s/tfpatsWgkYQ 

## Bonus : Sales Forecast

As an additional exercise, I implemented a sales forecasting model using BigQuery ML (ARIMA_PLUS).

The model was trained using aggregated historical daily sales from the fct_orders table and generates a 30-day sales forecast.

Because the provided data ends in December 2026, the forecast predicts sales for January 2027.

The forecasted values are visualized in the dashboard alongside the historical sales trend

## Running the Project

To build the models:

```bash
dbt run
```

To execute the tests:

```bash
dbt test
```

To build the project and execute all models and tests:

```bash
dbt build
```

## Assumptions

- The implementation follows the dates available in the provided datasets (2025 - 2026), although the assignment description refers to 2022 - 2023.
- One `order_id` exists in the `sales` table without a corresponding record in the `orders` table. The raw data was not modified, and the `orders` table was treated as the source of truth for the fact table.
- The sales forecast was generated for January 2027 because the historical data ends in December 2026.