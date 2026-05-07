WITH dim_card AS (
    SELECT * FROM {{ ref('dim_card') }}
),
merchant_txn AS (
    SELECT * FROM {{ ref('int_transaction_merchant') }}
)
SELECT 
    c.lvl_1,
    c.card_segment,
    t.merchant,
    DATE_TRUNC('MONTH', t.posting_date) AS posting_month,
    COUNT(DISTINCT c.client_number_hktmo) AS sl_kh_psgd,
    COUNT(DISTINCT c.card_id_hktmo) AS sl_the_psgd,
    COUNT(DISTINCT t.doc_id) AS sl_gd,
    SUM(t.billing_amount) AS tong_billing_amount
FROM dim_card c
INNER JOIN merchant_txn t ON c.card_id_hktmo = t.card_id_hktmo
GROUP BY 
    c.lvl_1,
    c.card_segment,
    t.merchant,
    DATE_TRUNC('MONTH', t.posting_date)