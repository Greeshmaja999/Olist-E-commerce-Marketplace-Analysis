USE olist;

SET GLOBAL local_infile = 1;

USE olist;

TRUNCATE TABLE olist_customers_dataset;
TRUNCATE TABLE olist_geolocation_dataset;
TRUNCATE TABLE olist_order_items_dataset;
TRUNCATE TABLE olist_order_payments_dataset;
TRUNCATE TABLE olist_order_reviews_dataset;
TRUNCATE TABLE olist_orders_dataset;
TRUNCATE TABLE olist_products_dataset;
TRUNCATE TABLE olist_sellers_dataset;
TRUNCATE TABLE product_category_name_translation;

USE olist;

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =========================================================
-- 1. GELOCATION
-- =========================================================

CREATE TABLE IF NOT EXISTS olist_geolocation_dataset (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 2. ORDERS
-- =========================================================

CREATE TABLE IF NOT EXISTS olist_orders_dataset (
    order_id VARCHAR(32),
    customer_id VARCHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 3. ORDER ITEMS
-- =========================================================

CREATE TABLE IF NOT EXISTS olist_order_items_dataset (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 4. ORDER PAYMENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS olist_order_payments_dataset (
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 5. ORDER REVIEWS
-- =========================================================

CREATE TABLE IF NOT EXISTS olist_order_reviews_dataset (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 6. PRODUCTS
-- =========================================================

CREATE TABLE IF NOT EXISTS olist_products_dataset (
    product_id VARCHAR(32),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_products_dataset.csv'
INTO TABLE olist_products_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 7. SELLERS
-- =========================================================

CREATE TABLE IF NOT EXISTS olist_sellers_dataset (
    seller_id VARCHAR(32),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- 8. PRODUCT CATEGORY TRANSLATION
-- =========================================================

CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

LOAD DATA LOCAL INFILE
'C:/Users/Sai/OneDrive/Documents/Olist dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =========================================================
-- CHECK ALL TABLES
-- =========================================================

SELECT
    'geolocation' AS table_name,
    COUNT(*) AS row_count
FROM olist_geolocation_dataset

UNION ALL

SELECT
    'orders',
    COUNT(*)
FROM olist_orders_dataset

UNION ALL

SELECT
    'order_items',
    COUNT(*)
FROM olist_order_items_dataset

UNION ALL

SELECT
    'order_payments',
    COUNT(*)
FROM olist_order_payments_dataset

UNION ALL

SELECT
    'order_reviews',
    COUNT(*)
FROM olist_order_reviews_dataset

UNION ALL

SELECT
    'products',
    COUNT(*)
FROM olist_products_dataset

UNION ALL

SELECT
    'sellers',
    COUNT(*)
FROM olist_sellers_dataset

UNION ALL

SELECT
    'category_translation',
    COUNT(*)
FROM product_category_name_translation;

USE olist;

SHOW TABLES;

SELECT COUNT(*) FROM olist_customers_dataset;

SELECT * FROM olist_order_reviews_dataset
LIMIT 10;

#customer acquisition

SELECT COUNT(DISTINCT customer_unique_id) AS no_of_unique_customers, COUNT(DISTINCT customer_id) AS no_of_customers FROM olist_customers_dataset;

# cnt is no.of orders and COUNT(customer_unique_id) is no_of customers... This basically says like 5 orders are given by 8 customers
WITH CTE AS (SELECT customer_unique_id, COUNT(customer_unique_id) AS cnt FROM olist_customers_dataset
GROUP BY customer_unique_id)
#SELECT customer_unique_id, cnt FROM CTE
#WHERE cnt > 1;
SELECT cnt, COUNT(customer_unique_id) FROM CTE
GROUP BY 1;

# no_of product categories
SELECT COUNT(DISTINCT product_category_name) FROM olist_products_dataset;

# Year-wise number of orders
SELECT SUM(CASE WHEN order_purchase_timestamp LIKE '2016%' THEN 1 ELSE 0 END) AS '2016_orders',
SUM(CASE WHEN order_purchase_timestamp LIKE '2017%' THEN 1 ELSE 0 END) AS '2017_orders',
SUM(CASE WHEN order_purchase_timestamp LIKE '2018%' THEN 1 ELSE 0 END) AS '2018_orders'
FROM olist_orders_dataset;

# First and last order placed on
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m'), COUNT(*) FROM olist_orders_dataset
GROUP BY 1
ORDER BY 1;

# No.of states Olist is operating in
SELECT COUNT(DISTINCT customer_state) FROM olist_customers_dataset;

# No.of cities from each state Olist is operating in
SELECT customer_state, COUNT(DISTINCT customer_city) FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY 2 DESC;

# No.of customers from each state
SELECT customer_state, COUNT(DISTINCT customer_unique_id) FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY 2 DESC;

USE olist;

# customer_id and order placed on
SELECT c.customer_unique_id, MIN(order_purchase_timestamp) AS 'order_purchase_timestamp' FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY 1;

# Year-wise number of orders
SELECT SUM(CASE WHEN order_purchase_timestamp LIKE '2016%' THEN 1 ELSE 0 END) AS '2016_orders',
SUM(CASE WHEN order_purchase_timestamp LIKE '2017%' THEN 1 ELSE 0 END) AS '2017_orders',
SUM(CASE WHEN order_purchase_timestamp LIKE '2018%' THEN 1 ELSE 0 END) AS '2018_orders'
FROM (SELECT c.customer_unique_id, MIN(order_purchase_timestamp) AS 'order_purchase_timestamp' FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY 1) a;

# Month-wise customer acquisition
SELECT 
    DATE_FORMAT(first_order, '%Y-%m') AS acquisition_month,
    COUNT(*) AS new_customers
FROM (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) a
GROUP BY DATE_FORMAT(first_order, '%Y-%m')
ORDER BY acquisition_month;

# acquisition_month, new_customers, prev_month, customer_acquisition_rate and cumulative_customers
WITH CTE AS (SELECT acquisition_month, new_customers, LAG(new_customers, 1, 0) OVER(ORDER BY acquisition_month) AS prev_month
FROM (SELECT 
    DATE_FORMAT(first_order, '%Y-%m') AS acquisition_month,
    COUNT(*) AS new_customers
FROM (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) a
GROUP BY DATE_FORMAT(first_order, '%Y-%m')
ORDER BY acquisition_month) b)

SELECT *, ROUND((new_customers-prev_month) * 100 / prev_month, 2) AS customer_acquisition_rate,
SUM(new_customers) OVER (ORDER BY acquisition_month) AS cumulative_customers
FROM CTE;

# customer concentration in each state
SELECT customer_state, COUNT(DISTINCT customer_unique_id), ROUND(COUNT(DISTINCT customer_unique_id)*100/(SELECT COUNT(DISTINCT customer_unique_id) FROM olist_customers_dataset), 2) AS customer_concentration 
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY 2 DESC;


SELECT
    COUNT(*) AS orders,
    COUNT(DISTINCT customer_id) AS customers
FROM olist_orders_dataset
WHERE order_purchase_timestamp >= '2018-09-01'
  AND order_purchase_timestamp < '2018-10-01';
  
USE olist;
  
SELECT COUNT(*) FROM olist_order_payments_dataset
UNION 
SELECT COUNT(*) FROM olist_order_items_dataset
UNION
SELECT COUNT(*) FROM olist_orders_dataset;

SELECT * FROM olist_order_payments_dataset
LIMIT 10;

SELECT * FROM olist_order_items_dataset
LIMIT 10;

SELECT DISTINCT order_status FROM olist_orders_dataset;

SELECT order_status, COUNT(*)
FROM olist_orders_dataset
GROUP BY 1;

# The sequence number of a payment method used for a particular order(most of the multiple sequential methods are of credit card and voucher).
SELECT distinct payment_sequential FROM olist_order_payments_dataset ORDER BY 1;

# order ids with no details about payment
SELECT * FROM olist_orders_dataset
WHERE order_id NOT IN (SELECT DISTINCT order_id FROM olist_order_payments_dataset);

# no.of orders delivered that have no payment details
SELECT
    o.order_status,
    COUNT(*) AS orders_without_payment
FROM olist_orders_dataset o
LEFT JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL
GROUP BY o.order_status;

# number of orders with details about order items
SELECT COUNT(DISTINCT order_id) FROM olist_order_items_dataset;

USE olist;

#no.of items that didn't get delivered
SELECT COUNT(*) AS items_not_delivered
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status <> 'delivered';

# orders without item records
SELECT COUNT(*) AS orders_without_item_records
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

# total payment value of each order
SELECT order_id, SUM(payment_value) AS total_price FROM olist_order_payments_dataset
GROUP BY 1;

# overall revenue
SELECT SUM(payment_value) FROM olist_order_payments_dataset;

# REVENUE OVER TIME
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS 'month', SUM(p.payment_value) AS revenue FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o ON p.order_id = o.order_id
GROUP BY 1;

# AOV
SELECT ROUND(AVG(total_price), 2) AS AOV FROM (SELECT order_id, SUM(payment_value) AS total_price FROM olist_order_payments_dataset
GROUP BY 1) a;

# REVENUE BY CATEGORY
SELECT
    pct.product_category_name_english AS category,
    ROUND(SUM(oi.price), 2) AS item_sales,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS total_items
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY item_sales DESC;

# REVENUE BY STATE
SELECT c.customer_state, SUM(p1.payment_value) AS revenue_by_state FROM olist_order_payments_dataset p1
JOIN olist_orders_dataset o ON p1.order_id = o.order_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY 1;

# REVENUE BY PAYMENT TYPE
SELECT payment_type, SUM(payment_value) AS revenue_by_payment_type FROM olist_order_payments_dataset p1
GROUP BY 1;

# ORDERS BY STATE
SELECT c.customer_state, COUNT(DISTINCT o.order_id) AS no_of_orders FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY 1;

# ORDERS OVER TIME
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS 'month', COUNT(DISTINCT order_id) AS no_of_orders FROM olist_orders_dataset
GROUP BY 1;

# ORDER STATUS
SELECT order_status, COUNT(DISTINCT order_id) AS no_of_orders FROM olist_orders_dataset
GROUP BY 1
ORDER BY 2 DESC;

# AVG items per order

SELECT ROUND(AVG(no_of_items), 2) AS avg_items_per_order
FROM(SELECT order_id, COUNT(order_item_id) AS no_of_items FROM olist_order_items_dataset
GROUP BY order_id) a; 

# AVG Delivery Time
SELECT ROUND(AVG(DATEDIFF(
        order_delivered_customer_date,
        order_purchase_timestamp
    )), 2) AS avg_delivery_time FROM olist_orders_dataset
WHERE order_status = 'delivered';

USE olist;

# Payment types
 SELECT DISTINCT payment_methods FROM (SELECT
    order_id,
    GROUP_CONCAT(
        DISTINCT payment_type
        ORDER BY payment_type
    ) AS payment_methods,
    COUNT(*) AS payment_records
FROM olist_order_payments_dataset
GROUP BY order_id) a;

# Installments
SELECT DISTINCT order_id, payment_installments FROM olist_order_payments_dataset;

# No.of orders with installments
SELECT cnt AS no_of_installments, COUNT(cnt) AS number_of_orders_with_these_many_installments 
FROM (SELECT order_id, COUNT(*) AS cnt FROM olist_order_payments_dataset GROUP BY 1) a
GROUP BY 1
ORDER BY 1;

#payment methods used for multiple installments
SELECT DISTINCT payment_type FROM (SELECT * FROM olist_order_payments_dataset
WHERE payment_installments > 1) a;

#total payment value of each order
SELECT order_id, SUM(payment_value) AS total_amount FROM olist_order_payments_dataset
GROUP BY 1;

#payment methods and no.of payments made byy that method
SELECT payment_type, COUNT(DISTINCT order_id) AS no_of_payments FROM olist_order_payments_dataset
GROUP BY 1;


SELECT payment_type, COUNT(*) AS no_of_payments FROM olist_order_payments_dataset
GROUP BY 1;

# Min payment value, Max payment value and Avg payment value for each payment method
SELECT DISTINCT payment_methods, ROUND(AVG(total_value), 2) AS avg_value, MIN(total_value), MAX(total_value) 
FROM (SELECT
    order_id,
    GROUP_CONCAT(
        DISTINCT payment_type
        ORDER BY payment_type
    ) AS payment_methods,
    COUNT(*) AS payment_records, SUM(payment_value) AS total_value
FROM olist_order_payments_dataset
GROUP BY order_id) a
GROUP BY 1;

# No.of items delivered on time and delivered late
SELECT
    COUNT(*) AS total_items,
    SUM(CASE WHEN o.order_delivered_carrier_date <= i.shipping_limit_date THEN 1 ELSE 0 END) AS on_time_items,
    SUM(CASE WHEN o.order_delivered_carrier_date > i.shipping_limit_date THEN 1 ELSE 0 END) AS late_items
FROM olist_order_items_dataset i
JOIN olist_orders_dataset o
    ON i.order_id = o.order_id
WHERE o.order_delivered_carrier_date IS NOT NULL;

# On-time seller-to-carrier handover rate
WITH CTE AS (
SELECT
    COUNT(*) AS total_items,
    SUM(CASE WHEN o.order_delivered_carrier_date <= i.shipping_limit_date THEN 1 ELSE 0 END) AS on_time_items,
    SUM(CASE WHEN o.order_delivered_carrier_date > i.shipping_limit_date THEN 1 ELSE 0 END) AS late_items
FROM olist_order_items_dataset i
JOIN olist_orders_dataset o
    ON i.order_id = o.order_id
WHERE o.order_delivered_carrier_date IS NOT NULL)
SELECT ROUND(on_time_items/total_items, 2) AS on_time_delivery_rate FROM CTE;

#Average delivery delay in days for late orders
SELECT ROUND(AVG(DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    )), 2) AS avg_delivery_delay_time FROM olist_orders_dataset
WHERE order_delivered_customer_date > order_estimated_delivery_date;

#Avg delivery time by state.
SELECT customer_state, ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_del_time 
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC;

#Late delivery rate by state
SELECT customer_state, ROUND(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS late_del_rate
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC;

#no.of sellers associated with for different orders
SELECT DISTINCT no_of_sellers FROM (SELECT DISTINCT order_id, COUNT(order_item_id), COUNT(DISTINCT seller_id) AS no_of_sellers FROM olist_order_items_dataset
GROUP BY 1) a;

USE olist;

# No.of reviews for each review score
SELECT SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) as '5_star',
SUM(CASE WHEN review_score = 4 THEN 1 ELSE 0 END) as '4_star',
SUM(CASE WHEN review_score = 3 THEN 1 ELSE 0 END) as '3_star',
SUM(CASE WHEN review_score = 2 THEN 1 ELSE 0 END) as '2_star',
SUM(CASE WHEN review_score = 1 THEN 1 ELSE 0 END) as '1_star' FROM olist_order_reviews_dataset;

#no.of reviews made by how many number of customers
SELECT no_of_reviews, COUNT(no_of_reviews) FROM (SELECT order_id, COUNT(order_id) AS no_of_reviews FROM olist_order_reviews_dataset
GROUP BY 1
ORDER BY 2 DESC) a
GROUP BY 1;

#No.of orders that got delivered late
SELECT COUNT(DISTINCT order_id) FROM (SELECT *  FROM olist_orders_dataset
WHERE order_delivered_customer_date > order_estimated_delivery_date) a;	