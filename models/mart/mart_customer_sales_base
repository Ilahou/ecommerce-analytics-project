-- équivalent mart sales_base avec jointure customers pour analyse sur clients & géo

CREATE OR REPLACE TABLE `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.mart_customer_sales_base` AS 
SELECT
  foi.order_id,
  foi.order_item_id,
  foi.product_id,
  dc.customer_city,
  dc.customer_zip_code,
  dc.customer_state,
  dc.customer_unique_id,
  DATE(foi.order_purchase_timestamp) as order_date,
  foi.order_status,
  COALESCE(dp.product_category_name, 'uncategorized') AS category,
  COALESCE(dp.product_category_name_english, 'uncategorized') AS category_eng,
  foi.price,
  foi.freight_value
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.fct_order_items` foi
INNER JOIN `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.dim_products` dp 
-- On garde volontairement les order rattachables à des products ; Test = 0 commandes sans product_id
  ON foi.product_id = dp.product_id
INNER JOIN Dashboard_Sales_ProductCat_Dates.dim_customers dc 
-- On garde volontairement les commandes rattachables à des id ; Test = 0 commandes sans customers_unique_id
ON foi.customer_id = dc.customer_id
WHERE foi.order_status = 'delivered'; -- Périmètre volontairement restreint aux commandes livrées pour le reporting des ventes réelles
