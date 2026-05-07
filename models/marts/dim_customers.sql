{{ config(materialized='table') }}
-- Đẩy thẳng data từ Staging ra Mart nếu không có tính toán gì thêm
select * from {{ ref('stg_customers') }}