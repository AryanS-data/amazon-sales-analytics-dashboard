USE amazon_sales_analysis;

-- =========================================
-- SECTION 6 : DATA QUALITY CHECKS
-- =========================================

-- Check missing values in key columns

SELECT
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN order_date IS NULL OR order_date = '' THEN 1 ELSE 0 END) AS missing_order_date,
    SUM(CASE WHEN status IS NULL OR status = '' THEN 1 ELSE 0 END) AS missing_status,
    SUM(CASE WHEN category IS NULL OR category = '' THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN amount IS NULL OR amount = '' THEN 1 ELSE 0 END) AS missing_amount,
    SUM(CASE WHEN ship_state IS NULL OR ship_state = '' THEN 1 ELSE 0 END) AS missing_ship_state
FROM amazon_sales;

-- Check for duplicate Order IDs

SELECT
    order_id,
    COUNT(*) AS occurrences
FROM amazon_sales
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- Count distinct values for important columns

SELECT
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT sku) AS unique_products,
    COUNT(DISTINCT category) AS unique_categories,
    COUNT(DISTINCT ship_state) AS unique_states,
    COUNT(DISTINCT ship_city) AS unique_cities
FROM amazon_sales;

-- =========================================
-- SECTION 7 : SALES ANALYSIS
-- =========================================

-- Total Sales Amount

SELECT
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_sales
FROM amazon_sales
WHERE amount <> '';

-- Average Order Value

SELECT
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_order_value
FROM amazon_sales
WHERE amount <> '';

-- Highest Order Value

SELECT
    MAX(CAST(amount AS DECIMAL(10,2))) AS highest_order_value
FROM amazon_sales
WHERE amount <> '';

-- Lowest Order Value

SELECT
    MIN(CAST(amount AS DECIMAL(10,2))) AS lowest_order_value
FROM amazon_sales
WHERE amount <> '';

SELECT
    MIN(CAST(amount AS DECIMAL(10,2))) AS lowest_order_value
FROM amazon_sales
WHERE amount <> ''
AND CAST(amount AS DECIMAL(10,2)) <> 0;

-- Top 10 Highest Value Orders

SELECT
    order_id,
    category,
    ship_state,
    CAST(amount AS DECIMAL(10,2)) AS order_amount
FROM amazon_sales
WHERE amount <> ''
ORDER BY order_amount DESC
LIMIT 10;

-- Sales by Order Status

SELECT
    status,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_sales
FROM amazon_sales
WHERE amount <> ''
GROUP BY status
ORDER BY total_sales DESC;

-- =========================================
-- SECTION 8 : PRODUCT ANALYSIS
-- =========================================

-- Top 10 Products by Number of Orders

SELECT
    sku,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY sku
ORDER BY total_orders DESC
LIMIT 10;

-- Top 10 Categories by Revenue

SELECT
    category,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

-- Average Selling Price by Category

SELECT
    category,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_price
FROM amazon_sales
WHERE amount <> ''
GROUP BY category
ORDER BY average_price DESC;

-- Number of Unique Products in Each Category

SELECT
    category,
    COUNT(DISTINCT sku) AS unique_products
FROM amazon_sales
GROUP BY category
ORDER BY unique_products DESC;

-- =========================================
-- SECTION 9 : GEOGRAPHIC ANALYSIS
-- =========================================

-- Top 10 States by Number of Orders

SELECT
    ship_state,
    COUNT(*) AS total_orders
FROM amazon_sales
WHERE ship_state <> ''
GROUP BY ship_state
ORDER BY total_orders DESC
LIMIT 10;

-- Top 10 States by Revenue

SELECT
    ship_state,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
AND ship_state <> ''
GROUP BY ship_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 10 Cities by Number of Orders

SELECT
    ship_city,
    COUNT(*) AS total_orders
FROM amazon_sales
WHERE ship_city <> ''
GROUP BY ship_city
ORDER BY total_orders DESC
LIMIT 10;

-- Top 10 Cities by Revenue

SELECT
    ship_city,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
AND ship_city <> ''
GROUP BY ship_city
ORDER BY total_revenue DESC
LIMIT 10;

-- Average Order Value by State

SELECT
    ship_state,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_order_value
FROM amazon_sales
WHERE amount <> ''
AND ship_state <> ''
GROUP BY ship_state
ORDER BY average_order_value DESC;

-- =========================================
-- SECTION 10 : SIZE ANALYSIS
-- =========================================

-- Most Ordered Sizes

SELECT
    size,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY size
ORDER BY total_orders DESC;

-- Revenue by Size

SELECT
    size,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY size
ORDER BY total_revenue DESC;

-- Average Selling Price by Size

SELECT
    size,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_price
FROM amazon_sales
WHERE amount <> ''
GROUP BY size
ORDER BY average_price DESC;

-- =========================================
-- SECTION 11 : QUANTITY ANALYSIS
-- =========================================

-- Quantity Distribution

SELECT
    qty,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY qty
ORDER BY CAST(qty AS UNSIGNED);

-- Revenue by Quantity Ordered

SELECT
    qty,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY qty
ORDER BY CAST(qty AS UNSIGNED);

-- Average Revenue per Quantity

SELECT
    qty,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY qty
ORDER BY CAST(qty AS UNSIGNED);