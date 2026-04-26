CREATE OR REPLACE TABLE `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.mart_sales_base` AS
-- Eviter les catégories null
SELECT
  foi.order_id,
  foi.order_item_id,
  foi.product_id,
  foi.order_purchase_timestamp,
  foi.order_status,
  COALESCE(dp.product_category_name, 'uncategorized') AS category,
  COALESCE(dp.product_category_name_english, 'uncategorized') AS category_eng,
  foi.price,
  foi.freight_value
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.fct_order_items` foi
INNER JOIN `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.dim_products` dp
  ON foi.product_id = dp.product_id
WHERE foi.order_status = 'delivered';
