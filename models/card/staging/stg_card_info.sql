WITH source AS (
    SELECT * FROM {{ source('dlpt', 'vw_d_card_info_tmo') }}
)
SELECT
    card_id_hktmo,
    client_number_hktmo,
    lvl_1,
    lvl_2,
    lvl_3,
    lvl_4,
    CAST(from_date AS DATE) AS from_date
FROM source