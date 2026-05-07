WITH stg_txn AS (
    SELECT * FROM {{ ref('stg_fin_transaction') }}
)
SELECT 
    card_id_hktmo,
    doc_id,
    posting_date,
    billing_amount,
    txn_typ,
    mcc,
    CASE
        WHEN upper(trans_details) LIKE '%XANH SM%' THEN 'XANH SM'
        WHEN upper(trans_details) LIKE '%SHOPEE%' THEN 'SHOPEE'
        WHEN upper(trans_details) LIKE '%AGODA%' THEN 'AGODA'
        WHEN upper(trans_details) LIKE '%CGV%' THEN 'CGV'
        WHEN upper(trans_details) LIKE '%GRAB%' THEN 'GRAB'
        WHEN upper(trans_details) LIKE '%CELLPHONES%' THEN 'CELLPHONES'
        WHEN upper(trans_details) LIKE '%HIGHLANDS%' THEN 'HIGHLANDS'
        WHEN upper(trans_details) LIKE '%STARBUCKS%' THEN 'STARBUCKS'
        WHEN upper(trans_details) LIKE '%TRAVELOKA%' THEN 'TRAVELOKA'
        WHEN upper(trans_details) LIKE '%TIKTOKSHOP%' THEN 'TIKTOKSHOP'
        WHEN upper(trans_details) LIKE '%KLOOK%' THEN 'KLOOK'
        WHEN upper(trans_details) LIKE '%HAIDILAO%' THEN 'HAIDILAO'
        WHEN upper(trans_details) LIKE '%VIETNAM AIRLINES%' THEN 'VIETNAM AIRLINES'
        WHEN upper(trans_details) LIKE '%TRIP.COM%' AND mcc IN ('4722') THEN 'TRIP.COM'
        WHEN merchant_id IN ('60392750','33881000554434','33810000997920','33881000702983','338-M-997920','33881000729543','33871070315528','33871070832242') THEN 'BE'
        WHEN (upper(trans_details) LIKE '%MANWAH%' OR upper(trans_details) LIKE '%GOGI%') AND mcc IN ('5812','5814') THEN 'GGG (MANWAH, GOGI)'
        ELSE 'OTHERS'
    END AS merchant
FROM stg_txn
WHERE mcc NOT IN ('7311','4900')