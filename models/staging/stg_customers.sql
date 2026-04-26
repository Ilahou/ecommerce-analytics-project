CREATE OR REPLACE VIEW `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_customers` AS

-- S'assurer du bon format 
-- Vérifier que les id sont not null 

WITH

source AS (
    SELECT * FROM `converteo-ae-recrut.e_commerce_1.customers`
),

cleaned AS (
    SELECT
        SAFE_CAST(customer_id            AS STRING) AS customer_id,
        SAFE_CAST(customer_unique_id     AS STRING) AS customer_unique_id,
        SAFE_CAST(customer_zip_code_prefix AS INT64) AS customer_zip_code,
        SAFE_CAST(customer_city          AS STRING) AS customer_city,
        SAFE_CAST(customer_state         AS STRING) AS customer_state
    FROM source
),

final AS (
    SELECT *
    FROM cleaned
    WHERE customer_id        IS NOT NULL
      AND customer_unique_id IS NOT NULL
)

SELECT * FROM final
