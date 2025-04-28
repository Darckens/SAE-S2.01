----------------------------------------
-- Suppression des tables principales --
----------------------------------------

DROP TABLE IF EXISTS Country CASCADE;
DROP TABLE IF EXISTS Indicator CASCADE;
DROP TABLE IF EXISTS CTS CASCADE;
DROP TABLE IF EXISTS Trade_FLow CASCADE;
DROP TABLE IF EXISTS EchangerAvec CASCADE;
DROP TABLE IF EXISTS Mesurer CASCADE;
DROP TABLE IF EXISTS Classifier CASCADE;
DROP TABLE IF EXISTS ContribueA CASCADE;

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

-- copie des csv dans table temp
\copy tmp_trade_data FROM 'C:/Users/Darck/Desktop/ECOLE/STID/S2/SAEs/SAE-S2.01/data/Trade_in_Low_Carbon_Technology_Products.csv' DELIMITER ',' CSV HEADER;
\copy tmp_bilateral_trade_data FROM 'C:/Users/Darck/Desktop/ECOLE/STID/S2/SAEs/SAE-S2.01/data/Trade_in_Low_Carbon_Technology_Products.csv' DELIMITER ',' CSV HEADER;

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
   Source VARCHAR,
   Units VARCHAR(50),
   PRIMARY KEY(idIndicator)
);

CREATE TABLE CTS(
   idCTS SMALLINT,
   CTS_Code VARCHAR(6),
   CTS_Name VARCHAR(100),
   CTS_Full_Descriptor VARCHAR(150),
   PRIMARY KEY(idCTS)
);

CREATE TABLE Trade_FLow(
   idTradeFlow SMALLINT,
   Trade_Flow VARCHAR(20),
   Scale VARCHAR(5),
   PRIMARY KEY(idTradeFlow)
);

CREATE TABLE EchangerAvec(
   idCountry SMALLINT,
   idCountry_1 SMALLINT,
   Year_ SMALLINT,
   Value_CO2 DOUBLE PRECISION,
   PRIMARY KEY(idCountry, idCountry_1),
   FOREIGN KEY(idCountry) REFERENCES Country(idCountry),
   FOREIGN KEY(idCountry_1) REFERENCES Country(idCountry)
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
