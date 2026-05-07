select
    branchnbr as branch_nbr,
    branch_nm,
    cluster_nm,
    region_nm,
    province_nm
from {{ source('tmo', 'stg_qlbh_chinhanh') }}