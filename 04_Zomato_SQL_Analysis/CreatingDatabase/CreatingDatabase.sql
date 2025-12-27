-- ZOMATO DATA ANALYSIS USING SQL

CREATE DATABASE zomato_db;

USE zomato_db;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers 
	(
	    customer_id INT PRIMARY KEY,	
		customer_name VARCHAR(25),	
		reg_date DATE
	);

    
DROP TABLE IF EXISTS restaurants;
CREATE TABLE restaurants
	 (
		restaurant_id INT PRIMARY KEY,
        restaurant_name VARCHAR(55),
        city VARCHAR(25),
        opening_hours VARCHAR(55)
     );
     

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
     

DROP TABLE IF EXISTS riders;
CREATE TABLE riders 
	  (
		 rider_id INT PRIMARY KEY,
         rider_name VARCHAR(55),
         sign_up DATE
      );
      
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

