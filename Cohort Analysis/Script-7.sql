-- 1. Use IF EXISTS so the script doesn't crash if the view is already gone
DROP VIEW IF EXISTS public.cohort_analysis; 

-- 2. Create the view fresh
CREATE VIEW public.cohort_analysis AS 
WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
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
		s.customerkey,
		s.orderdate,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
)
SELECT
	customerkey,
	orderdate,
	total_net_revenue,
	num_orders,
	countryfull,
	age,
	-- Added COALESCE to prevent NULL names from breaking the string
	trim(concat(COALESCE(givenname, ''), ' ', COALESCE(surname, ''))) AS full_name,
	min(orderdate) OVER (
		PARTITION BY customerkey
	) AS first_purchase_date,
	EXTRACT(YEAR FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
FROM
	customer_revenue;