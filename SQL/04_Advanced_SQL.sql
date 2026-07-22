USE amazon_sales_analysis;

-- =========================================
-- SECTION 17 : COMMON TABLE EXPRESSIONS (CTEs)
-- =========================================

-- Top 5 States by Revenue

WITH state_revenue AS (
    SELECT
        ship_state,
        ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
    FROM amazon_sales
    WHERE amount <> ''
    GROUP BY ship_state
)

SELECT *
FROM state_revenue
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 Product Categories by Revenue

WITH category_revenue AS (
    SELECT
        category,
        ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
    FROM amazon_sales
    WHERE amount <> ''
    GROUP BY category
)

SELECT *
FROM category_revenue
ORDER BY total_revenue DESC
LIMIT 5;

-- =========================================
-- SECTION 18 : ROW_NUMBER()
-- =========================================

-- Assign Row Number to Orders Based on Order Value

SELECT
    order_id,
    category,
    CAST(amount AS DECIMAL(10,2)) AS order_amount,
    ROW_NUMBER() OVER (
        ORDER BY CAST(amount AS DECIMAL(10,2)) DESC
    ) AS row_number_rank
FROM amazon_sales
WHERE amount <> '';

-- =========================================
-- SECTION 19 : RANK()
-- =========================================

-- Rank Product Categories by Revenue

SELECT
    category,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue,
    RANK() OVER(
        ORDER BY SUM(CAST(amount AS DECIMAL(10,2))) DESC
    ) AS revenue_rank
FROM amazon_sales
WHERE amount <> ''
GROUP BY category;

-- =========================================
-- SECTION 20 : DENSE_RANK()
-- =========================================

-- Dense Rank States by Revenue

SELECT
    ship_state,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(CAST(amount AS DECIMAL(10,2))) DESC
    ) AS revenue_rank
FROM amazon_sales
WHERE amount <> ''
GROUP BY ship_state;

-- =========================================
-- SECTION 21 : WINDOW FUNCTIONS
-- =========================================

-- Running Total of Revenue by Month

SELECT
    DATE_FORMAT(STR_TO_DATE(order_date,'%d-%m-%Y'),'%Y-%m') AS order_month,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS monthly_revenue,

    ROUND(
        SUM(SUM(CAST(amount AS DECIMAL(10,2))))
        OVER(
            ORDER BY DATE_FORMAT(STR_TO_DATE(order_date,'%d-%m-%Y'),'%Y-%m')
        ),
    2) AS running_total

FROM amazon_sales
WHERE amount <> ''

GROUP BY order_month

ORDER BY order_month;

-- =========================================
-- SECTION 22 : SQL VIEWS
-- =========================================

-- Create View for Monthly Sales Summary

CREATE VIEW monthly_sales_summary AS

SELECT
    DATE_FORMAT(STR_TO_DATE(order_date,'%d-%m-%Y'),'%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY order_month;


-- Display Monthly Sales Summary View

SELECT *
FROM monthly_sales_summary;


-- Create View for Category Performance

CREATE VIEW category_sales_summary AS

SELECT
    category,
    COUNT(*) AS total_orders,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue,
    ROUND(AVG(CAST(amount AS DECIMAL(10,2))),2) AS average_order_value
FROM amazon_sales
WHERE amount <> ''
GROUP BY category;


-- Display Category Performance View

SELECT *
FROM category_sales_summary;


-- Create View for State-wise Sales Summary

CREATE VIEW state_sales_summary AS

SELECT
    ship_state,
    COUNT(*) AS total_orders,
    ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
FROM amazon_sales
WHERE amount <> ''
GROUP BY ship_state;


-- Display State-wise Sales Summary View

SELECT *
FROM state_sales_summary;


-- =========================================
-- SECTION 23 : STORED PROCEDURES
-- =========================================

-- Create Procedure to Retrieve Category-wise Revenue

DELIMITER //

CREATE PROCEDURE GetCategoryRevenue()

BEGIN

    SELECT
        category,
        COUNT(*) AS total_orders,
        ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
    FROM amazon_sales
    WHERE amount <> ''
    GROUP BY category
    ORDER BY total_revenue DESC;

END //

DELIMITER ;


-- Execute Procedure

CALL GetCategoryRevenue();


-- Create Procedure to Retrieve Top 10 States by Revenue

DELIMITER //

CREATE PROCEDURE GetTopStates()

BEGIN

    SELECT
        ship_state,
        ROUND(SUM(CAST(amount AS DECIMAL(10,2))),2) AS total_revenue
    FROM amazon_sales
    WHERE amount <> ''
    GROUP BY ship_state
    ORDER BY total_revenue DESC
    LIMIT 10;

END //

DELIMITER ;


-- Execute Procedure

CALL GetTopStates();


-- =========================================
-- SECTION 24 : INDEXES
-- =========================================

-- Create Index on Order ID

CREATE INDEX idx_order_id
ON amazon_sales(order_id);


-- Create Index on Product Category

CREATE INDEX idx_category
ON amazon_sales(category);


-- Create Index on Order Status

CREATE INDEX idx_status
ON amazon_sales(status);


-- Create Index on Ship State

CREATE INDEX idx_ship_state
ON amazon_sales(ship_state);


-- Display All Indexes

SHOW INDEX
FROM amazon_sales;