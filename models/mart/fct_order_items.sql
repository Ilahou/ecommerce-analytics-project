CREATE OR REPLACE TABLE `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.fct_order_items`
AS
SELECT

  -- stg_order_items
  oi.order_id,
  oi.order_item_id,
  oi.product_id,
  oi.seller_id,
  oi.price,
  oi.freight_value,
  oi.shipping_limit_date,

  -- stg_orders
  o.customer_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date
FROM
  `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_order_items`
    oi
JOIN
  `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_orders` o
  ON oi.order_id = o.order_id
