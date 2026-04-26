CREATE OR REPLACE VIEW `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_order_items` AS

-- Dédupliquer les couples order_id, order_item_id = 1337 doublons cleaned (peut évoluer en fonction de l'évolution de la table raw)
-- S'assurer du bon format des colonnes
-- Vérifier que l'order_id existe, et que les prix + coûts de livraison sont positifs (sauf pour le freight qui peut être à 0)

WITH

source AS (
    SELECT * FROM `converteo-ae-recrut.e_commerce_1.order_items`
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id, order_item_id
            ORDER BY shipping_limit_date
        ) AS row_num
    FROM source
),

cleaned AS (
    SELECT
        SAFE_CAST(order_id            AS STRING)    AS order_id,
        SAFE_CAST(order_item_id       AS INT64)     AS order_item_id,
        SAFE_CAST(product_id          AS STRING)    AS product_id,
        SAFE_CAST(seller_id           AS STRING)    AS seller_id,
        SAFE_CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_date,
        SAFE_CAST(price               AS FLOAT64)   AS price,
        SAFE_CAST(freight_value       AS FLOAT64)   AS freight_value
    FROM deduped
    WHERE row_num = 1
),

final AS (
    SELECT *
    FROM cleaned
    WHERE order_id      IS NOT NULL
      AND order_item_id IS NOT NULL
      AND seller_id     IS NOT NULL
      AND price         > 0
      AND freight_value >= 0
)

SELECT * FROM final
