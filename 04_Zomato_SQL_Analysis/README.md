---

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

Identified the **top 5 most frequently ordered dishes** by a specific customer within the last year using:

* Aggregation
* Window functions (`DENSE_RANK`)
* Date filtering

---

### 2️⃣ Popular Time Slots Analysis

Analyzed **peak ordering hours** using:

* 2-hour time slot bucketing
* Multiple approaches (`CASE`, mathematical grouping)

---

### 3️⃣ Order Value Analysis

Calculated **average order value (AOV)** for customers placing more than 10 orders to identify high-value customers.

---

### 4️⃣ High-Value Customers

Identified customers who spent **more than ₹5,000** across all orders.

---

### 5️⃣ Restaurant Revenue Ranking

Ranked restaurants **within each city** based on total revenue from the last year using:

* CTEs
* `RANK()` window function

---

### 6️⃣ Most Popular Dish by City

Determined the **most ordered dish in each city**, showcasing city-level food preferences.

---

### 7️⃣ Customer Churn Analysis

Identified customers who ordered in **2023 but not in 2024**, helping understand churn behavior.

---

### 8️⃣ Cancellation Rate Comparison

Calculated and compared **order cancellation rates** for each restaurant between the current and previous year.

---

### 9️⃣ Rider Average Delivery Time

Computed **average delivery time per rider**, handling:

* AM/PM formatted time
* Midnight crossover logic

---

### 🔟 Monthly Restaurant Growth Ratio

Analyzed restaurant growth trends using:

* Monthly delivered orders
* `LAG()` function to calculate growth percentage

---

### 1️⃣1️⃣ Customer Segmentation

Segmented customers into **Gold** and **Silver** categories based on total spending compared to overall AOV.

---

### 1️⃣2️⃣ Rider Monthly Earnings

Calculated each rider’s **monthly earnings**, assuming a commission-based payout model.

---

### 1️⃣3️⃣ Rider Ratings Analysis

Assigned **3-star, 4-star, and 5-star ratings** to riders based on delivery time performance.

---

### 1️⃣4️⃣ Order Frequency by Day

Identified the **peak ordering day for each restaurant** using ranking logic.

---

### 1️⃣5️⃣ Customer Lifetime Value (CLV)

Calculated **total revenue generated by each customer** across all orders.

---

### 1️⃣6️⃣ Monthly Sales Trend Analysis

Compared **month-over-month sales performance** using:

* Aggregation
* `LAG()` for trend comparison

---

### 1️⃣7️⃣ Rider Efficiency Evaluation

Identified **fastest and slowest riders** based on average delivery times with proper midnight handling.

---

### 1️⃣8️⃣ Seasonal Item Popularity

Analyzed **seasonal demand patterns** (Summer, Rainy, Winter) for different food items.

---

### 1️⃣9️⃣ City Revenue Ranking (2023)

Ranked cities based on **total revenue generated in 2023** using CTEs and window functions.

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


