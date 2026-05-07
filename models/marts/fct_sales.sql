{{ config(materialized='table') }} 
with enriched_sales as ( select * from {{ ref('int_sales_enriched') }} )
select order_id, customer_id, order_date, revenue, order_category from enriched_sales