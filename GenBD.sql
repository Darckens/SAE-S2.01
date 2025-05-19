----------------------------------------
-- Suppression des tables principales --
----------------------------------------

DROP TABLE IF EXISTS Bilateral_Trade;
DROP TABLE IF EXISTS Trade;
DROP TABLE IF EXISTS Year;
DROP TABLE IF EXISTS Trade_Flow;
DROP TABLE IF EXISTS CTS;
DROP TABLE IF EXISTS Indicator;
DROP TABLE IF EXISTS Country;


------------------------------------
-- Création des tables temporaire --
------------------------------------

CREATE TEMPORARY TABLE tmp_trade_data (
    ObjectId INTEGER PRIMARY KEY,
    Country VARCHAR(50),
    ISO2 CHAR(2),
    ISO3 CHAR(3),
    Indicator VARCHAR(80),
    Unit VARCHAR(50),
    Source VARCHAR,
    CTS_Code VARCHAR(6),
    CTS_Name VARCHAR(100),
    CTS_Full_Descriptor VARCHAR(150),
    Trade_Flow VARCHAR(20),
    Scale VARCHAR(50),
    F1994 DOUBLE PRECISION,
    F1995 DOUBLE PRECISION,
    F1996 DOUBLE PRECISION,
    F1997 DOUBLE PRECISION,
    F1998 DOUBLE PRECISION,
    F1999 DOUBLE PRECISION,
    F2000 DOUBLE PRECISION,
    F2001 DOUBLE PRECISION,
    F2002 DOUBLE PRECISION,
    F2003 DOUBLE PRECISION,
    F2004 DOUBLE PRECISION,
    F2005 DOUBLE PRECISION,
    F2006 DOUBLE PRECISION,
    F2007 DOUBLE PRECISION,
    F2008 DOUBLE PRECISION,
    F2009 DOUBLE PRECISION,
    F2010 DOUBLE PRECISION,
    F2011 DOUBLE PRECISION,
    F2012 DOUBLE PRECISION,
    F2013 DOUBLE PRECISION,
    F2014 DOUBLE PRECISION,
    F2015 DOUBLE PRECISION,
    F2016 DOUBLE PRECISION,
    F2017 DOUBLE PRECISION,
    F2018 DOUBLE PRECISION,
    F2019 DOUBLE PRECISION,
    F2020 DOUBLE PRECISION,
    F2021 DOUBLE PRECISION,
    F2022 DOUBLE PRECISION,
    F2023 DOUBLE PRECISION
);

CREATE TEMPORARY TABLE tmp_bilateral_trade_data (
    ObjectId INTEGER PRIMARY KEY,
    Country VARCHAR(50),
    ISO2 CHAR(2),
    ISO3 CHAR(3),
    Counterpart_Country VARCHAR(50),
    Counterpart_ISO2 CHAR(2),
    Counterpart_ISO3 CHAR(3),
    Indicator VARCHAR(80),
    Unit VARCHAR(50),
    Source VARCHAR,
    CTS_Code VARCHAR(6),
    CTS_Name VARCHAR(100),
    CTS_Full_Descriptor VARCHAR(150),
    Trade_Flow VARCHAR(20),
    Scale VARCHAR(5),
    F1994 DOUBLE PRECISION,
    F1995 DOUBLE PRECISION,
    F1996 DOUBLE PRECISION,
    F1997 DOUBLE PRECISION,
    F1998 DOUBLE PRECISION,
    F1999 DOUBLE PRECISION,
    F2000 DOUBLE PRECISION,
    F2001 DOUBLE PRECISION,
    F2002 DOUBLE PRECISION,
    F2003 DOUBLE PRECISION,
    F2004 DOUBLE PRECISION,
    F2005 DOUBLE PRECISION,
    F2006 DOUBLE PRECISION,
    F2007 DOUBLE PRECISION,
    F2008 DOUBLE PRECISION,
    F2009 DOUBLE PRECISION,
    F2010 DOUBLE PRECISION,
    F2011 DOUBLE PRECISION,
    F2012 DOUBLE PRECISION,
    F2013 DOUBLE PRECISION,
    F2014 DOUBLE PRECISION,
    F2015 DOUBLE PRECISION,
    F2016 DOUBLE PRECISION,
    F2017 DOUBLE PRECISION,
    F2018 DOUBLE PRECISION,
    F2019 DOUBLE PRECISION,
    F2020 DOUBLE PRECISION,
    F2021 DOUBLE PRECISION,
    F2022 DOUBLE PRECISION,
    F2023 DOUBLE PRECISION
);

-------------------------
-- Importation des CSV --
-------------------------

\copy tmp_trade_data FROM 'C:/Users/Darck/Desktop/ECOLE/STID/S2/SAEs/SAE-S2.01/data/Trade_in_Low_Carbon_Technology_Products.csv' DELIMITER ',' CSV HEADER;
\copy tmp_bilateral_trade_data FROM 'C:/Users/Darck/Desktop/ECOLE/STID/S2/SAEs/SAE-S2.01/data/Bilateral_Trade_in_Low_Carbon_Technology_Products.csv' DELIMITER ',' CSV HEADER;


-- Création des tables principales
CREATE TABLE Country(
   id_Country INTEGER PRIMARY KEY,
   Country VARCHAR(50),
   ISO2 CHAR(2),
   ISO3 CHAR(3)
);

CREATE TABLE Indicator(
   id_Indicator INTEGER PRIMARY KEY,
   Indicator_ VARCHAR(80),
   Source VARCHAR,
   Units VARCHAR(50)
);

CREATE TABLE CTS(
   id_CTS INTEGER PRIMARY KEY,
   CTS_Code VARCHAR(6),
   CTS_Name VARCHAR(100),
   CTS_Full_Descriptor VARCHAR(150)
);

CREATE TABLE Trade_Flow(
   id_Trade_Flaw INTEGER PRIMARY KEY,
   Trade_Flow VARCHAR(20),
   Scale VARCHAR(5)
);

CREATE TABLE Year(
   id_Year INTEGER PRIMARY KEY,
   Year DATE
);

CREATE TABLE Bilateral_Trade (
    id_Country INTEGER REFERENCES Country(id_Country),
    id_Conterpart_country INTEGER REFERENCES Country(id_Country),
    id_Indicator INTEGER REFERENCES Indicator(id_Indicator),
    id_CTS INTEGER REFERENCES CTS(id_CTS),
    id_Trade_Flaw INTEGER REFERENCES Trade_Flow(id_Trade_Flaw),
    id_Year INTEGER REFERENCES Year(id_Year),
    trade_value DOUBLE PRECISION,
    PRIMARY KEY(id_Country, id_Conterpart_country, id_Indicator, id_CTS, id_Trade_Flaw, id_Year)
);

-- Création de la table pour les données nationales
CREATE TABLE Trade (
    id_Country INTEGER REFERENCES Country(id_Country),
    id_Indicator INTEGER REFERENCES Indicator(id_Indicator),
    id_CTS INTEGER REFERENCES CTS(id_CTS),
    id_Trade_Flaw INTEGER REFERENCES Trade_Flow(id_Trade_Flaw),
    id_Year INTEGER REFERENCES Year(id_Year),
    trade_value DOUBLE PRECISION,
    PRIMARY KEY(id_Country, id_Indicator, id_CTS, id_Trade_Flaw, id_Year)
);

-- Insertion des données dans les tables principales
-- Country
INSERT INTO Country(id_Country, Country, ISO2, ISO3)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Country)::INTEGER,
    Country,
    ISO2,
    ISO3
FROM (
    SELECT DISTINCT Country, ISO2, ISO3 FROM tmp_trade_data
    UNION
    SELECT DISTINCT Counterpart_Country, Counterpart_ISO2, Counterpart_ISO3 FROM tmp_bilateral_trade_data
)
ORDER BY Country;

-- Indicator
INSERT INTO Indicator(id_Indicator, Indicator_, Source, Units)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Indicator)::INTEGER,
    Indicator,
    MIN(Source),
    MIN(Unit)
FROM (
    SELECT Indicator, Source, Unit FROM tmp_trade_data
    UNION ALL
    SELECT Indicator, Source, Unit FROM tmp_bilateral_trade_data
)
GROUP BY Indicator;

-- CTS
INSERT INTO CTS(id_CTS, CTS_Code, CTS_Name, CTS_Full_Descriptor)
SELECT 
    ROW_NUMBER() OVER (ORDER BY CTS_Code)::INTEGER,
    CTS_Code,
    MIN(CTS_Name),
    MIN(CTS_Full_Descriptor)
FROM (
    SELECT CTS_Code, CTS_Name, CTS_Full_Descriptor FROM tmp_trade_data
    UNION ALL
    SELECT CTS_Code, CTS_Name, CTS_Full_Descriptor FROM tmp_bilateral_trade_data
)
GROUP BY CTS_Code;

-- Trade_Flow
INSERT INTO Trade_Flow(id_Trade_Flaw, Trade_Flow, Scale)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Trade_Flow)::INTEGER,
    Trade_Flow,
    MIN(Scale)
FROM (
    SELECT Trade_Flow, Scale FROM tmp_trade_data
    UNION ALL
    SELECT Trade_Flow, Scale FROM tmp_bilateral_trade_data
) AS all_tf
GROUP BY Trade_Flow;

-- Year
INSERT INTO Year(id_Year, Year)
SELECT y, make_date(y, 1, 1)
FROM generate_series(1994, 2023) AS y;


-- Insertion des données nationales
INSERT INTO Trade(
    id_Country, id_Indicator, id_CTS, id_Trade_Flaw, id_Year, trade_value
)
SELECT
    c.id_Country,
    i.id_Indicator,
    cts.id_CTS,
    tf.id_Trade_Flaw,
    y.id_Year,
    flat.trade_value
FROM (
    SELECT
        td.Country,
        td.Indicator,
        td.CTS_Code,
        td.Trade_Flow,
        UNNEST(ARRAY[1994, 1995, 1996, 1997, 1998, 1999,
                     2000, 2001, 2002, 2003, 2004, 2005,
                     2006, 2007, 2008, 2009, 2010, 2011,
                     2012, 2013, 2014, 2015, 2016, 2017,
                     2018, 2019, 2020, 2021, 2022, 2023]) AS year_year,
        UNNEST(ARRAY[F1994, F1995, F1996, F1997, F1998, F1999,
                     F2000, F2001, F2002, F2003, F2004, F2005,
                     F2006, F2007, F2008, F2009, F2010, F2011,
                     F2012, F2013, F2014, F2015, F2016, F2017,
                     F2018, F2019, F2020, F2021, F2022, F2023]) AS trade_value
    FROM tmp_trade_data td
) AS flat
JOIN Country c ON c.Country = flat.Country
JOIN Indicator i ON i.Indicator_ = flat.Indicator
JOIN CTS cts ON cts.CTS_Code = flat.CTS_Code
JOIN Trade_Flow tf ON tf.Trade_Flow = flat.Trade_Flow
JOIN Year y ON y.id_Year = flat.year_year
WHERE flat.trade_value IS NOT NULL;

-- Bilateral_Trade
INSERT INTO Bilateral_Trade(
    id_Country, id_Conterpart_country,id_Indicator,
    id_CTS, id_Trade_Flaw, id_Year, trade_value
)
SELECT
    c1.id_Country, 
    c2.id_Country,
    i.id_Indicator,
    cts.id_CTS,
    tf.id_Trade_Flaw,
    y.id_Year,
    flat.trade_value
FROM (
    SELECT
        tb.Country,
        tb.Counterpart_Country,
        tb.Indicator,
        tb.CTS_Code,
        tb.Trade_Flow,
        UNNEST(ARRAY[1994, 1995, 1996, 1997, 1998, 1999,
                     2000, 2001, 2002, 2003, 2004, 2005,
                     2006, 2007, 2008, 2009, 2010, 2011,
                     2012, 2013, 2014, 2015, 2016, 2017,
                     2018, 2019, 2020, 2021, 2022, 2023]) AS year_year,
        UNNEST(ARRAY[F1994, F1995, F1996, F1997, F1998, F1999,
                     F2000, F2001, F2002, F2003, F2004, F2005,
                     F2006, F2007, F2008, F2009, F2010, F2011,
                     F2012, F2013, F2014, F2015, F2016, F2017,
                     F2018, F2019, F2020, F2021, F2022, F2023]) AS trade_value
    FROM tmp_bilateral_trade_data tb
) AS flat
JOIN Country c1 ON c1.Country = flat.Country
JOIN Country c2 ON c2.Country = flat.Counterpart_Country
JOIN Indicator i ON i.Indicator_ = flat.Indicator
JOIN CTS cts ON cts.CTS_Code = flat.CTS_Code
JOIN Trade_Flow tf ON tf.Trade_Flow = flat.Trade_Flow
JOIN Year y ON y.id_Year = flat.year_year
WHERE flat.trade_value IS NOT NULL ;


-- Suppression des tables temporaires
DROP TABLE IF EXISTS tmp_trade_data;
DROP TABLE IF EXISTS tmp_bilateral_trade_data;