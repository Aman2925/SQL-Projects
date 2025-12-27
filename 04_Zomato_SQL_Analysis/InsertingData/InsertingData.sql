USE zomato_db;

SET GLOBAL local_infile = 1;

TRUNCATE TABLE zomato_db.customers;

LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/Zomato/Dataset/customers.csv'
INTO TABLE zomato_db.customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_name, @reg_date)
SET reg_date = STR_TO_DATE(TRIM(@reg_date), '%m/%d/%Y');



LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/Zomato/Dataset/restaurants.csv'
INTO TABLE zomato_db.restaurants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(restaurant_id, restaurant_name, city, opening_hours);


TRUNCATE TABLE riders;

LOAD DATA LOCAL INFILE
'/Users/amanjayeshshah/SQL PROJECTS/Zomato/Dataset/riders.csv'
INTO TABLE riders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  rider_id,
  rider_name,
  @sign_up
)
SET sign_up = STR_TO_DATE(TRIM(@sign_up), '%m/%d/%Y');



TRUNCATE TABLE orders;

LOAD DATA LOCAL INFILE
'/Users/amanjayeshshah/SQL PROJECTS/Zomato/Dataset/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  order_id,
  customer_id,
  restaurant_id,
  order_item,
  @order_date,
  @order_time,
  order_status,
  total_amount
)
SET
  order_date = STR_TO_DATE(TRIM(@order_date), '%m/%d/%Y'),
  order_time = STR_TO_DATE(TRIM(@order_time), '%h:%i:%s %p');



LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/Zomato/Dataset/deliveries.csv'
INTO TABLE zomato_db.deliveries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(delivery_id, order_id, delivery_status, delivery_time, rider_id);


UPDATE zomato_db.deliveries d
JOIN zomato_db.orders o
    ON d.order_id = o.order_id
SET d.delivery_time =
    DATE_FORMAT(
        ADDTIME(
            STR_TO_DATE(o.order_time, '%H:%i:%s'),
            SEC_TO_TIME(
                FLOOR(600 + RAND() * 4800)
            )
        ),
        '%h:%i:%s %p'
    )
WHERE d.delivery_status = 'Delivered';


SET SQL_SAFE_UPDATES = 0;


