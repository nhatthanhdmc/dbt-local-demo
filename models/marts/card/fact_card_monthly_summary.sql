WITH dim_card AS (
    SELECT * FROM {{ ref('dim_card') }}
),
transactions AS (
    SELECT * FROM {{ ref('stg_fin_transaction') }}
)
SELECT 
    c.lvl_1,
    c.card_segment,
    DATE_TRUNC('MONTH', t.posting_date) AS posting_month,
    t.txn_typ,
    COUNT(DISTINCT c.card_id_hktmo) AS sl_the_psgd,
    COUNT(t.doc_id) AS sl_gd,
    SUM(t.billing_amount) AS tong_billing_amount
FROM dim_card c
INNER JOIN transactions t ON c.card_id_hktmo = t.card_id_hktmo
GROUP BY 
    c.lvl_1,
    c.card_segment,
    DATE_TRUNC('MONTH', t.posting_date),
    t.txn_typ