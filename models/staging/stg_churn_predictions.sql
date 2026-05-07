with source as (
    select * from {{ source('tmo', 'stg_churn_predictions') }}
)

select
    cust_cd,
    -- Đảm bảo probability luôn ở dạng float/numeric để tính toán an toàn
    cast(churn_probability as DOUBLE) as churn_probability,
    
    -- Giả định ép kiểu ngày tháng (bạn có thể thay thế bằng macro xử lý Excel date nếu cần)
    strptime(cast(data_dt as varchar), '%Y%m%d')::date as data_dt
    
from source