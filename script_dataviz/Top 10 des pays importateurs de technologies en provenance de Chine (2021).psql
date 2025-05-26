SELECT 
  cp.country AS destination_country,
  100.0 * SUM(bt.trade_value) / SUM(SUM(bt.trade_value)) OVER () AS pct_import_from_china
FROM bilateral_trade bt
JOIN country c ON bt.id_country = c.id_country
JOIN country cp ON bt.id_conterpart_country = cp.id_country
JOIN trade_flow USING(id_trade_flow)
JOIN indicator USING(id_indicator)
JOIN year USING(id_year)
WHERE c.country IN (
	SELECT DISTINCT country FROM country
	WHERE country ILIKE '%china%'
)
  AND cp.country NOT IN (
	SELECT DISTINCT country FROM country
	WHERE country ILIKE '%china%'
  )
  AND trade_flow = 'Exports'
  AND units ILIKE '%dollar%'
  AND EXTRACT(YEAR FROM year) = 2021
GROUP BY cp.country
ORDER BY pct_import_from_china DESC
LIMIT 10;