SELECT
	cohort_year,
	sum(total_net_revenue)
FROM
	cohort_analysis
GROUP BY
	cohort_year