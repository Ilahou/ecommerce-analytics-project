CREATE OR REPLACE VIEW `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_category_translation` AS
-- Eviter les faux doublons liés à la casse ou aux espaces
-- Assurer le bon format des colonnes
-- Patch : 2 catégories absentes de la table source ajoutées manuellement (détectées via monitoring_run E3)
--   > portateis_cozinha_e_preparadores_de_alimentos
--   > pc_gamer


WITH
 
source AS (
    SELECT product_category, product_category_name_english
    FROM `converteo-ae-recrut.e_commerce_1.product_category_name_translation`

    UNION ALL

    SELECT 'portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_and_food_processors'
    UNION ALL
    SELECT 'pc_gamer', 'pc_gamer'
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
