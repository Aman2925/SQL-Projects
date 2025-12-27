# 🍽️ Zomato Food Delivery Analysis – SQL Project

## Project Overview

**Project Title**: Zomato Food Delivery Analysis
**Level**: Advanced
**Database**: `zomato_db`

This project demonstrates an **end-to-end SQL analytics case study** on a food delivery platform inspired by Zomato.
The analysis focuses on **customer behavior, restaurant performance, revenue trends, delivery efficiency, and time-based analytics**, solving real-world business problems using SQL.

The project showcases **advanced SQL querying, window functions, CTEs, time handling, and analytical thinking** commonly required in data analyst roles.

---

## Objectives

1. Analyze **customer ordering behavior and spending patterns**
2. Identify **top-performing restaurants, dishes, and cities**
3. Evaluate **order trends across time slots, days, months, and seasons**
4. Measure **rider efficiency and delivery performance**
5. Handle **real-world data challenges** such as AM/PM time formats and midnight delivery cases
6. Generate **business-driven insights** using SQL

---

## Database Overview

The database consists of multiple relational tables representing a food delivery ecosystem:

* `customers` – customer details and registration data
* `restaurants` – restaurant information and city mapping
* `orders` – order transactions including date, time, items, and amount
* `deliveries` – delivery details including rider and delivery time
* `riders` – delivery partner information

Relationships are maintained using **primary and foreign keys**, simulating real production-level data design.

---

## Database Setup

- ** Database Creation**: Created a database named `zomato_db`.
- **Table Creation**: Created tables for customers, restaurants, orders, deliveries, and riders. Each table includes relevant columns and relationships.

```sql
-- Creating Database

-- ZOMATO DATA ANALYSIS USING SQL

CREATE DATABASE zomato_db;

USE zomato_db;

-- CREATE Customer Table

DROP TABLE IF EXISTS customers;
CREATE TABLE customers 
	(
	    customer_id INT PRIMARY KEY,	
		customer_name VARCHAR(25),	
		reg_date DATE
	);

-- CREATE Restaurants Table
    
DROP TABLE IF EXISTS restaurants;
CREATE TABLE restaurants
	 (
		restaurant_id INT PRIMARY KEY,
        restaurant_name VARCHAR(55),
        city VARCHAR(25),
        opening_hours VARCHAR(55)
     );
     
-- CREATE Orders Table


DROP TABLE IF EXISTS orders;
CREATE TABLE orders
	 (
		order_id INT PRIMARY KEY,
        customer_id INT,     -- FK
        restaurant_id INT,   -- FK
        order_item VARCHAR(45),
        order_date DATE,
        order_time VARCHAR(55),
        order_status VARCHAR(25),
        total_amount FLOAT
     );

-- CREATE Riders Table

DROP TABLE IF EXISTS riders;
CREATE TABLE riders 
	  (
		 rider_id INT PRIMARY KEY,
         rider_name VARCHAR(55),
         sign_up DATE
      );

-- CREATE Deliveries Table

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries
	  (
		delivery_id INT PRIMARY KEY,
        order_id INT, -- FK
        delivery_status VARCHAR(25),
        delivery_time VARCHAR(55),
        rider_id INT -- FK
	   );
       
       

-- ADDING CONSTRAINTS 

ALTER TABLE orders
ADD CONSTRAINT fk_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);


ALTER TABLE orders
ADD CONSTRAINT fk_restaurant
FOREIGN KEY (restaurant_id)
REFERENCES restaurants(restaurant_id);

ALTER TABLE deliveries
ADD CONSTRAINT fk_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE deliveries
ADD CONSTRAINT fk_riders
FOREIGN KEY (rider_id)
REFERENCES riders(rider_id);

```


## Data Quality Checks

Before analysis, missing value checks were performed across all tables to ensure data integrity:

* Customers: name, registration date
* Restaurants: name, city, opening hours
* Orders: customer ID, restaurant ID, item, date, time, status, amount
* Deliveries: order ID, rider ID, delivery time, delivery status
* Riders: rider name, signup date

This step ensures **accurate and reliable analysis**.

---

## Analysis & SQL Tasks

### 1️⃣ Top Ordered Dishes by Customer
**Write a query to find the top 5 most frequently ordered dishes by customer called "Aman Singh" in the last 1 year**

```sql

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

```

---

### 2️⃣ Popular Time Slots Analysis

**Identify the time slots during which the most orders are placed. based on 2-hour intervals**

```sql
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00 - 02:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN '02:00 - 04:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN '04:00 - 06:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN '06:00 - 08:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN '08:00 - 10:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN '10:00 - 12:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN '12:00 - 14:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN '14:00 - 16:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN '16:00 - 18:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN '18:00 - 20:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN '20:00 - 22:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 22 AND 23 THEN '22:00 - 00:00'
    END AS time_slot,
    COUNT(order_id) AS order_count
FROM zomato_db.orders
GROUP BY time_slot
ORDER BY order_count DESC;


-- Approach 2

SELECT 
    FLOOR(EXTRACT(HOUR FROM order_time)/2) * 2 AS start_time,
    FLOOR(EXTRACT(HOUR FROM order_time)/2) * 2 + 2 AS end_time,
    COUNT(order_id) AS order_count
FROM zomato_db.orders
GROUP BY start_time, end_time
ORDER BY order_count DESC;

```

---

### 3️⃣ Order Value Analysis

**Find the average order value per customer who has placed more than 10 orders.
Return customer_name, and aov (average order value)**

```sql

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

```
---

### 4️⃣ High-Value Customers

**List the customers who have spent more than 5K in total on food orders.
   return customer_name,customer_id and total_spent !**

```sql

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

```
---

### 5️⃣ Restaurant Revenue Ranking

**Rank restaurants by their total revenue from the last year, including their name, total revenue, and rank within their city**

```sql

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

```

---

### 6️⃣ Most Popular Dish by City
**Identify the most popular dish in each city based on the number of orders**

```sql

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

```

---

### 7️⃣ Customer Churn Analysis

**Find customers who haven't placed an order in 2024 but did in 2023**

```sql

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

```

---

### 8️⃣ Cancellation Rate Comparison
 **Calculate and compare the order cancellation rate for each restaurat between the
 current year and the previous year**

```sql

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

```

---

### 9️⃣ Rider Average Delivery Time

**Determine each rider's average delivery time**

```sql
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

```

---

### 🔟 Monthly Restaurant Growth Ratio
**Calculate each restaurant's growth ratio based on the total number of delivered orders since its
joining**

```sql
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

```

---

### 1️⃣1️⃣ Customer Segmentation
**Segment customers into 'Gold' or 'Silver' groups based on their total spending compared to the average order value (AOV). If a customer's total spending exceeds the AOV, label them as 'Gold'; otherwise, label them as 'Silver'. Write an SQL query to determine each segment's total number of orders and total revenue**

```sql

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

```

---

### 1️⃣2️⃣ Rider Monthly Earnings
**Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount**

```sql
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

```

---

### 1️⃣3️⃣ Rider Ratings Analysis
**Find the number of 5-star, 4-star,
and 3-star ratings each rider has.
riders receive this rating based on delivery time.
If orders are delivered less than 15 minutes of order received time the rider get 5
if they deliver 15 and 20 minute they get 4 star rating
if they deliver after 20 minute they get 3 star rating.
star
rating**

```sql

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

```

---

### 1️⃣4️⃣ Order Frequency by Day
**Analyze order frequency per day of the week and identify the peak day for each restaurant**

```sql

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

```

---

### 1️⃣5️⃣ Customer Lifetime Value (CLV)
**CALCULATE the total revenue generated by each customer over all their order**

```sql

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

```

---

### 1️⃣6️⃣ Monthly Sales Trend Analysis
**Identify sales trends by comparing each month's total sales to the previous month**

```sql

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

```



---

### 1️⃣7️⃣ Rider Efficiency Evaluation
**Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages**

```sql

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

```

---

### 1️⃣8️⃣ Seasonal Item Popularity
**Track the popularity of specific order items over time and identify seasonal demand spikes**

```sql

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

```

---

### 1️⃣9️⃣ City Revenue Ranking (2023)
**Rank Each city based on the total revenue for last year 2023**

```sql

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

```

---

## SQL Concepts Demonstrated

* INNER & LEFT JOINs
* GROUP BY & HAVING
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions (`RANK`, `DENSE_RANK`, `LAG`)
* Date & Time Functions
* String-to-Time Conversion
* Real-world time handling (AM/PM, midnight crossover)
* Business-driven analytical queries

---

## Tools Used

* **MySQL**
* **SQL Workbench**
* **GitHub**

---

## Key Learnings & Outcomes

* Solved **real-world SQL analytics problems**
* Gained strong command over **time-based data handling**
* Improved ability to translate **business questions into SQL queries**
* Strengthened analytical thinking using **window functions and CTEs**

---

## How to Use This Project

1. Clone the repository:

   ```bash
   git clone https://github.com/HeyChamp29/SQL-Projects.git
   ```

2. Navigate to the Zomato project:

   ```bash
   cd SQL-Projects/04_Zomato_SQL_Analysis
   ```

3. Set up the database:

   * Create `zomato_db`
   * Load tables and data

4. Run queries sequentially to explore analysis and insights.

---

## Conclusion

This project demonstrates **advanced SQL proficiency** applied to a realistic food delivery business scenario.
It reflects how SQL is used in **data analytics roles** to derive insights, evaluate performance, and support data-driven decision-making.

---

## Author

**Aman Shah**
🎓 B.Tech Engineering Student
📍 Mumbai, India
💼 Aspiring Data Analyst

🔗 GitHub: [https://github.com/HeyChamp29](https://github.com/HeyChamp29)
🔗 LinkedIn: [https://www.linkedin.com/in/aman-shah-546775255/](https://www.linkedin.com/in/aman-shah-546775255/)

---


