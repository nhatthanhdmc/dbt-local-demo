WITH source AS (
    SELECT * FROM {{ source('tmo', 'stg_fin_transaction') }}
)
SELECT
    card_id_hktmo,
    doc_id,
    -- Cập nhật hàm parse chuỗi YYYYMMDD thành Date
    strptime(cast(posting_date as varchar), '%Y%m%d')::date AS posting_date,
    billing_amount,
    txn_typ,
    mcc,
    trans_details,
    merchant_id
FROM source