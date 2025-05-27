-- Traduction directe du schéma Entité-Association

Country = (
    id_Country SMALLSERIAL,
    Country VARCHAR(50),
    ISO2 CHAR(2),
    ISO3 CHAR(3)
)

CTS = (
    id_CTS SMALLSERIAL, 
    CTS_Code VARCHAR(6), 
    CTS_Name VARCHAR(100), 
    CTS_Full_Descriptor VARCHAR(150)
)

Trade_Flow = (
    id_Trade_Flow SMALLSERIAL, 
    Trade_Flow VARCHAR(20)
)

Indicator = (
    id_Indicator SMALLSERIAL, 
    Indicator VARCHAR(100), 
    Source VARCHAR(150), 
    Units VARCHAR(50),
    Scale VARCHAR(5)
)

Year = (
    id_Year SMALLSERIAL, 
    Year DATE
)

Bilateral_Trade = (
    id_Country SMALLINT, 
    id_Counterpart SMALLINT, 
    id_Indicator SMALLINT, 
    id_CTS SMALLINT, 
    id_Trade_Flow SMALLINT, 
    id_Year SMALLINT,
    trade_value DOUBLE PRECISION
)

Trade = (
    id_Country SMALLINT, 
    id_Indicator SMALLINT, 
    id_CTS SMALLINT, 
    id_Trade_Flow SMALLINT, 
    id_Year SMALLINT,
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
