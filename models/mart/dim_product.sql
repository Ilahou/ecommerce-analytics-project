CREATE OR REPLACE TABLE `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.dim_products` AS
SELECT
  product.product_id,

  COALESCE(product.product_category_name, 'uncategorized') AS product_category_name,

  COALESCE(
    translation.product_category_name_english,
    'uncategorized'
  ) AS product_category_name_english,

  product.product_name_length,
  product.product_description_length,
  product.product_photos_qty,
  product.product_weight_g,
  product.product_length_cm,
  product.product_height_cm,
  product.product_width_cm

FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_products` product
LEFT JOIN `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_category_translation` translation
  ON product.product_category_name = translation.product_category;
