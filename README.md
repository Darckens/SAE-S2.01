# SAE 2.01 – Conception et Implémentation d'une Base de Données

## Contexte général

Ce projet a été réalisé dans le cadre de la SAÉ du BUT Science des Données, intitulée **SAÉ 2.01 : Conception et implémentation d'une base de données relationnelle**. Il s’inscrit dans la continuité des apprentissages en bases de données, modélisation et manipulation des données à des fins décisionnelles.

L’objectif principal de cette SAÉ est de maîtriser toutes les étapes nécessaires à la construction d'une base de données relationnelle à partir de données réelles : analyse des besoins, modélisation conceptuelle et logique, alimentation, et interrogation via SQL.

> L’étudiant est placé dans la peau d’un gestionnaire de base de données, chargé d’intégrer, structurer et exploiter les flux d’échanges commerciaux à des fins d’analyse stratégique.

## Objectifs et problématique

La base de données est un outil central dans les processus décisionnels. Il est donc essentiel de savoir modéliser les données, les structurer et les interroger efficacement. Pour cela, notre projet a consisté à concevoir une base à partir de fichiers plats, les intégrer, et les interroger pour en tirer des analyses pertinentes.

### Problématique posée :
> Comment les flux d’exportation de technologies bas carbone se sont-ils structurés à l’échelle mondiale en 2021, et quel a été le rôle stratégique de la Chine dans cette dynamique commerciale ?

## Description du projet

Après une phase d'exploration des données, nous avons opté pour une approche d'analyse par croisement des tables `Trade` et `Bilateral_Trade`, en ciblant particulièrement l’année 2021, identifiée comme une année marquant un pic historique des échanges.

L’objectif n’était pas d’enchaîner des requêtes indépendantes, mais bien de construire un **ensemble de visualisations cohérentes**, en développant un tableau de bord structuré permettant d’explorer les dynamiques globales du commerce de technologies vertes.

Nous avons modélisé, implémenté et alimenté notre base (via des jointures, la fonction `UNNEST`, les conversions nécessaires pour faciliter l’analyse temporelle, etc.) puis utilisé SQL pour générer les indicateurs pertinents.

## Analyses réalisées

Parmi les analyses mises en place :

- Suivi de l’évolution des flux bilatéraux et nationaux de 1994 à 2023
- Analyse du pic de 2021
- Classement des principaux pays importateurs depuis la Chine
- Carte des exportations mondiales par pays en 2021
- Indicateurs globaux : nombre d’exports, nombre de pays concernés, volume total

Ces analyses ont été représentées à l’aide de graphiques et cartes, facilitant leur lecture et leur interprétation.

## Choix techniques

- PostgreSQL pour la gestion de la base
- Requêtes complexes SQL (fenêtres, agrégats, jointures, `UNNEST`, filtrage, etc.)
- Construction de la base via des scripts SQL (création, insertion, jointures)
- Utilisation de Metabase pour l’interrogation visuelle et les tableaux de bord
- Respect des bonnes pratiques relationnelles (clés primaires, séquences `SERIAL`, normalisation)

## Points techniques notables

- Nous avons utilisé un identifiant `id_year` pour les jointures entre tables, mais aussi un champ `year` typé `DATE` pour des raisons de compatibilité avec Metabase.
- Les jointures effectuées après la transformation `UNNEST` ont permis d'assurer la cohérence référentielle entre nos fichiers plats et les tables de référence (pays, indicateurs, etc.).
- Les séquences PostgreSQL associées aux identifiants (`SERIAL`) ont permis l’auto-incrément des clés primaires.

## Compétences mobilisées

- 🔧 Modélisation conceptuelle et relationnelle
- 🗃️ Structuration et normalisation des données
- 📈 Requêtage avancé (PostgreSQL)
- 🗺️ Visualisation et narration de données
- 🧠 Analyse de données et interprétation

## Membres du projet

Projet réalisé dans le cadre de la SAE 2.01 – BUT Science des Données 2e semestre, par :

- [Ibrahim BENKHERFELLAH](https://github.com/Darckens)  
- [Axel COULET](https://github.com/axcou)

## Licence

Ce projet est proposé à des fins pédagogiques uniquement. Reproduction interdite sans autorisation.
