/* ================================================================
   MONITORING RUN — Dashboard_Sales_ProductCat_Dates
   Auteur  : Houssepian
   Date    : 2026-04-26
   Usage   : Lancer après chaque refresh des vues staging.
             Résultat attendu : status = PASS sur toutes les lignes.
             Exception : E3a est un indicateur de stabilité (voir commentaire).
================================================================ */

SELECT test_name, failures,
    CASE WHEN failures = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM (

-- [B1] Unicité PK stg_customers
-- failures = nombre de clés customer_id en doublon (pas de lignes excédentaires)
SELECT 'B1 - PK stg_customers' AS test_name, COUNT(*) AS failures
FROM (
    SELECT customer_id
    FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_customers`
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)

UNION ALL

-- [B2] Unicité PK stg_orders
SELECT 'B2 - PK stg_orders', COUNT(*)
FROM (
    SELECT order_id
    FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_orders`
    GROUP BY order_id
    HAVING COUNT(*) > 1
)

UNION ALL

-- [B3] Unicité PK stg_order_items
-- Rappel : 1337 doublons détectés en raw, traités par ROW_NUMBER dans la vue
SELECT 'B3 - PK stg_order_items', COUNT(*)
FROM (
    SELECT order_id, order_item_id
    FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_order_items`
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
)

UNION ALL

-- [B4] Unicité PK stg_products
SELECT 'B4 - PK stg_products', COUNT(*)
FROM (
    SELECT product_id
    FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_products`
    GROUP BY product_id
    HAVING COUNT(*) > 1
)

UNION ALL

-- [B5] Unicité PK stg_category_translation
SELECT 'B5 - PK stg_category_translation', COUNT(*)
FROM (
    SELECT product_category
    FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_category_translation`
    GROUP BY product_category
    HAVING COUNT(*) > 1
)

UNION ALL

-- [C1] Nullité stg_customers
SELECT 'C1 - Nulls stg_customers',
    COUNTIF(customer_id IS NULL) + COUNTIF(customer_unique_id IS NULL)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_customers`

UNION ALL

-- [C2] Nullité stg_orders
SELECT 'C2 - Nulls stg_orders',
    COUNTIF(order_id IS NULL) + COUNTIF(customer_id IS NULL)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_orders`

UNION ALL

-- [C3] Nullité stg_order_items
SELECT 'C3 - Nulls stg_order_items',
    COUNTIF(order_id IS NULL) + COUNTIF(order_item_id IS NULL) + COUNTIF(seller_id IS NULL)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_order_items`

UNION ALL

-- [C4] Nullité stg_products
SELECT 'C4 - Nulls stg_products',
    COUNTIF(product_id IS NULL)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_products`

UNION ALL

-- [D1] Statuts inconnus dans stg_orders
SELECT 'D1 - Statuts inconnus stg_orders', COUNT(*)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_orders`
WHERE order_status NOT IN (
    'delivered', 'shipped', 'canceled',
    'processing', 'invoiced', 'unavailable', 'approved'
)

UNION ALL

-- [D2] Prix invalides dans stg_order_items
SELECT 'D2 - Prix invalides stg_order_items', COUNT(*)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_order_items`
WHERE price <= 0

UNION ALL

-- [D3] Frais de livraison négatifs dans stg_order_items
SELECT 'D3 - Freight négatif stg_order_items', COUNT(*)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_order_items`
WHERE freight_value < 0

UNION ALL

-- [D4] Statuts hors périmètre dans le mart
SELECT 'D4 - Statuts hors delivered mart', COUNT(*)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.mart_customer_sales_base`
WHERE order_status != 'delivered'

UNION ALL

-- [E1] Intégrité référentielle order_items → orders
SELECT 'E1 - Order items sans order valide', COUNT(*)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_order_items` oi
LEFT JOIN `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_orders` o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

-- [E2] CA mart non nul — 1 si le CA est à 0 (anomalie), 0 sinon
SELECT 'E2 - CA mart nul', CASE WHEN SUM(price) > 0 THEN 0 ELSE 1 END
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.mart_customer_sales_base`

UNION ALL

-- [E3a] Produits sans catégorie source — indicateur de stabilité, pas un test bloquant
-- Valeur de référence établie le 26/04/2026 : 610 produits sans catégorie en source
-- Si failures != 0 → la valeur a changé, à investiguer
SELECT 'E3a - Stabilite produits sans categorie (ref=610)',
    CASE WHEN COUNT(*) = 610 THEN 0 ELSE COUNT(*) END
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_products`
WHERE product_category_name IS NULL

UNION ALL

-- [E3b] Catégories PT présentes dans stg_products mais absentes de stg_category_translation
-- Doit être 0 après patch du UNION ALL dans stg_category_translation
SELECT 'E3b - Categories PT sans traduction EN', COUNT(*)
FROM `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_products` p
LEFT JOIN `converteo-ae-recrut-houssepian.Dashboard_Sales_ProductCat_Dates.stg_category_translation` t
    ON p.product_category_name = t.product_category
WHERE p.product_category_name IS NOT NULL
  AND t.product_category IS NULL

)
ORDER BY test_name
