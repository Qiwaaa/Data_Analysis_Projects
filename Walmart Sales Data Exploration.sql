CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 5) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1)
);



-- ----------------------------------------------------------------------
-- ---------------------------------Feature Engineering------------------

-- time_of_day

SELECT
    time,
    CASE
        WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:00:00" AND "18:00:00" THEN "Afternoon"
        ELSE "Evening"
	END AS time_of_day
From sales;

ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day =
    CASE
        WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:00:00" AND "18:00:00" THEN "Afternoon"
        ELSE "Evening"
	END;

-- day_name

SELECT
    date,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT
    date,
    MONTHNAME(date) AS month_name
From sales;

ALTER TABLE sales
ADD column month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------Generic Excel----------------------------------------------------------------

-- How many unique cities does the data have?

SELECT
    DISTINCT city
FROM sales;

-- In which city is each branch?

SELECT
    DISTINCT branch
FROM sales;

SELECT
    DISTINCT branch,city
FROM sales;


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------Product----------------------------------------------------------------------------
-- How many unique product lines does the data have?

SELECT 
    COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?

SELECT 
    payment_method, 
    COUNT(payment_method) AS cpm
From sales
GROUP BY payment_method
ORDER BY cpm DESC
LIMIT 1;


-- What is the most selling product line?

SELECT 
    product_line, 
    COUNT(product_line) AS cpl
From sales
GROUP BY product_line
ORDER BY cpl DESC
LIMIT 1;

-- What is the total revenue by month?

SELECT
    month_name AS month,
    SUM(total) AS total_revenue
FROM sales
Group BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?

SELECT
    month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC
LIMIT 1;

-- What product line  with the largest revenue?

SELECT
    product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- What is the city branch with the largest revenue?

SELECT
    branch,
    city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY branch,city
ORDER BY total_revenue DESC
LIMIT 1;
    
-- What product line had the largest VAT ##?

SELECT
    product_line,
    SUM(VAT) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC
LIMIT 1;

-- Which branch sold more products than average product sold?

SELECT 
    branch,
    SUM(quantity) AS quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity)> (SELECT AVG(quantity) FROM sales);

--  What is the most common product line by gender?

SELECT
    gender,
    product_line,
    COUNT(gender) AS gender_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY gender_cnt DESC;

--  What is the average rating of each product line?

SELECT
    product_line,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------- Sales------------------------------------------------------------------------------------------------------------------


-- Number of sales made in each time of the day per weekday

SELECT
	day_name,
    time_of_day,
    COUNT(*) AS total_sales
From sales
GROUP BY day_name, time_of_day
ORDER BY day_name, total_sales DESC;


-- Which of the customer types brings the most revenue?

SELECT
    customer_type,
    SUM(total) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
    city,
    AVG(VAT/total*100) AS avg_vat_p
FROM sales 
GROUP BY city
ORDER BY avg_vat_p DESC;
    

-- Which customer type pays the most in VAT?

SELECT
    customer_type,
    SUM(VAT) AS vat_total
FROM sales
GROUP BY customer_type
ORDER BY vat_total DESC;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------Customer------------------------------------------------------------------------------------

-- How many unique customer types does the data have?

SELECT
    DISTINCT(customer_type)
From sales;

-- How many unique payment methods does the data have?

SELECT
    DISTINCT(payment_method) 
From sales;

-- What is the most common customer type?

SELECT
    customer_type,
    COUNT(*) AS cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC
LIMIT 1;

-- Which customer type buys the most?

SELECT
    customer_type,
    COUNT(customer_type) AS customer_cnt
FROM sales
GROUP BY customer_type
LIMIT 1;

-- What is the gender of most of the customers?

SELECT
    gender,
    COUNT(gender) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC
LIMIT 1;

-- What is the gender distribution per branch?

SELECT
    branch,
    gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender_cnt DESC;

-- Which time of the day do customers give most ratings?

SELECT
    time_of_day,
    SUM(rating) AS rating_total
FROM sales
GROUP BY time_of_day
ORDER BY rating_total DESC
LIMIT 1;


-- Which time of the day do customers give most ratings per branch?

SELECT
    branch,
    time_of_day,
    SUM(rating) AS rating_total
FROM sales
GROUP BY branch, time_of_day
ORDER BY rating_total DESC
LIMIT 1;

-- Which day of the week has the best avg ratings?

SELECT
    day_name,
    AVG(rating) AS rating_avg
FROM sales
GROUP BY day_name
ORDER BY rating_avg DESC
LIMIT 1;

-- Which day of the week has the best average ratings per branch?

SELECT
    branch,
    day_name,
    AVG(rating) AS rating_avg
FROM sales
GROUP BY branch,day_name
ORDER BY branch,rating_avg DESC;













