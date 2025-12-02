CREATE DATABASE COFFEESHOP_PROJ;

USE COFFEESHOP_PROJ;


-- Coffee Shop SQL Case Study - DataBase SetUp

CREATE TABLE Ingredients (
		ing_id VARCHAR (10) PRIMARY KEY, 
        ing_name VARCHAR (100) NOT NULL, 
        ing_weight INTEGER NOT NULL, 
        ing_meas VARCHAR (16),
		ing_price DECIMAL (10, 2)
);

CREATE TABLE Inventary
(
	inv_id VARCHAR(10) PRIMARY KEY,
	ing_id VARCHAR (16) NOT NULL,
	quantity INTEGER NOT NULL CHECK(quantity =0)
);


CREATE TABLE menu_items
(
	item_id VARCHAR(10) PRIMARY KEY,
	sku VARCHAR (20) NOT NULL,
	item_name VARCHAR (50) NOT NULL,
	item_cat VARCHAR (30) NOT NULL,
	item_size VARCHAR(10) NOT NULL,
	item_price DECIMAL (5, 2) NOT NULL CHECK (item_price >= 0)
);


CREATE TABLE orders (
    row_id SERIAL PRIMARY KEY,
    order_id TEXT,
    created_at TEXT,
    item_id VARCHAR(10),
    quantity INTEGER NOT NULL CHECK(quantity > 0),
    cust_name VARCHAR(50),
    in_or_out TEXT
);

CREATE TABLE recipe (
    row_id SERIAL PRIMARY KEY,
    recipe_id VARCHAR(20) NOT NULL,
    ing_id VARCHAR(20) NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity > 0)
);

CREATE TABLE rota (
    row_id SERIAL PRIMARY KEY,
    rota_id VARCHAR(10),
    date DATE,
    shift_id VARCHAR(10),
    staff_id VARCHAR(10)
);

CREATE TABLE shift (
    shift_id VARCHAR(10) PRIMARY KEY,
    day_of_week VARCHAR(10),
    start_time TIME,
    end_time TIME
);

CREATE TABLE staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    sal_per_hour DECIMAL(10,2)
);

CREATE TABLE coffeeshop (
    row_id SERIAL PRIMARY KEY,
    rota_id VARCHAR(10),
	date VARCHAR(10),
    shift_id VARCHAR(10),
    staff_id VARCHAR(10)
);

SELECT * FROM coffeeshop;
SELECT * FROM ingredients;
SELECT * FROM inventary;
SELECT * FROM menu_items;
SELECT * FROM orders;
SELECT * FROM recipe;
SELECT * FROM rota;
SELECT * FROM shift;
SELECT * FROM staff;

DROP TABLE IF EXISTS 
  coffeeshop, 
  ingredients, 
  inventary, 
  menu_items, 
  orders, 
  recipe, 
  rota, 
  shift, 
  staff 
CASCADE;

SET GLOBAL local_infile = 1;

TRUNCATE TABLE coffeeshop;



LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/coffeeshop.csv'
INTO TABLE coffeeshop
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/ingredients.csv'
INTO TABLE ingredients
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE inventary
DROP CONSTRAINT inventary_chk_1;


LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/inventory.csv'
INTO TABLE inventary
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/items.csv'
INTO TABLE menu_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/recipe.csv'
INTO TABLE recipe
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/rota.csv'
INTO TABLE rota
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/shift.csv'
INTO TABLE shift
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE staff;

SET FOREIGN_KEY_CHECKS = 1;


LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/CoffeeShop/staff.csv'
INTO TABLE staff
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;






