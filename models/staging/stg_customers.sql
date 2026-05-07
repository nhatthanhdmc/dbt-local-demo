with source as ( select * from {{ ref('raw_customers') }} ),
renamed as (
    select id as customer_id, trim(full_name) as customer_name,
    cast(created_date as date) as registration_date, coalesce(status, 'Unknown') as customer_status
    from source
)
select * from renamed