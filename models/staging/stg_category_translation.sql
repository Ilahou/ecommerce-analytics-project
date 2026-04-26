CREATE OR REPLACE VIEW `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_category_translation` AS
-- Eviter les faux doublons liés à la casse ou aux espaces
-- Assurer le bon format des colonnes

WITH
 
source AS (
    SELECT * FROM `converteo-ae-recrut.e_commerce_1.product_category_name_translation`
),
 
cleaned AS (
    SELECT DISTINCT
        LOWER(TRIM(SAFE_CAST(product_category             AS STRING))) AS product_category,
        LOWER(TRIM(SAFE_CAST(product_category_name_english AS STRING))) AS product_category_name_english
    FROM source
),
 
final AS (
    SELECT *
    FROM cleaned
    WHERE product_category              IS NOT NULL  
      AND product_category_name_english IS NOT NULL  -- sans trad. la ligne est inutilisable
)
 
SELECT * FROM final;
