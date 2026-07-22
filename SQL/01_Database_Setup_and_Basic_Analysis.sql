-- =========================================
-- Amazon Sales Analysis Project
-- Author: Aryan
-- =========================================

-- Create Database
DROP DATABASE IF EXISTS amazon_sales_analysis;
CREATE DATABASE amazon_sales_analysis;
USE amazon_sales_analysis;

-- Create Table
CREATE TABLE amazon_sales (
order_id VARCHAR(255),
order_date VARCHAR(255),
status VARCHAR(255),
fulfilment VARCHAR(255),
sales_channel VARCHAR(255),
ship_service_level VARCHAR(255),
style VARCHAR(255),
sku VARCHAR(255),
category VARCHAR(255),
size VARCHAR(255),
asin VARCHAR(255),
courier_status VARCHAR(255),
qty VARCHAR(255),
amount VARCHAR(255),
ship_city VARCHAR(255),
ship_state VARCHAR(255),
ship_postal_code VARCHAR(255),
promotion_ids TEXT,
b2b VARCHAR(255),
fulfilled_by VARCHAR(255)
);

-- Import Data
LOAD DATA LOCAL INFILE 'C:/Users/Windows Pc/Desktop/A/Amazon Sales Analytics/3. Excel/Amazon_Sales_Clean_v1.csv'
INTO TABLE amazon_sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
order_id,
order_date,
status,
fulfilment,
sales_channel,
ship_service_level,
style,
sku,
category,
size,
asin,
courier_status,
qty,
amount,
ship_city,
ship_state,
ship_postal_code,
promotion_ids,
b2b,
fulfilled_by
);

-- =========================================
-- Data Analysis
-- =========================================
-- =========================================
-- SECTION 1 : DATASET OVERVIEW
-- =========================================
-- Total orders, products, categories and states

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT category) AS total_categories,
    COUNT(DISTINCT sku) AS total_products,
    COUNT(DISTINCT ship_state) AS states_served,
    COUNT(DISTINCT sales_channel) AS sales_channels
FROM amazon_sales;


-- =========================================
-- SECTION 2 : ORDER STATUS ANALYSIS
-- =========================================

SELECT
    status,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY status
ORDER BY total_orders DESC;


-- =========================================
-- SECTION 3 : CATEGORY ANALYSIS
-- =========================================

SELECT
    category,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY category
ORDER BY total_orders DESC;


-- =========================================
-- SECTION 4 : FULFILMENT ANALYSIS
-- =========================================

SELECT
    fulfilment,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY fulfilment
ORDER BY total_orders DESC;


-- =========================================
-- SECTION 5 : SALES CHANNEL ANALYSIS
-- =========================================

SELECT
    sales_channel,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY sales_channel
ORDER BY total_orders DESC;
