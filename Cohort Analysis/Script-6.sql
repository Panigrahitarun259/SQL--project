-- 1. This clears the old structure entirely so you can change columns freely
DROP VIEW IF EXISTS cohort_analysis; 

-- 2. Now you can create it with your new logic without Postgres complaining
CREATE VIEW cohort_analysis AS 
WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate::date AS order_day,
		-- Cast to date for better grouping
		sum(s.quantity::double PRECISION * s.netprice * s.exchangerate) AS total_net_revenue,
		count(s.orderkey) AS num_orders,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
	FROM
		sales s
	LEFT JOIN customer c ON
		c.customerkey = s.customerkey
	GROUP BY
		1,
		2,
		5,
		6,
		7,
		8
)
SELECT
	customerkey,
	order_day,
	total_net_revenue,
	num_orders,
	countryfull,
	age,
	trim(concat(COALESCE(givenname, ''), ' ', COALESCE(surname, ''))) AS full_name,
	min(order_day) OVER (
		PARTITION BY customerkey
	) AS first_purchase_date,
	EXTRACT(YEAR FROM min(order_day) OVER (PARTITION BY customerkey)) AS cohort_year
FROM
	customer_revenue;