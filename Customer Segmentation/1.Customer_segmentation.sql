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
),
 
       customer_segment AS (
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
),
    
    segment_value AS( 
 SELECT
    c.*,
    CASE 
        WHEN c.total_ltv < cs.ltv_25th THEN '1- Low Value Customer'
         WHEN c.total_ltv <= cs.ltv_75th THEN '2- Mid Value Customer'
         WHEN c.total_ltv > cs.ltv_75th THEN '3- High Value Customer'  
       END AS customer_catogary  
 FROM 
     customer_ltv c ,
     customer_segment cs )
     
   SELECT
	customer_catogary ,
	sum(total_ltv)AS total_ltv,
	count(customerkey) AS customercount ,
	sum(total_ltv)/ count(customerkey) AS avg_ltv
FROM
	segment_value
GROUP BY
	customer_catogary