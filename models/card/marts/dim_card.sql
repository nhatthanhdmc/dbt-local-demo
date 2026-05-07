WITH card_segments AS (
    SELECT * FROM {{ ref('int_card_segmentation') }}
),
latest_card_state AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY card_id_hktmo ORDER BY from_date DESC) as rn
    FROM card_segments
)
SELECT 
    card_id_hktmo,
    client_number_hktmo,
    lvl_1,
    lvl_2,
    lvl_3,
    lvl_4,
    card_segment
FROM latest_card_state
WHERE rn = 1