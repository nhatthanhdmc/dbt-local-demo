WITH source AS (
    SELECT * FROM {{ source('dlpt', 'vw_f_fin_transaction_tmo') }}
)
SELECT
    card_id_hktmo,
    doc_id,
    CAST(posting_date AS DATE) AS posting_date,
    billing_amount,
    txn_typ,
    mcc,
    trans_details,
    merchant_id
FROM source