with demographics as (
    select cust_cd, uuid, cif_open_dt, data_dt 
    from {{ ref('stg_cust_demographics') }}
),
logins as (
    select 
        d.cust_cd,
        l.data_dt,
        count(l.event_nm) as login_count
    from {{ ref('stg_insider_combine_view_churn_model') }} l
    join demographics d on l.uuid = d.uuid and l.data_dt = d.data_dt
    where l.event_nm not like '%fail%' and l.event_date >= l.data_dt - 30 
    group by 1, 2
),
transactions as (
    select cust_cd, data_dt, count(rtxn_nbr) as txn_count
    from {{ ref('stg_flat_transaction_churn_model') }}
    where post_dt >= data_dt - 30
    group by 1, 2
),
balances as (
    select cust_cd, data_dt, (casa_bal / 1000000.0) as avg_casa_mil 
    from {{ ref('stg_pj_clm_product') }}
)
select 
    d.cust_cd,
    d.data_dt,
    datediff('day', d.cif_open_dt, d.data_dt) as cif_age_days,
    coalesce(l.login_count, 0) as total_logins_30d,
    coalesce(t.txn_count, 0) as total_txns_30d,
    coalesce(b.avg_casa_mil, 0) as avg_casa_balance_mil
from demographics d
left join logins l on d.cust_cd = l.cust_cd and d.data_dt = l.data_dt
left join transactions t on d.cust_cd = t.cust_cd and d.data_dt = t.data_dt
left join balances b on d.cust_cd = b.cust_cd and d.data_dt = b.data_dt