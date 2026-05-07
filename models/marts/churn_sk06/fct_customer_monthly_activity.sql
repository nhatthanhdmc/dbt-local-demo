with rfm_metrics as (
    select * from {{ ref('int_rfm_30d_metrics') }}
),
demographics as (
    select cust_cd, data_dt, branch_nbr 
    from {{ ref('stg_cust_demographics') }}
),
churn_preds as (
    select cust_cd, data_dt, churn_probability 
    from {{ ref('stg_churn_predictions') }}
),
fact_base as (
    select 
        rfm.data_dt, rfm.cust_cd, d.branch_nbr,
        rfm.cif_age_days, rfm.total_logins_30d, rfm.total_txns_30d, rfm.avg_casa_balance_mil,
        case 
            when rfm.cif_age_days <= 90 then 'INACTIVE'
            when rfm.total_logins_30d > 30 and rfm.total_txns_30d > 30 and rfm.avg_casa_balance_mil > 50 then 'VERY HIGH'
            when rfm.total_logins_30d > 20 and rfm.total_txns_30d > 20 and rfm.avg_casa_balance_mil > 10 then 'HIGH'
            when rfm.total_logins_30d > 10 and rfm.total_txns_30d > 10 and rfm.avg_casa_balance_mil > 1 then 'MEDIUM'
            when rfm.total_logins_30d >= 1 and rfm.total_txns_30d >= 1 and rfm.avg_casa_balance_mil >= 0.05 then 'LOW'
            else 'INACTIVE'
        end as new_active_level
    from rfm_metrics rfm
    left join demographics d on rfm.cust_cd = d.cust_cd and rfm.data_dt = d.data_dt
)
select 
    fb.*, coalesce(cp.churn_probability, 0) as churn_probability,
    case 
        when fb.new_active_level = 'LOW' and cp.churn_probability >= 0.70 then 'TARGET_RESCUE_LOW'
        when fb.new_active_level = 'MEDIUM' and cp.churn_probability >= 0.50 then 'TARGET_RETAIN_MED'
        when fb.new_active_level = 'HIGH' and cp.churn_probability >= 0.30 then 'TARGET_ENGAGE_HIGH'
        when fb.new_active_level = 'VERY HIGH' and cp.churn_probability >= 0.05 then 'TARGET_CARE_VIP'
        else 'MONITOR'
    end as campaign_action_flag
from fact_base fb
left join churn_preds cp on fb.cust_cd = cp.cust_cd and fb.data_dt = cp.data_dt