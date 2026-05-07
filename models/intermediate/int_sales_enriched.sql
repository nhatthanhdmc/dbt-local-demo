with sales as ( select * from {{ ref('raw_sales') }} ),
customers as ( select * from {{ ref('stg_customers') }} )
select s.order_id, s.customer_id, c.customer_name, s.order_date, s.revenue,
    case when s.revenue > 1000 then 'VIP' else 'Standard' end as order_category
from sales s left join customers c on s.customer_id = c.customer_id