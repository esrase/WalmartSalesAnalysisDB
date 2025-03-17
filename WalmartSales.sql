CREATE DATABASE IF NOT EXISTS salesDataWalmart;

USE salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    vat DECIMAL(6,4) NOT NULL,  
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct DECIMAL(6,4),  
    gross_income DECIMAL(12,4) NOT NULL,
    rating DECIMAL(2,1)
);

-- Feature Engineering -- 

-- time of day 
SELECT 
    time,
    CASE 
        WHEN time >= '00:00:00' AND time <= '11:59:59' THEN 'MORNING'
        WHEN time >= '12:00:00' AND time <= '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
    CASE 
		WHEN time >= '00:00:00' AND time <= '11:59:59' THEN 'MORNING'
        WHEN time >= '12:00:00' AND time <= '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
	END
);

-- day name 
SELECT 
     date,
     DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET day_name = DAYNAME(`date`);
SELECT day_name, date FROM sales LIMIT 10;

-- month name 
SELECT 
    date,
    MONTHNAME(date) 
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = MONTHNAME(date);


-- number of cities
SELECT 
    distinct city
FROM sales;

-- number of product
SELECT
    COUNT(distinct product_line)
FROM sales;

-- most preferred payment method
SELECT 
    payment_method,
    COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- Sales by gender
SELECT 
    gender,
    SUM(total) AS total_revenue
FROM sales
GROUP BY gender
ORDER BY total_revenue DESC;

-- most selling product line
SELECT
    product_line,
    COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- total revenue by month
SELECT 
     month_name AS month,
     SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- product line with the largest revenue
SELECT 
     product_line,
     SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Top 5 products by quantity sold
SELECT
	product_line,
    SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY product_line
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Revenue by day of the week
SELECT 
    day_name,
    SUM(total) AS total_revenue
FROM sales
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');


-- city with the largest revenue
SELECT
     branch,
     city,
     SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;














