select
    cust_cd,
    casa_bal,
    term_deposit_bal,
    strptime(cast(data_dt as varchar), '%Y%m%d')::date as data_dt
from {{ source('tmo', 'stg_pj_clm_product') }}