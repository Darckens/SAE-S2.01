----------------------------------------
-- Suppression des tables principales --
----------------------------------------

DROP TABLE IF EXISTS EchangerAvec CASCADE;
DROP TABLE IF EXISTS Mesurer CASCADE;
DROP TABLE IF EXISTS Classifier CASCADE;
DROP TABLE IF EXISTS ContribueA CASCADE;
DROP TABLE IF EXISTS Country CASCADE;
DROP TABLE IF EXISTS Indicator CASCADE;
DROP TABLE IF EXISTS CTS CASCADE;
DROP TABLE IF EXISTS Trade_Flow CASCADE;

------------------------------------
-- Création des tables temporaire --
------------------------------------

CREATE TEMPORARY TABLE tmp_trade_data (
    ObjectId INT PRIMARY KEY,
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
    ObjectId INT PRIMARY KEY,
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
\copy tmp_bilateral_trade_data FROM 'C:/Users/Darck/Desktop/ECOLE/STID/S2/SAEs/SAE-S2.01/data/Trade_in_Low_Carbon_Technology_Products.csv' DELIMITER ',' CSV HEADER;

---------------------------------------
-- Création des tables principales --
---------------------------------------

CREATE TABLE Country(
   idCountry SMALLINT PRIMARY KEY,
   Country VARCHAR(50),
   ISO2 CHAR(2),
   ISO3 CHAR(3)
);

CREATE TABLE Indicator(
   idIndicator SMALLINT PRIMARY KEY,
   Indicator_ VARCHAR(80),
   Source VARCHAR,
   Units VARCHAR(50)
);

CREATE TABLE CTS(
   idCTS SMALLINT PRIMARY KEY,
   CTS_Code VARCHAR(6),
   CTS_Name VARCHAR(100),
   CTS_Full_Descriptor VARCHAR(150)
);

CREATE TABLE Trade_Flow(
   idTradeFlow SMALLINT PRIMARY KEY,
   Trade_Flow VARCHAR(20),
   Scale VARCHAR(5)
);

CREATE TABLE Mesurer(
   idCountry SMALLINT,
   idIndicator SMALLINT,
   PRIMARY KEY(idCountry, idIndicator),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idIndicator) REFERENCES Indicator(idIndicator)
);

CREATE TABLE Classifier(
   idCountry SMALLINT,
   idCTS SMALLINT,
   PRIMARY KEY(idCountry, idCTS),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idCTS) REFERENCES CTS(idCTS)
);

CREATE TABLE ContribueA(
   idCountry SMALLINT,
   idTradeFlow SMALLINT,
   PRIMARY KEY(idCountry, idTradeFlow),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idTradeFlow) REFERENCES Trade_Flow(idTradeFlow)
);

CREATE TABLE EchangerAvec(
   idCountry SMALLINT,
   idCountry_1 SMALLINT,
   Year_ SMALLINT,
   Value_CO2 DOUBLE PRECISION,
   PRIMARY KEY(idCountry, idCountry_1, Year_),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idCountry_1) REFERENCES Country(idCountry)
);

--------------------------------------
-- Insertion des données principales --
--------------------------------------

-- Country
INSERT INTO Country(idCountry, Country, ISO2, ISO3)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Country)::SMALLINT,
    Country,
    ISO2,
    ISO3
FROM (
    SELECT DISTINCT Country, ISO2, ISO3
    FROM tmp_trade_data
) AS td
ORDER BY Country;

-- Indicator
INSERT INTO Indicator(idIndicator, Indicator_, Source, Units)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Indicator)::SMALLINT,
    Indicator,
    MIN(Source),
    MIN(Unit)
FROM (
    SELECT Indicator, Source, Unit
    FROM tmp_trade_data
    UNION ALL
    SELECT Indicator, Source, Unit
    FROM tmp_bilateral_trade_data
) AS all_indicators
GROUP BY Indicator
ORDER BY Indicator;

-- CTS
INSERT INTO CTS(idCTS, CTS_Code, CTS_Name, CTS_Full_Descriptor)
SELECT 
    ROW_NUMBER() OVER (ORDER BY CTS_Code)::SMALLINT,
    CTS_Code,
    MIN(CTS_Name),
    MIN(CTS_Full_Descriptor)
FROM (
    SELECT CTS_Code, CTS_Name, CTS_Full_Descriptor
    FROM tmp_trade_data
    UNION ALL
    SELECT CTS_Code, CTS_Name, CTS_Full_Descriptor
    FROM tmp_bilateral_trade_data
) AS all_cts
GROUP BY CTS_Code
ORDER BY CTS_Code;

-- Trade_Flow
INSERT INTO Trade_Flow(idTradeFlow, Trade_Flow, Scale)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Trade_Flow)::SMALLINT,
    Trade_Flow,
    MIN(Scale)
FROM (
    SELECT Trade_Flow, Scale
    FROM tmp_trade_data
    UNION ALL
    SELECT Trade_Flow, Scale
    FROM tmp_bilateral_trade_data
) AS all_tf
GROUP BY Trade_Flow
ORDER BY Trade_Flow;

---------------------------------------
-- Insertion des relations (liaisons) --
---------------------------------------

-- Mesurer
INSERT INTO Mesurer(idCountry, idIndicator)
SELECT DISTINCT
    c.idCountry,
    i.idIndicator
FROM (
    SELECT Country, Indicator
    FROM tmp_trade_data
    UNION
    SELECT Country, Indicator
    FROM tmp_bilateral_trade_data
) AS data
JOIN Country c ON data.Country = c.Country
JOIN Indicator i ON data.Indicator = i.Indicator_;

-- Classifier
INSERT INTO Classifier(idCountry, idCTS)
SELECT DISTINCT
    c.idCountry,
    ct.idCTS
FROM (
    SELECT Country, CTS_Code
    FROM tmp_trade_data
    UNION
    SELECT Country, CTS_Code
    FROM tmp_bilateral_trade_data
) AS data
JOIN Country c ON data.Country = c.Country
JOIN CTS ct ON data.CTS_Code = ct.CTS_Code;

-- ContribueA
INSERT INTO ContribueA(idCountry, idTradeFlow)
SELECT DISTINCT
    c.idCountry,
    tf.idTradeFlow
FROM (
    SELECT Country, Trade_Flow
    FROM tmp_trade_data
    UNION
    SELECT Country, Trade_Flow
    FROM tmp_bilateral_trade_data
) AS data
JOIN Country c ON data.Country = c.Country
JOIN Trade_Flow tf ON data.Trade_Flow = tf.Trade_Flow;

/*
-- EchangerAvec
INSERT INTO EchangerAvec(idCountry, idCountry_1, Year_, Value_CO2)
SELECT
    c1.idCountry,
    c2.idCountry,
    year_year::SMALLINT,
    value_co2
FROM (
    SELECT
        tb.Country,
        tb.Counterpart_Country,
        UNNEST(ARRAY[
            1994, 1995, 1996, 1997, 1998, 1999,
            2000, 2001, 2002, 2003, 2004, 2005,
            2006, 2007, 2008, 2009, 2010, 2011,
            2012, 2013, 2014, 2015, 2016, 2017,
            2018, 2019, 2020, 2021, 2022, 2023
        ]) AS year_year,
        UNNEST(ARRAY[
            F1994, F1995, F1996, F1997, F1998, F1999,
            F2000, F2001, F2002, F2003, F2004, F2005,
            F2006, F2007, F2008, F2009, F2010, F2011,
            F2012, F2013, F2014, F2015, F2016, F2017,
            F2018, F2019, F2020, F2021, F2022, F2023
        ]) AS value_co2
    FROM tmp_bilateral_trade_data tb
) AS flat
JOIN Country c1 ON flat.Country = c1.Country
JOIN Country c2 ON flat.Counterpart_Country = c2.Country
WHERE value_co2 IS NOT NULL;
*/

---------------------------------------
-- Suppression des tables temporaire --
---------------------------------------

DROP TABLE IF EXISTS tmp_trade_data;
DROP TABLE IF EXISTS tmp_bilateral_trade_data;
