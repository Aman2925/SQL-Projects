USE zomato_db;

SELECT * FROM zomato_db.customers;

SELECT * FROM zomato_db.restaurants;

SELECT * FROM zomato_db.orders;

SELECT * FROM zomato_db.deliveries;

SELECT * FROM zomato_db.riders;

-- HANDLING MISSING VALUES

SELECT COUNT(*) FROM zomato_db.customers
WHERE
	customer_name IS NULL 
		OR 
	reg_date is NULL;
    
SELECT COUNT(*) FROM zomato_db.restaurants
WHERE
	restaurant_name IS NULL 
		OR
	city IS NULL
		OR
	opening_hours IS NULL;
    

SELECT COUNT(*) FROM zomato_db.orders
WHERE 
	customer_id IS NULL
		OR
	restaurant_id IS NULL
		OR
	order_item IS NULL 
		OR
	order_date IS NULL
		OR 
	order_time IS NULL
		OR
	order_status IS NULL
		OR 
	total_amount IS NULL;
    

SELECT COUNT(*) FROM zomato_db.deliveries
WHERE 
	order_id IS NULL 
		OR
	delivery_status IS NULL
		OR
	delivery_time IS NULL
		OR 
	rider_id IS NULL;
    
    
SELECT COUNT(*) FROM zomato_db.riders
WHERE
	rider_name IS NULL
		OR
	sign_up IS NULL;
	

-- ------------------------------------------------------------------------------------------------------------------------------------------
--                                                        Analysis & Reports
-- ------------------------------------------------------------------------------------------------------------------------------------------

/* 

Q.1. Write a query to find the top 5 most frequently ordered dishes by customer called "Aman Singh" in the last 1 year.

*/ 

SELECT 
	customer_name,
    dish_name,
	order_count
FROM
( -- table name
SELECT 
	c.customer_name,
    o.order_item as dish_name,
    COUNT(*) as order_count,
    DENSE_RANK() OVER(ORDER BY COUNT(*)DESC) AS rnk
FROM zomato_db.customers AS c
JOIN
zomato_db.orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_date >= (
		SELECT DATE_SUB(MAX(order_date),INTERVAL 1 YEAR)
		FROM 
		zomato_db.orders
) and c.customer_name = 'Aman Singh'
GROUP BY c.customer_name,
		 o.order_item
ORDER BY order_count DESC
) as t1
WHERE rnk <=5;


-- 🎯 INTERVIEW TIP (VERY IMPORTANT) 

/* 

If asked why you grouped by customer_name when filtering a single customer:
“Technically it’s optional, but grouping it improves readability and prevents errors if the filter is relaxed later.”
This answer shows mature SQL thinking.

*/

/*

Q.2.Popular Time Slots
Question: Identify the time slots during which the most orders are placed. based on 2-hour intervals.


*/

-- APPROACH - 1

SELECT 
	CASE 
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00 - 02.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN '02:00 - 04.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN '04:00 - 06.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN '06:00 - 08.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN '08:00 - 10.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN '10:00 - 12.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN '12:00 - 14.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN '14:00 - 16.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN '16:00 - 18.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN '18:00 - 20.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN '20:00 - 22.00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 22 AND 23 THEN '22:00 - 00.00'
	END AS time_slot,
    COUNT(order_id) as order_count
FROM zomato_db.orders
GROUP BY time_slot
ORDER BY order_count DESC;


-- APPROACH -2 

SELECT 
	FLOOR(EXTRACT(HOUR FROM order_time)/2) * 2 as start_time,
    FLOOR(EXTRACT(HOUR FROM order_time)/2) * 2 + 2 as end_time,
    COUNT(order_id) as order_count
FROM zomato_db.orders
GROUP BY start_time,end_time
ORDER BY order_count DESC;


/*

3. Order Value Analysis
Question: Find the average order value per customer who has placed more than 10 orders.
Return customer_name, and aov (average order value)

*/


SELECT
    c.customer_name,
    ROUND(AVG(o.total_amount), 2) AS aov
FROM zomato_db.orders o
INNER JOIN zomato_db.customers c
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name
HAVING COUNT(o.order_id) > 10
ORDER BY aov DESC;

/* 

🎯 “I group by customer_id even if it’s not selected because it uniquely identifies each customer and prevents aggregation errors when names are duplicated.”

*/



/*

-- 4. High-Value Customers
-- Question: List the customers who have spent more than 5K in total on food orders.
   return customer_name,customer_id and total_spent !

*/


SELECT 
	o.customer_id,
	c.customer_name,
	SUM(total_amount) as total_spent
FROM 
	zomato_db.orders as o
JOIN
	zomato_db.customers as c
ON
	c.customer_id = o.customer_id
GROUP BY o.customer_id,c.customer_name
HAVING total_spent > 5000
ORDER BY total_spent DESC;


/* 
-- Q.5 Restaurant Revenue Ranking:
ーー Rank restaurants by their total revenue from the last year, including their name, total revenue, and rank within their city.

*/

WITH ranking_table 
AS
(
	SELECT
		r.restaurant_name,
		r.city,
		SUM(total_amount) AS total_revenue,
		RANK() OVER (PARTITION BY r.city ORDER BY SUM(total_amount) DESC) AS rnk
	FROM 
		zomato_db.orders AS o
	JOIN 
		zomato_db.restaurants AS r
	ON 
		r.restaurant_id = o.restaurant_id
	WHERE order_date >= 
		(
			SELECT DATE_SUB(MAX(order_date),INTERVAL 1 YEAR)
				FROM zomato_db.orders
		
		)
	GROUP BY r.restaurant_id,r.restaurant_name,r.city
)

SELECT 
	restaurant_name,
    city,
    total_revenue
FROM ranking_table 
WHERE rnk = 1;


/*

Q.6 Most Popular Dish by City:
-- Identify the most popular dish in each city based on the number of orders.

*/

WITH city_wise_dish_ranking
AS
(
	SELECT 
		r.city,
		o.order_item,
		COUNT(o.order_id) as No_of_orders,
		RANK() OVER(PARTITION BY r.city ORDER BY COUNT(o.order_id) DESC) AS rnk
	FROM 
		zomato_db.restaurants AS r
	JOIN 
		zomato_db.orders AS o
	ON
		r.restaurant_id = o.restaurant_id
	GROUP BY 
		r.city,
		o.order_item
)

SELECT 
	city,
    order_item
FROM city_wise_dish_ranking
WHERE rnk = 1;


/*

If asked:
Why did you use a window function instead of a subquery?
Answer:
“Window functions allow ranking within each partition without losing aggregated detail, making the query more readable and scalable.”

*/


/*

-- Q.7 Customer Churn:
-- Find customers who haven't placed an order in 2024 but did in 2023.

*/

SELECT DISTINCT(customer_id) FROM zomato_db.orders
WHERE 
	EXTRACT(YEAR FROM order_date) = 2023
			AND
	customer_id NOT IN 
    (
		SELECT DISTINCT(customer_id) FROM zomato_db.orders
			WHERE 
				EXTRACT(YEAR FROM order_date) = 2024
	);


/*

-- Q.8 Cancellation Rate Comparison:
 Calculate and compare the order cancellation rate for each restaurat between the
 current year and the previous year.

*/

SELECT 
    r.restaurant_name,
    YEAR(o.order_date) AS order_year,
    ROUND(
        SUM(CASE WHEN o.order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS cancellation_rate
FROM zomato_db.orders o
JOIN zomato_db.restaurants r
    ON o.restaurant_id = r.restaurant_id
JOIN (
    SELECT MAX(YEAR(order_date)) AS max_year
    FROM zomato_db.orders
) y
    ON YEAR(o.order_date) IN (y.max_year, y.max_year - 1)
GROUP BY r.restaurant_name, YEAR(o.order_date)
ORDER BY r.restaurant_name, order_year;


/*

-- Q.9 Rider Average Delivery Time:
-- Determine each rider's average delivery time.

*/

SELECT 
    d.rider_id,
    ROUND(
        AVG(
            (
                CASE
                    -- delivery crossed midnight → add 24 hours
                    WHEN TIME(d.delivery_time) < TIME(o.order_time)
                    THEN TIME_TO_SEC(TIME(d.delivery_time)) + 86400
                    ELSE TIME_TO_SEC(TIME(d.delivery_time))
                END
                -
                TIME_TO_SEC(TIME(o.order_time))
            ) / 60
        ),
        2
    ) AS avg_delivery_time_minutes
FROM zomato_db.orders o
JOIN zomato_db.deliveries d
    ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered'
  AND d.delivery_time IS NOT NULL
  AND o.order_time IS NOT NULL
GROUP BY d.rider_id
ORDER BY avg_delivery_time_minutes DESC;


/*

-- Q.11 Monthly Restaurant Growth Ratio:
-- Calculate each restaurant's growth ratio based on the total number of delivered orders since its
joining

*/

WITH growth_ratio
AS
(
SELECT 
	o.restaurant_id,
    DATE_FORMAT(o.order_date, '%m-%y') AS month,
    COUNT(o.order_id) as crnt_month_orders,
    LAG(COUNT(o.order_id),1) OVER (PARTITION BY o.restaurant_id ORDER BY COUNT(o.order_id)) as prev_month_orders
FROM
	zomato_db.orders as o
JOIN 
	zomato_db.deliveries AS d
ON 
	o.order_id = d.order_id
WHERE
	d.delivery_status = 'Delivered'
GROUP BY o.restaurant_id , month
)

SELECT 
	restaurant_id,
    month,
    crnt_month_orders,
    prev_month_orders,
    ROUND(
    ((crnt_month_orders - prev_month_orders) / prev_month_orders) * 100,
    2
) AS growth_per
FROM growth_ratio;

/*

-- Q.12 Customer Segmentation:
-- Customer Segmentation: Segment customers into 'Gold' or 'Silver' groups based on their total spending
-- compared to the average order value (AOV). If a customer's total spending exceeds the AOV
- label them as 'Gold"; otherwise, label them as 'Silver'. Write an SQL query to determine each segment's total number of orders and total revenue

*/


WITH customer_spending AS (
    SELECT 
        o.customer_id,
        COUNT(o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_spent
    FROM zomato_db.orders o
    GROUP BY o.customer_id
),
overall_aov AS (
    SELECT 
        AVG(total_amount) AS aov
    FROM zomato_db.orders
)
SELECT
    CASE
        WHEN cs.total_spent > oa.aov THEN 'Gold'
        ELSE 'Silver'
    END AS customer_segment,
    SUM(cs.total_orders) AS total_orders,
    SUM(cs.total_spent) AS total_revenue
FROM customer_spending cs
CROSS JOIN overall_aov oa
GROUP BY customer_segment;


/*

-- Q.13 Rider Monthly Earnings:
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.

*/


SELECT 
	d.rider_id,
    DATE_FORMAT(o.order_date,'%Y-%m') as month,
    ROUND(SUM(o.total_amount * 0.08),2) AS monthly_earnings
FROM zomato_db.orders AS o
JOIN zomato_db.deliveries AS d
ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered'
GROUP BY d.rider_id,month
ORDER BY d.rider_id,month;



/*

-- Q.14 Rider Ratings Analysis:
-- Find the number of 5-star, 4-star,
and 3-star ratings each rider has.
-- riders receive this rating based on delivery time.
-- If orders are delivered less than 15 minutes of order received time the rider get 5
-- if they deliver 15 and 20 minute they get 4 star rating
-- if they deliver after 20 minute they get 3 star rating.
star
rating,

*/

WITH delivery_rating AS (
    SELECT
        d.rider_id,
        (
            TIME_TO_SEC(STR_TO_DATE(d.delivery_time, '%h:%i:%s %p'))
            -
            TIME_TO_SEC(STR_TO_DATE(o.order_time, '%H:%i:%s'))
        ) / 60 AS delivery_minutes
    FROM zomato_db.orders o
    JOIN zomato_db.deliveries d
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
)
SELECT
    rider_id,
    SUM(CASE WHEN delivery_minutes < 15 THEN 1 ELSE 0 END) AS five_star_count,
    SUM(CASE WHEN delivery_minutes BETWEEN 15 AND 20 THEN 1 ELSE 0 END) AS four_star_count,
    SUM(CASE WHEN delivery_minutes > 20 THEN 1 ELSE 0 END) AS three_star_count
FROM delivery_rating
GROUP BY rider_id
ORDER BY rider_id;


/*

-- Q.15 Order Frequency by Day:
-- Analyze order frequency per day of the week and identify the peak day for each restaurant.

*/

WITH day_as_freq
AS
(
	SELECT 
		restaurant_id,
        DAYNAME(order_date) AS day_name,
        COUNT(order_id) as frequency 
	FROM zomato_db.orders
    GROUP BY 
		 restaurant_id,
         DAYNAME(order_date)
),
ranked_days AS (
		SELECT 
			*,
			RANK() OVER (
			 PARTITION BY restaurant_id
             ORDER BY frequency DESC
			) AS rnk
		FROM day_as_freq
	)
		SELECT 
			restaurant_id,
            day_name,
            frequency
		FROM ranked_days
        WHERE rnk = 1;


/*
-- Q.16 Customer Lifetime Value (CLV):
-- CALCULATE the total revenue generated by each customer over all their orders.


*/

	SELECT 
		c.customer_name,
		o.customer_id,
        SUM(total_amount) as CLV
	FROM 
		zomato_db.orders AS o
    JOIN
		zomato_db.customers AS c
	ON
		c.customer_id = o.customer_id
    GROUP BY o.customer_id,
			 c.customer_name
	ORDER BY CLV;
	
/*

-- Q.17 Monthly Sales Trends:
-- Identify sales trends by comparing each month's total sales to the previous month.

*/


WITH monthly_sales 
AS 
(
	SELECT 
		YEAR(order_date) AS YEAR,
        MONTH(order_date) AS Month_Num,
        MONTHNAME(order_date) as MonthName,
        SUM(total_amount) AS Sales
	FROM zomato_db.orders
    GROUP BY 
		YEAR(order_date),
        MONTH(order_date),
        MONTHNAME(order_date)
)
	SELECT 
		YEAR,
        MonthName,
        SALES,
        LAG(SALES) OVER (
			ORDER BY YEAR,Month_Num
		) AS prev_month_sales,
        SALES - LAG(SALES) OVER (
			ORDER BY YEAR,MONTH_NUM
		) AS sales_change
		FROM Monthly_Sales
        GROUP BY Month_Num,YEAR,MonthNAME;
        


/*

-- Q.18 Rider Efficiency:
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages.

*/

WITH rider_avg AS (
    SELECT 
        d.rider_id,
        ROUND(
            AVG(
                CASE 
                    -- If delivery time is past midnight
                    WHEN STR_TO_DATE(TRIM(d.delivery_time), '%h:%i:%s %p')
                         < STR_TO_DATE(TRIM(o.order_time), '%h:%i:%s %p')
                    THEN TIMESTAMPDIFF(
                            MINUTE,
                            STR_TO_DATE(TRIM(o.order_time), '%h:%i:%s %p'),
                            STR_TO_DATE(TRIM(d.delivery_time), '%h:%i:%s %p') 
                            + INTERVAL 1 DAY
                         )
                    -- Normal same-day delivery
                    ELSE TIMESTAMPDIFF(
                            MINUTE,
                            STR_TO_DATE(TRIM(o.order_time), '%h:%i:%s %p'),
                            STR_TO_DATE(TRIM(d.delivery_time), '%h:%i:%s %p')
                         )
                END
            ),
            2
        ) AS avg_delivery_time_minutes
    FROM zomato_db.orders o
    JOIN zomato_db.deliveries d
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
    GROUP BY d.rider_id
),
riders_time
AS
(
	SELECT
    rider_id,
    avg_delivery_time_minutes AS Avg_Time
FROM rider_avg
GROUP BY rider_id
)

SELECT
	MIN(Avg_Time) AS Min_Avg,
    MAX(Avg_Time) AS Max_Avg
FROM riders_time;


/*

-- Q.19 Order Item Popularity:
Track the popularity of specific order items over time and identify seasonal demand spikes

*/

WITH Seasons
AS
(
SELECT 
	*,
    EXTRACT(MONTH FROM order_date) AS Month,
    CASE 
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 3 AND 6 THEN 'SUMMER'
        WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 10 THEN 'RAINY'
        ELSE 'WINTER'
	END AS SEASONS
FROM zomato_db.orders
)

SELECT 
	order_item,
    COUNT(order_id) AS FREQUENCIES,
    Seasons
FROM SEASONS
GROUP BY order_item,Seasons;

    
/*

-- Q.20 Rank Each city based on the total revenue for last year 2023 

*/


WITH city_revenue AS (
    SELECT
        r.city,
        SUM(o.total_amount) AS total_revenue
    FROM zomato_db.orders o
    JOIN zomato_db.restaurants r
        ON o.restaurant_id = r.restaurant_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY r.city
)
SELECT
    city,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS rnk
FROM city_revenue;


-- ------------------ ************** ----------------------------

    








    

    
    
	














	

	





