CREATE DATABASE Sales_Analysis;

USE Sales_Analysis;

SELECT * FROM retail_sales;

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


-- DATA EXPLORATION

-- How many sales do we have ??

SELECT COUNT(*) AS TOTAL_SALES FROM retail_sales;

-- How many Unique Customers do we have ??

SELECT COUNT(DISTINCT(CUSTOMER_ID)) FROM retail_sales;

-- How many Distinct Category do we have ??

SELECT DISTINCT(CATEGORY) AS Distinct_Category FROM retail_sales;


-- Data Analysis & Business Problems

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales;

CREATE VIEW sale_made_on_2022_11_05 AS

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

SELECT * FROM sale_made_on_2022_11_05;

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

CREATE VIEW TRANSACTION_FOR_CLOTHING AS 
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;
  
SELECT * FROM TRANSACTION_FOR_CLOTHING;

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.

CREATE VIEW TOTAL_SALE_BY_CATEGORY AS
SELECT
	Category,
	SUM(total_sale) AS Total_Sale
FROM retail_sales
GROUP BY Category
ORDER BY Total_Sale DESC;

SELECT * FROM TOTAL_SALE_BY_CATEGORY;


-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

-- METHOD-1

CREATE VIEW AVG_AGE_WHO_PURCHASED_BEAUTY AS 
SELECT 
	CATEGORY,
	ROUND(AVG(AGE),2)
FROM retail_sales
GROUP BY CATEGORY
HAVING CATEGORY = 'BEAUTY';

SELECT * FROM AVG_AGE_WHO_PURCHASED_BEAUTY;

-- METHOD-2

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

CREATE VIEW TOTAL_SALE_GR8_THAN_1000 AS
SELECT 
	* FROM retail_sales
WHERE total_sale >= 1000;

SELECT * FROM TOTAL_SALE_GR8_THAN_1000;


-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

CREATE VIEW total_no_of_transactions_by_gender AS 
SELECT 
	CATEGORY,
	COUNT(*) AS TOTAL_NO_OF_TRANSACTIONS,
    GENDER
FROM retail_sales
GROUP BY Category ,gender
ORDER BY TOTAL_NO_OF_TRANSACTIONS DESC;

SELECT * FROM total_no_of_transactions_by_gender;


-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

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

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales :


CREATE VIEW TOP_5_SALES AS
SELECT
	customer_id,
    SUM(total_sale) as Total_Sales
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_Sales DESC
LIMIT 5;

SELECT * FROM TOP_5_SALES;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	Category,
    COUNT(DISTINCT(customer_id)) AS unique_count
FROM retail_sales
GROUP BY CATEGORY;


-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

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
    

-- *********** END OF PROJECT ***************
            





)







    


