-- Which categories contribute the most to overall sales?

WITH total_revenue_by_category AS(
SELECT 
p.product_category_name AS category,  
ROUND(SUM(price), 2) AS total_revenue_by_category FROM 
order_items oi 
LEFT JOIN products p
ON oi.product_id = p.product_id 
GROUP BY p.product_category_name
)

SELECT 
category, 
total_revenue_by_category,
SUM(total_revenue_by_category) OVER() total_revenue,
CONCAT(ROUND(total_revenue_by_category / SUM(total_revenue_by_category) OVER() * 100, 2), '%') percentage_contribution
FROM total_revenue_by_category
ORDER BY percentage_contribution DESC;

-- How much has each of customers spent with us in total?
-- Are they a VIP, Regular or new customer?

WITH customer_order_information AS(
SELECT c.customer_id, o.order_id, oi.product_id, oi.price, o.order_purchase_timestamp  FROM 
order_items oi 
LEFT JOIN orders o
ON oi.order_id = o.order_id
LEFT JOIN customers c
ON o.customer_id = c.customer_id
)

SELECT 
customer_id,
SUM(price) total_spent,
CASE 
	WHEN SUM(price) >= 6000 THEN 'VIP'
    WHEN SUM(price) >= 1000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment
FROM customer_order_information
GROUP BY customer_id
ORDER BY total_spent DESC;


-- What is the average order value (AOV) ?

WITH total_order_value_details AS
(
SELECT 
order_id, 
SUM(price) total_order_value FROM order_items
GROUP BY order_id
)

SELECT 
ROUND(AVG(total_order_value), 2) average_order_value
FROM total_order_value_details;

-- Total Revenue over time monthly (Running total)

WITH order_details AS
(
SELECT 
oi.order_id AS order_id, 
total_order_value,
order_purchase_timestamp
FROM 
orders o
LEFT JOIN (SELECT 
order_id, 
SUM(price) total_order_value FROM order_items
GROUP BY order_id) oi
ON oi.order_id = o.order_id
WHERE oi.order_id IS NOT NULL

)

SELECT 
order_id,
MONTH(order_purchase_timestamp) month,
YEAR(order_purchase_timestamp) year,
ROUND(SUM(total_order_value) OVER(PARTITION BY YEAR (order_purchase_timestamp), MONTH(order_purchase_timestamp) 
ORDER BY order_purchase_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 2) running_total
FROM order_details;


--  What is the Month over Month percentage total revenue change?
WITH total_revenue_by_year_and_month AS
(
	SELECT  
	YEAR(o.order_purchase_timestamp) year,
	MONTH(o.order_purchase_timestamp) month,
	ROUND(SUM(oi.price), 2) total_revenue
	FROM order_items oi
	LEFT JOIN orders o
	ON oi.order_id = o.order_id
	GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
),

previous_month_revenue AS
(
	SELECT 
	year,
	month,
	total_revenue,
    CASE 
		WHEN LAG(total_revenue) OVER(ORDER BY year, month) IS NULL THEN 'N/A'
        ELSE LAG(total_revenue) OVER(ORDER BY year, month)
	END previous_month_revenue
	FROM total_revenue_by_year_and_month 
)

SELECT 
year, 
month,
total_revenue, 
previous_month_revenue,
CASE 
	WHEN previous_month_revenue = 'N/A' THEN 'N/A'
    ELSE ROUND((total_revenue - previous_month_revenue) / previous_month_revenue * 100, 2)
END percentage_change
FROM previous_month_revenue;


-- Which cities have the most valuable customers

WITH customer_and_order_details AS
(
SELECT 
c.customer_id, 
c.customer_city, 
c.customer_state,
o.order_id,
oi.price
FROM order_items oi
LEFT JOIN orders o ON 
oi.order_id = o.order_id
LEFT JOIN customers c ON
o.customer_id = c.customer_id
)

SELECT 
customer_state,
customer_city,
ROUND(SUM(price), 2) total_revenue
FROM customer_and_order_details
GROUP BY customer_state, customer_city;


-- What is the average delivery time by city and state
WITH customer_order_shipping_time_details AS
(
SELECT 
c.customer_id, 
c.customer_city, 
c.customer_state,
o.order_id,
DATEDIFF(order_delivered_customer_date, o.order_purchase_timestamp) shipping_time
FROM order_items oi
LEFT JOIN orders o ON 
oi.order_id = o.order_id
LEFT JOIN customers c ON
o.customer_id = c.customer_id
WHERE order_delivered_customer_date != ''
)

SELECT 
customer_state,
customer_city,
ROUND(AVG(shipping_time), 0) avg_shipping_time_days
FROM customer_order_shipping_time_details
GROUP BY customer_state, customer_city;


