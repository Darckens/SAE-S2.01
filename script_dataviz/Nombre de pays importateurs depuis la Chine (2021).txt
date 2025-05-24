SELECT COUNT(DISTINCT id_conterpart_country) AS nb_importing_countries
FROM bilateral_trade
JOIN country USING(id_country)
JOIN year USING(id_year)
JOIN trade_flow USING(id_trade_flow)
JOIN indicator USING(id_indicator)
WHERE country IN (
	SELECT DISTINCT country FROM country
	WHERE country ILIKE '%china%'
)
  AND trade_flow = 'Exports'
  AND units ILIKE '%dollar%'
  AND EXTRACT(YEAR FROM year) = 2021;
