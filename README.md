# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Sales_Analysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Sales_Analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
-- CREATE TABLE 
DROP TABLE IF EXISTS retail_sales; 
CREATE TABLE retail_sales 
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantity INT,	
				price_per_unit FLOAT,
				cogs FLOAT,	
				total_sale FLOAT
			);
            

SET GLOBAL local_infile = 1;

-- Loading Data

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/Desktop/Retail-Sales-Analysis-SQL-Project--P1/SQL - Retail Sales Analysis_utf .csv'
INTO TABLE Sales_Analysis.retail_sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  transactions_id,
  sale_date,
  sale_time,
  customer_id,
  gender,
  @age,
  category,
  @quantity,
  @price_per_unit,
  @cogs,
  @total_sale
)
SET
  age          = NULLIF(@age, ''),
  quantity     = NULLIF(@quantity, ''),
  price_per_unit = NULLIF(@price_per_unit, ''),
  cogs         = NULLIF(@cogs, ''),
  total_sale   = NULLIF(@total_sale, '');
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM retail_sales;

CREATE VIEW sale_made_on_2022_11_05 AS

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

SELECT * FROM sale_made_on_2022_11_05;
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
CREATE VIEW TRANSACTION_FOR_CLOTHING AS 
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;
  
SELECT * FROM TRANSACTION_FOR_CLOTHING;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
CREATE VIEW TOTAL_SALE_BY_CATEGORY AS
SELECT
	Category,
	SUM(total_sale) AS Total_Sale
FROM retail_sales
GROUP BY Category
ORDER BY Total_Sale DESC;

SELECT * FROM TOTAL_SALE_BY_CATEGORY;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
CREATE VIEW AVG_AGE_WHO_PURCHASED_BEAUTY AS 
SELECT 
	CATEGORY,
	ROUND(AVG(AGE),2)
FROM retail_sales
GROUP BY CATEGORY
HAVING CATEGORY = 'BEAUTY';

SELECT * FROM AVG_AGE_WHO_PURCHASED_BEAUTY;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
CREATE VIEW TOTAL_SALE_GR8_THAN_1000 AS
SELECT 
	* FROM retail_sales
WHERE total_sale >= 1000;

SELECT * FROM TOTAL_SALE_GR8_THAN_1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
CREATE VIEW total_no_of_transactions_by_gender AS 
SELECT 
	CATEGORY,
	COUNT(*) AS TOTAL_NO_OF_TRANSACTIONS,
    GENDER
FROM retail_sales
GROUP BY Category ,gender
ORDER BY TOTAL_NO_OF_TRANSACTIONS DESC;

SELECT * FROM total_no_of_transactions_by_gender;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
WITH Monthly_Avg AS (
	SELECT
		YEAR(sale_date) AS Year,
        MONTH(sale_date) AS Month,
        ROUND(AVG(total_sale),2) AS Avg_Sale
	FROM Retail_sales
    GROUP BY YEAR(sale_date),MONTH(sale_date)
)
SELECT *
FROM (
	SELECT
        Year,
        Month,
        Avg_Sale,
        RANK() OVER (PARTITION BY Year ORDER BY Avg_Sale DESC) AS rank_month
	FROM monthly_avg
)ranked
where rank_month = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
CREATE VIEW TOP_5_SALES AS
SELECT
	customer_id,
    SUM(total_sale) as Total_Sales
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_Sales DESC
LIMIT 5;

SELECT * FROM TOP_5_SALES;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
	Category,
    COUNT(DISTINCT(customer_id)) AS unique_count
FROM retail_sales
GROUP BY CATEGORY;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql

WITH hourly_sale AS 
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
		END AS shift
	FROM retail_sales
    )
    SELECT
		shift,
        COUNT(*) as Total_Orders
	FROM hourly_sale
    GROUP BY shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.
