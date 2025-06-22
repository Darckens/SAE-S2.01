WITH totals AS (
  SELECT
    y.year,
    SUM(t.trade_value) AS total_trade,
    SUM(bt.trade_value) AS total_bilateral
  FROM year AS y
  LEFT JOIN trade AS t ON t.id_year = y.id_year
  LEFT JOIN country c_t ON t.id_country = c_t.id_country
  LEFT JOIN bilateral_trade AS bt ON bt.id_year = y.id_year
  WHERE c_t.iso2 NOT IN ('World')
    AND t.id_indicator IN (
      SELECT id_indicator FROM indicator WHERE units ILIKE '%dollar%'
    )
    AND bt.id_indicator IN (
      SELECT id_indicator FROM indicator WHERE units ILIKE '%dollar%'
    )
  GROUP BY y.year
)
SELECT 
  year,
	total_trade / SUM(total_trade) OVER () AS pct_trade,
	total_bilateral / SUM(total_bilateral) OVER () AS pct_bilateral
FROM totals;
