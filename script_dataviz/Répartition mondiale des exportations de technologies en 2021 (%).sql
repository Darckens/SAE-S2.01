WITH trade_totals AS (
  SELECT 
    c.id_country,
    c.country,
    c.iso2,
    SUM(t.trade_value) AS total_trade
  FROM trade t
  JOIN country c ON t.id_country = c.id_country
  JOIN year y ON t.id_year = y.id_year
  JOIN trade_flow tf ON t.id_trade_flow = tf.id_trade_flow
  JOIN indicator i ON t.id_indicator = i.id_indicator
  WHERE EXTRACT(YEAR FROM y.year) = 2021
    AND tf.trade_flow = 'Exports'
    AND i.units ILIKE '%dollar%'
    AND c.iso2 NOT IN ('World')
  GROUP BY c.id_country, c.country, c.iso2
),
bilateral_totals AS (
  SELECT 
    c.id_country,
    SUM(bt.trade_value) AS total_bilateral
  FROM bilateral_trade bt
  JOIN country c ON bt.id_country = c.id_country
  JOIN year y ON bt.id_year = y.id_year
  JOIN trade_flow tf ON bt.id_trade_flow = tf.id_trade_flow
  JOIN indicator i ON bt.id_indicator = i.id_indicator
  WHERE EXTRACT(YEAR FROM y.year) = 2021
    AND tf.trade_flow = 'Exports'
    AND i.units ILIKE '%dollar%'
  GROUP BY c.id_country
),
exports AS (
  SELECT 
    t.country,
    t.iso2,
    COALESCE(t.total_trade, 0) + COALESCE(b.total_bilateral, 0) AS total_exports_all_sources
  FROM trade_totals t
  LEFT JOIN bilateral_totals b ON t.id_country = b.id_country
)
SELECT 
  country,
  iso2,
  total_exports_all_sources,
  ROUND((100.0 * total_exports_all_sources / SUM(total_exports_all_sources) OVER ())::numeric, 2) AS pct_exports_2021

FROM exports
ORDER BY pct_exports_2021 DESC;