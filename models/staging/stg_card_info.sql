WITH source AS (
    SELECT * FROM {{ source('tmo', 'stg_card_info') }}
)
SELECT
    card_id_hktmo,
    client_number_hktmo,
    lvl_1,
    lvl_2,
    lvl_3,
    lvl_4,
    from_date
FROM source