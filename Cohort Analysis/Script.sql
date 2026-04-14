CREATE VIEW cohort_analysis AS 
WITH customer_revenue AS (
	SELECT
		s.customerkey ,
		s.orderdate,
		sum(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
		count(s.orderkey) AS num_orders,
		c.countryfull ,
		c.age,
		c.givenname ,
		c.surname
	FROM
		sales s
	LEFT JOIN customer c ON
		c.customerkey = s.customerkey
	GROUP BY
		s.customerkey ,
		s.orderdate ,
		c.countryfull ,
		c.age,
		c.givenname ,
		c.surname
)
      
    SELECT
	cr.*,
	min(cr.orderdate) OVER (
		PARTITION BY cr.customerkey
	) AS first_purchase_date,
	EXTRACT (
		YEAR
	FROM
		min(cr.orderdate) OVER (
			PARTITION BY cr.customerkey
		)
	) AS cohort_year
FROM
	customer_revenue cr