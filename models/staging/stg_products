 
CREATE OR REPLACE VIEW `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_products` AS
 
WITH
 
source AS (
    SELECT * FROM `converteo-ae-recrut.e_commerce_1.products`
),
 
cleaned AS (
    SELECT
        SAFE_CAST(product_id AS STRING)                                    AS product_id,
        -- typo corrigée : lenght → length (propagée partout sinon)
        TRIM(LOWER(SAFE_CAST(product_category_name AS STRING)))            AS product_category_name,
        SAFE_CAST(product_name_lenght        AS INT64)                     AS product_name_length,
        SAFE_CAST(product_description_lenght AS INT64)                     AS product_description_length,
        SAFE_CAST(product_photos_qty         AS INT64)                     AS product_photos_qty,
        SAFE_CAST(product_weight_g           AS FLOAT64)                   AS product_weight_g,
        SAFE_CAST(product_length_cm          AS FLOAT64)                   AS product_length_cm,
        SAFE_CAST(product_height_cm          AS FLOAT64)                   AS product_height_cm,
        SAFE_CAST(product_width_cm           AS FLOAT64)                   AS product_width_cm
    FROM source
),
 
final AS (
    SELECT *
    FROM cleaned
    WHERE product_id IS NOT NULL 
)
 
SELECT * FROM final;
