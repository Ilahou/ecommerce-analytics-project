# ecommerce-analytics-project
A bigquery project for senior analytics engineering practice 

## 📊 Dashboard

Accéder au dashboard Looker Studio :  
👉 https://datastudio.google.com/s/mzb2Vn9TF1w

Ce dashboard est un prototype basé sur une modélisation de donnée en étoile (star schmema).
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


**Pourquoi garder un grain fin : 
**- Permet de créer des champs calculés via le dashboard
**- Réduit les incohérences de calcul (une commande comptées plusieurs fois selon l'aggrégation)
**- Temps de calcul et de rendu très acceptable pour le dashboard
**- Suffisant pour un prototypage



