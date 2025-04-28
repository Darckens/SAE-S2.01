----------------------------------------
-- Suppression des tables principales --
----------------------------------------

DROP TABLE IF EXISTS Country;
DROP TABLE IF EXISTS Indicator;
DROP TABLE IF EXISTS CTS ;
DROP TABLE IF EXISTS Trade_FLow;
DROP TABLE IF EXISTS Echanger_Avec;
DROP TABLE IF EXISTS Mesure;
DROP TABLE IF EXISTS Classifier;
DROP TABLE IF EXISTS Participe_À;

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
    Source VARCHAR(150),
    CTS_Code VARCHAR(6),
    CTS_Name VARCHAR(50),
    CTS_Full_Descriptor VARCHAR(150),
    Trade_Flow VARCHAR(20),
    Scale VARCHAR(50,
    F1994 SMALLINT,
    F1995 SMALLINT,
    F1996 SMALLINT,
    F1997 SMALLINT,
    F1998 SMALLINT,
    F1999 SMALLINT,
    F2000 SMALLINT,
    F2001 SMALLINT,
    F2002 SMALLINT,
    F2003 SMALLINT,
    F2004 SMALLINT,
    F2005 SMALLINT,
    F2006 SMALLINT,
    F2007 SMALLINT,
    F2008 SMALLINT,
    F2009 SMALLINT,
    F2010 SMALLINT,
    F2011 SMALLINT,
    F2012 SMALLINT,
    F2013 SMALLINT,
    F2014 SMALLINT,
    F2015 SMALLINT,
    F2016 SMALLINT,
    F2017 SMALLINT,
    F2018 SMALLINT,
    F2019 SMALLINT,
    F2020 SMALLINT,
    F2021 SMALLINT,
    F2022 SMALLINT,
    F2023 SMALLINT
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
    Source VARCHAR(150),
    CTS_Code VARCHAR(6),
    CTS_Name VARCHAR(50),
    CTS_Full_Descriptor VARCHAR(150),
    Trade_Flow VARCHAR(20),
    Scale VARCHAR(5),
    F1994 SMALLINT,
    F1995 SMALLINT,
    F1996 SMALLINT,
    F1997 SMALLINT,
    F1998 SMALLINT,
    F1999 SMALLINT,
    F2000 SMALLINT,
    F2001 SMALLINT,
    F2002 SMALLINT,
    F2003 SMALLINT,
    F2004 SMALLINT,
    F2005 SMALLINT,
    F2006 SMALLINT,
    F2007 SMALLINT,
    F2008 SMALLINT,
    F2009 SMALLINT,
    F2010 SMALLINT,
    F2011 SMALLINT,
    F2012 SMALLINT,
    F2013 SMALLINT,
    F2014 SMALLINT,
    F2015 SMALLINT,
    F2016 SMALLINT,
    F2017 SMALLINT,
    F2018 SMALLINT,
    F2019 SMALLINT,
    F2020 SMALLINT,
    F2021 SMALLINT,
    F2022 SMALLINT,
    F2023 SMALLINT
);

-- copie des csv dans table temp
\copy tmp_trade_data FROM "C:/Users/axcou/Desktop/perso/cours/BUT SD/S2/S201-sae-bdd/data/Trade_in_Low_Carbon_Technology_Products.csv" DELIMITER ',' CSV HEADER;
\copy tmp_bilateral_trade_data FROM "C:/Users/axcou/Desktop/perso/cours/BUT SD/S2/S201-sae-bdd/data/Bilateral_Trade_in_Low_Carbon_Technology_Products.csv" DELIMITER ',' CSV HEADER;

-- creation des tables principales
CREATE TABLE Country(
   idCountry SMALLINT,
   Country VARCHAR(50),
   ISO2 CHAR(2),
   ISO3 CHAR(3),
   PRIMARY KEY(idCountry)
);

CREATE TABLE Indicator(
   idIndicator SMALLINT,
   Indicator_ VARCHAR(80),
   Source VARCHAR(150),
   Units VARCHAR(50),
   PRIMARY KEY(idIndicator)
);

CREATE TABLE CTS(
   idCTS SMALLINT,
   CTS_Code VARCHAR(6),
   CTS_Name VARCHAR(50),
   CTS_Full_Descriptor VARCHAR(150),
   PRIMARY KEY(idCTS)
);

CREATE TABLE Trade_FLow(
   idTradeFlow SMALLINT,
   Trade_Flow VARCHAR(20),
   Scale VARCHAR(5),
   PRIMARY KEY(idTradeFlow)
);

CREATE TABLE Echanger_Avec(
   idCountry SMALLINT,
   idCountry_1 SMALLINT,
   Year_ SMALLINT,
   Value_CO2 DOUBLE PRECISION,
   PRIMARY KEY(idCountry, idCountry_1),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idCountry_1) REFERENCES Country(idCountry)
);

CREATE TABLE Mesure(
   idCountry SMALLINT,
   idIndicator SMALLINT,
   PRIMARY KEY(idCountry, idIndicator),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idIndicator) REFERENCES Indicator_(idIndicator)
);

CREATE TABLE Classifier(
   idCountry SMALLINT,
   idCTS SMALLINT,
   PRIMARY KEY(idCountry, idCTS),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idCTS) REFERENCES CTS(idCTS)
);

CREATE TABLE Participe_À(
   idCountry SMALLINT,
   idTradeFlow SMALLINT,
   PRIMARY KEY(idCountry, idTradeFlow),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idTradeFlow) REFERENCES Trade_FLow(idTradeFlow)
);

-- insertion des données dans tables principales
INSERT INTO Country(idCountry, Country, ISO2, ISO3)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Country),
    Country,
    ISO2,
    ISO3
FROM (
    SELECT DISTINCT Country, ISO2, ISO3
    FROM tmp_trade_data
) td;
---------------------------------------
-- Suppression des tables temporaire --
---------------------------------------

DROP TABLE IF EXISTS tmp_trade_data;
DROP TABLE IF EXISTS tmp_bilateral_trade_data;
