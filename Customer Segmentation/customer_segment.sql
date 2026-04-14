WITH customer_ltv AS (
	SELECT
		customerkey,
		full_name,
		sum(total_net_revenue) AS total_ltv
	FROM
		cohort_analysis
	GROUP BY
		customerkey,
		full_name
)
 
           
  SELECT
	PERCENTILE_CONT(0.25) WITHIN GROUP (
	ORDER BY
		total_ltv
	) AS ltv_25th,
	PERCENTILE_CONT(0.75) WITHIN GROUP (
	ORDER BY
		total_ltv
	) AS ltv_75th
FROM
	customer_ltv