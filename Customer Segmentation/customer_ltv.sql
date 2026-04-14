SELECT
	customerkey,
	full_name,
	sum(total_net_revenue) AS total_ltv
FROM
	cohort_analysis
GROUP BY
	customerkey,
	full_name