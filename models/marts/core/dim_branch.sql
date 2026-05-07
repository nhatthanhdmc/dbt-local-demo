select 
    branch_nbr, branch_nm, cluster_nm, region_nm, province_nm
from {{ ref('stg_qlbh_chinhanh') }}