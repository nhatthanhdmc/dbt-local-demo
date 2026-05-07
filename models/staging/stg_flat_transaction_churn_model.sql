select
    acct_nbr,
    rtxn_nbr,
    cust_cd,
    tran_amt,
    strptime(cast(post_dt as varchar), '%Y%m%d')::date as post_dt,
    strptime(cast(data_dt as varchar), '%Y%m%d')::date as data_dt,
    mcc
from {{ source('tmo', 'stg_flat_transaction_churn_model') }}
where cust_type = 'CN'
  and mjaccttypcd in ('SAV','CK') 
  and rtxnsourcecd in ('ONLI','MAPP','WWW')