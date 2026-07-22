USE amazon_sales_analysis;

-- =========================================
-- SECTION 12 : DATE ANALYSIS
-- =========================================

-- Orders by Month

SELECT
    DATE_FORMAT(STR_TO_DATE(order_date,'%d-%m-%Y'),'%Y-%m') AS order_month,
    COUNT(*) AS total_orders
FROM amazon_sales
WHERE order_date <> ''
GROUP BY order_month
ORDER BY order_month;

-- Monthly Revenue

SELECT
    DATE_FORMAT(STR_TO_DATE(order_date,'%d-%m-%Y'),'%Y-%m') AS order_month,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY order_month
ORDER BY order_month;

-- Average Order Value by Month

SELECT
    DATE_FORMAT(STR_TO_DATE(order_date,'%d-%m-%Y'),'%Y-%m') AS order_month,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_order_value
FROM amazon_sales
WHERE amount <> ''
GROUP BY order_month
ORDER BY order_month;

-- =========================================
-- SECTION 13 : B2B vs B2C ANALYSIS
-- =========================================

-- Order Distribution

SELECT
    b2b,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY b2b
ORDER BY total_orders DESC;

-- Revenue Distribution

SELECT
    b2b,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY b2b
ORDER BY total_revenue DESC;

-- Average Order Value

SELECT
    b2b,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_order_value
FROM amazon_sales
WHERE amount <> ''
GROUP BY b2b;

-- =========================================
-- SECTION 14 : FULFILMENT PERFORMANCE
-- =========================================

-- Orders by Fulfilment Method

SELECT
    fulfilment,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY fulfilment
ORDER BY total_orders DESC;

-- Revenue by Fulfilment Method

SELECT
    fulfilment,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY fulfilment
ORDER BY total_revenue DESC;

-- Cancellation by Fulfilment Method

SELECT
    fulfilment,
    COUNT(*) AS cancelled_orders
FROM amazon_sales
WHERE status LIKE '%Cancelled%'
GROUP BY fulfilment
ORDER BY cancelled_orders DESC;

-- =========================================
-- SECTION 15 : PROMOTION ANALYSIS
-- =========================================

-- Orders with and without Promotions

SELECT
    CASE
        WHEN promotion_ids IS NULL OR promotion_ids = '' THEN 'No Promotion'
        ELSE 'Promotion Applied'
    END AS promotion_status,
    COUNT(*) AS total_orders
FROM amazon_sales
GROUP BY promotion_status;

-- Revenue with and without Promotions

SELECT
    CASE
        WHEN promotion_ids IS NULL OR promotion_ids = '' THEN 'No Promotion'
        ELSE 'Promotion Applied'
    END AS promotion_status,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY promotion_status;

-- Average Order Value with and without Promotions

SELECT
    CASE
        WHEN promotion_ids IS NULL OR promotion_ids = '' THEN 'No Promotion'
        ELSE 'Promotion Applied'
    END AS promotion_status,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_order_value
FROM amazon_sales
WHERE amount <> ''
GROUP BY promotion_status;