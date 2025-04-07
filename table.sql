DROP TABLE IF EXISTS Country;
DROP TABLE IF EXISTS Indicator;
DROP TABLE IF EXISTS CTS ;
DROP TABLE IF EXISTS Trade_FLow;
DROP TABLE IF EXISTS Echanger_Avec;
DROP TABLE IF EXISTS Mesure;
DROP TABLE IF EXISTS Classifier;
DROP TABLE IF EXISTS Participe_À;


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
   CTS_Full_Descriptor VARCHAR(50),
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
   Date_ SMALLINT,
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
