CREATE OR REPLACE VIEW `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_orders` AS
WITH

source AS (
    SELECT * FROM `converteo-ae-recrut.e_commerce_1.orders`
),

cleaned AS (
    SELECT
        SAFE_CAST(order_id      AS STRING)  AS order_id,
        SAFE_CAST(customer_id   AS STRING)  AS customer_id,
        TRIM(LOWER(SAFE_CAST(order_status AS STRING)))             AS order_status,
        SAFE_CAST(order_purchase_timestamp      AS TIMESTAMP)      AS order_purchase_timestamp,
        SAFE_CAST(order_approved_at             AS TIMESTAMP)      AS order_approved_at,
        SAFE_CAST(order_delivered_carrier_date  AS TIMESTAMP)      AS order_delivered_carrier_date,
        SAFE_CAST(order_delivered_customer_date AS TIMESTAMP)      AS order_delivered_customer_date,
        SAFE_CAST(order_estimated_delivery_date AS TIMESTAMP)      AS order_estimated_delivery_date
    FROM source
),

final AS (
    SELECT *
    FROM cleaned
    WHERE order_id    IS NOT NULL
      AND customer_id IS NOT NULL
)

SELECT * FROM final;
