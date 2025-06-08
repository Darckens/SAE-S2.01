-- Traduction directe du schéma Entité-Association

COUNTRY(id_Country, Country, ISO2, ISO3)
CTS(id_CTS, CTS_Code,  CTS_Name, CTS_Full_Descriptor)
TRADE_FLOW(id_Trade_Flow, Trade_Flow)
INDICATOR(id_Indicator, Indicator, Source, Units, Scale)
YEAR(id_Year, Year)
BILATERAL_TRADE(id_Country, id_Counterpart_Country, id_Indicator, id_CTS, id_Trade_Flow, id_Year, trade_value)
→ où id_Country, id_Counterpart_Country, id_Indicator,  id_CTS, id_Trade_Flow et id_Year font respectivement 
références à COUNTRY, COUNTRY, INDICATOR, CTS, YEAR, TRADE_FLOW.

TRADE(id_Country, id_Indicator, id_CTS, id_Trade_Flow, id_Year, trade_value)
→ où id_country, id_Indicator, id_CTS, id_Trade_Flow et id_Year font respectivement références 
à COUNTRY, INDICATOR, CTS, TRADE_FLOW et YEAR.

-- Analyse des formes normales

-- 1NF :
-- Tous les attributs contiennent des valeurs atomiques.
-- Il n’y a pas de listes, champs composés ou multi-valués.
-- Les colonnes F1994 à F2023 ont été transformées en lignes (année + valeur).
-- Le schéma est en 1NF !

-- 2NF :
-- Le schéma est en 1NF.
-- Toutes les dépendances fonctionnelles partielles ont été éliminées.
-- Par exemple, les attributs dépendant uniquement de CTS_Code (comme le nom ou le descripteur)
-- ont été extraits dans une table à part.
-- Le schéma est en 2NF !

-- 3NF :
-- Le schéma est en 2NF.
-- Les dépendances transitives ont été supprimées.
-- Par exemple : l’unité d’un indicateur ne dépend pas indirectement du pays mais uniquement de l’indicateur.
-- Chaque attribut non-clé dépend directement de la clé primaire, pas d’un autre attribut non-clé.
-- Le schéma est en 3NF !

-- BCNF :
-- Le schéma est en 3NF.
-- Toutes les dépendances fonctionnelles ont un côté gauche qui est une super-clé.
-- Il n’existe pas de dépendances où un attribut non-clé détermine un autre attribut non-clé.
-- Exemple : dans Bilateral_Trade, seule la clé complète détermine trade_value.
-- Le schéma est en BCNF !
