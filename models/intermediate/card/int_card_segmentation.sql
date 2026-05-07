WITH stg_card AS (
    SELECT * FROM {{ ref('stg_card_info') }}
)
SELECT
    card_id_hktmo,
    client_number_hktmo,
    lvl_1,
    lvl_2,
    lvl_3,
    lvl_4,
    from_date,
    CASE 
        -- Logic cho Thẻ Tín Dụng (Credit)
        WHEN lvl_1 = 'Credit' THEN
            CASE 
                WHEN lvl_3 = 'Visa' AND lvl_2 = 'Credit Infinite' THEN 'Visa Infinite'
                WHEN lvl_3 = 'Visa' AND lvl_2 LIKE 'Credit Signature%' AND instr(lvl_4,'Privilege') <> 0 THEN 'Visa Privilege Signature'
                WHEN lvl_3 = 'Visa' AND lvl_2 LIKE 'Credit Signature%' AND lvl_2 NOT IN ('Credit Signature Lotusmiles Virtual') AND instr(lvl_4,'Privilege') = 0 THEN 'Visa Signature'
                WHEN lvl_3 = 'Visa' AND lvl_2 LIKE 'Credit Platinum%' THEN 'Visa Platinum'
                WHEN lvl_3 = 'Visa' AND lvl_2 LIKE 'Credit Gold%' AND lvl_2 NOT IN ('Credit Gold Lotusmiles Virtual') THEN 'Visa Gold'
                WHEN lvl_3 = 'JCB' AND lvl_2 LIKE 'Credit Gold%' THEN 'JCB Gold'
                WHEN lvl_3 = 'Visa' AND lvl_2 IN ('Credit Gold Lotusmiles Virtual', 'Credit Signature Lotusmiles Virtual') THEN 'Visa Lotusmilepay'
                ELSE 'Others'
            END

        -- Logic cho Thẻ Ghi Nợ (Debit)
        WHEN lvl_1 = 'Debit' THEN
            CASE 
                WHEN lvl_3 = 'Visa' AND lvl_2 = 'Debit Privilege Signature' THEN 'Visa Privilege Signature'
                WHEN lvl_3 = 'Visa' AND lvl_4 LIKE '%UUTIEN%' THEN 'Visa Privilege Platinum'
                WHEN lvl_3 = 'Visa' AND instr(lvl_2,'Digi') = 0 AND lvl_2 NOT IN ('Debit Privilege Signature','Debit Lotusmiles Virtual') AND lvl_4 NOT LIKE '%UUTIEN%' THEN 'Visa Debit'
                WHEN lvl_3 = 'Visa' AND lvl_2 = 'Debit Lotusmiles Virtual' THEN 'Visa Lotusmilepay'
                ELSE 'Others'
            END
            
        ELSE 'Others'
    END AS card_segment
FROM stg_card
WHERE (lvl_1 = 'Credit' AND lvl_2 <> 'Credit Corporate') 
   OR (lvl_1 = 'Debit')