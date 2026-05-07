select
    cust_cd,
    uuid,
    strptime(cast(data_dt as varchar), '%Y%m%d')::date as data_dt,
    active_status,
    service_segment,
    
    -- Cập nhật hàm parse chuỗi YYYYMMDD thành Date
    strptime(cast(cif_open_dt as varchar), '%Y%m%d')::date as cif_open_dt,
    
    branch_nbr,
    is_emp,
    gender,             
    datebirth,          
    domicile_country,   
    'TP. HCM' as province_residence 
from {{ source('tmo', 'stg_cust_demographics') }}