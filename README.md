# ecommerce-analytics-project
A bigquery project for senior analytics engineering practice 

## 📊 Dashboard

Accéder au dashboard Looker Studio :  
👉 https://datastudio.google.com/s/mzb2Vn9TF1w

Ce dashboard est un prototype basé sur une modélisation de donnée en étoile (star schema).
Il permet de suivre les KPI:
- CA
- AVB (average basket)

Filtrer les dimensions :
- Catégorie (en anglais)
- Période (day,month,year)

Il permet aussi de suivre le nombre total de commande et de clients.

Table utilisée : mart_customer_sales_base
Grain : Une ligne = Une ligne de commande

Ce grain permet d'avoir les filtre par catégories et par période tout en gardant une cohérence de calcul 
avec les totaux calculés.


Pourquoi garder un grain fin : 
- Permet de créer des champs calculés via le dashboard
- Réduit les incohérences de calcul (une commande comptées plusieurs fois selon l'aggrégation)
- Temps de calcul et de rendu très acceptable pour le dashboard
- Suffisant pour un prototypage


Architecture du pipeline
Raw (e_commerce_1)
    │
    ▼
Staging (stg_*)          ← typage, nettoyage, déduplication
    │
    ▼
Mart (dim_*, fct_*, mart_customer_sales_base)   ← modélisation en étoile + Table(s) exposée(s) au dashboard

Staging
- 5 vues (stg_customers, stg_orders, stg_order_items, stg_products, stg_category_translation). Standards appliqués uniformément : SAFE_CAST sur toutes les colonnes, TRIM + LOWER sur les strings
- Filtres NOT NULL sur les clés. stg_order_items inclut une déduplication par ROW_NUMBER (1337 doublons détectés en raw)
- Deux catégories absentes de la table de traduction source ont été patchées via UNION ALL dans stg_category_translation
  
Mart
- Table : mart_customer_sales_base — grain : une ligne = une ligne de commande (order_item). Grain fin conservé pour permettre le filtrage par catégorie et par période sans incohérence de calcul. 
- Périmètre : commandes delivered uniquement. Les deux jointures (dim_customers, dim_products) sont en INNER JOIN — validé par test préalable (0 orphelins dans les deux cas)


  
Qualité
Fichier test_monitoring.sql — 14 tests en un seul run, résultat PASS/FAIL par ligne. 
Couvre : unicité des PK, nullité des colonnes critiques, valeurs acceptées, intégrité référentielle, CA non nul, stabilité du volume de produits sans catégorie (ref : 610).


