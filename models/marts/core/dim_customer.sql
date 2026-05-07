with demographics as (
    select * from {{ ref('stg_cust_demographics') }}
),
latest_demographics as (
    select *, row_number() over (partition by cust_cd order by data_dt desc) as rn
    from demographics
)
select 
    cust_cd, gender, datebirth, cif_open_dt, service_segment,
    is_emp, province_residence, domicile_country
from latest_demographics
where rn = 1