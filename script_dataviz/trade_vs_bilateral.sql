DROP TABLE IF EXISTS trade_vs_bilateral ;

CREATE TEMPORARY TABLE temp_table (
   Year DATE,
   pct_trade DOUBLE PRECISION,
   pct_bilateral DOUBLE PRECISION
);

\copy temp_table FROM 'C:/Users/Darck/Desktop/ECOLE/STID/S2/SAEs/SAE-S2.01/data/trade_vs_bilateral.csv' DELIMITER ';' CSV HEADER;

CREATE TABLE trade_vs_bilateral (
   Year DATE,
   pct_trade DOUBLE PRECISION,
   pct_bilateral DOUBLE PRECISION
);

INSERT INTO trade_vs_bilateral (
	Year,
	pct_trade,
	pct_bilateral
)
SELECT
   Year,
   pct_trade,
   pct_bilateral
FROM
   temp_table
;

DROP TABLE temp_table ;