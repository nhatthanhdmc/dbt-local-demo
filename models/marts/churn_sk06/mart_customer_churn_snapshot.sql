select 
    f.*,
    d.service_segment, d.is_emp,
    b.branch_nm, b.region_nm, b.province_nm
from {{ ref('fct_customer_monthly_activity') }} f
left join {{ ref('dim_customer') }} d on f.cust_cd = d.cust_cd
left join {{ ref('dim_branch') }} b on f.branch_nbr = b.branch_nbr