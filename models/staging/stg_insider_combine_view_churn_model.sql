select
    uuid,
    event_nm,
    -- Ép kiểu số thập phân thành timestamp/date tùy hệ thống
    strptime(cast(event_tm as varchar), '%Y%m%d')::date as event_date, 
    strptime(cast(data_dt as varchar), '%Y%m%d')::date as data_dt
from {{ source('tmo', 'stg_insider_combine_view_churn_model') }}