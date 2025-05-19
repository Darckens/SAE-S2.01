-- Traduction directe du schéma Entité-Association

Country = (
    idCountry SMALLINT, 
    Country VARCHAR(50), 
    ISO2 CHAR(2), 
    ISO3 CHAR(3)
)

CTS = (
    idCTS SMALLINT, 
    CTS_Code VARCHAR(6), 
    CTS_Name VARCHAR(100), 
    CTS_Full_Descriptor VARCHAR(150)
)

Trade_Flow = (
    idTrade SMALLINT, 
    Trade_Flow VARCHAR(20), 
    Scale VARCHAR(5)
)

Indicator = (
    idIndicator SMALLINT, 
    Indicator_ VARCHAR(100), 
    Source VARCHAR(150), 
    Units VARCHAR(50)
)

Year = (
    id_Year SMALLINT, 
    Year DATE
)

Echanger_Avec = (
    id_country SMALLINT, 
    id_counterpart SMALLINT, 
    id_indicator SMALLINT, 
    id_cts SMALLINT, 
    id_trade SMALLINT, 
    id_year SMALLINT,
    trade_value DOUBLE PRECISION
)

Donnee_Pays = (
    id_country SMALLINT, 
    id_indicator SMALLINT, 
    id_cts SMALLINT, 
    id_trade SMALLINT, 
    id_year SMALLINT,
    trade_value DOUBLE PRECISION
)


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
-- Exemple : dans Echanger_Avec, seule la clé complète détermine trade_value.
-- Le schéma est en BCNF !
