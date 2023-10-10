#creating database
CREATE DATABASE IF NOT EXISTS walmart;

#Craeting Table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id  VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,  #cost of the goods sold
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT * FROM sales;

#importing data into table

SELECT * FROM sales;

#Product Analysis to conduct analysis to understand different product lines, which protuct line performs best and which needs some improvemnt

#1 Data Wrangling: NOT NULL takes care of null values
#2 Feature Engineering 1) adding time_of_the_day - Morning, Afternoon and Evening, day_name, month_name

-- ------------------Feature Engineering 1- Adding time_of_day -----------------------------

SELECT 
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
        ELSE 'Evening'
    END
	) AS time_of_day
FROM sales;

#adding time_of_day empty column to sales table

ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);

SELECT * FROM sales;

#Adding values to time_of_day column

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
        ELSE 'Evening'
    END
);

SELECT * FROM sales;
-- ----------------------------------------------------------------------------------------

-- ------------------Feature Engineering 2- Adding day_name -------------------------------

#getting dayname

SELECT date,
DAYNAME(date)
FROM sales;

ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(30);

SELECT * FROM sales;

UPDATE sales
SET day_name = DAYNAME(date);

SELECT * FROM sales;

-- ----------------------------------------------------------------------------------------

-- ------------------Feature Engineering 2- Adding month_name -------------------------------
SELECT date,
MONTHNAME(date)
FROM sales;

ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(10);

SELECT * FROM sales;

UPDATE sales
SET month_name = MONTHNAME(date);

SELECT * FROM sales;
-- ----------------------------------------------------------------------------------------

-- -----------------------EXPLORATORY DATA ANALYSIS ---------------------------------------

#Q1. How many unique cities are there in the dataset? (QuestionType: Generic)

SELECT DISTINCT city FROM sales;

-- ----------------------------------------------------------------------------------------

#Q2. In which city is each branch located? (QuestionType: Generic)

SELECT DISTINCT city, branch FROM sales;

-- ----------------------------------------------------------------------------------------

#Q3. How many unique products lines does the dataset have? (QuestionType: Product based)

SELECT DISTINCT product_line FROM sales;

-- ----------------------------------------------------------------------------------------

#Q4. Most common mode of payment? (QuestionType: Product based)

SELECT DISTINCT payment_method, COUNT(payment_method) AS count
FROM sales
GROUP BY payment_method
ORDER BY count DESC
LIMIT 1;
-- ----------------------------------------------------------------------------------------

#Q5. Most selling product line? (QuestionType: Product based)

SELECT product_line, COUNT(product_line) as count
FROM sales
GROUP BY product_line
ORDER BY count DESC
LIMIT 1;
-- ----------------------------------------------------------------------------------------

#Q6. Total Revenue by month? (QuestionType: Product based)

SELECT month_name, SUM(total) as sum
FROM sales
GROUP BY month_name
ORDER BY sum DESC;
-- ----------------------------------------------------------------------------------------

#Q6. which month has largest cost of goods sold or cogs? (QuestionType: Product based)

SELECT month_name, SUM(cogs) as sum_cogs
FROM sales
GROUP BY month_name
ORDER BY sum_cogs DESC
LIMIT 1;
-- ----------------------------------------------------------------------------------------
#Q7. which product line has highest revenue? (QuestionType: Product based)

SELECT product_line, SUM(total) as sum_prod
FROM sales
GROUP BY product_line
ORDER BY sum_prod DESC
LIMIT 1;
-- ----------------------------------------------------------------------------------------
#Q8. city with highest revenue? (QuestionType: Product based)

SELECT city, SUM(total) as sum_city
FROM sales
GROUP BY city
ORDER BY sum_city DESC
LIMIT 1;
-- ----------------------------------------------------------------------------------------
#Q9. product line with highest VAT? (QuestionType: Product based)

SELECT product_line, AVG(VAT) as sum_vat
FROM sales
GROUP BY product_line
ORDER BY sum_vat DESC
LIMIT 1;
-- ----------------------------------------------------------------------------------------
#Q10 Which branch sold more products than average products sold (QuestionType: Product based)

SELECT branch, SUM(quantity) 
FROM sales
GROUP BY branch;
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- ----------------------------------------------------------------------------------------
#Q11 Most common product line by gender (QuestionType: Product based)

SELECT gender, product_line, COUNT(gender) as gen_count
FROM sales
GROUP BY gender, product_line;
ORDER BY genb_count DESC;

-- ----------------------------------------------------------------------------------------
#Q12 Average rating of each product (QuestionType: Product based)

SELECT product_line, ROUND(AVG(rating), 2)avg
FROM sales
GROUP BY product_line
ORDER BY avg DESC;

-- ----------------------------------------------------------------------------------------
# Q13 Fetch each product and add a acolumn to those products having average above the total average of sales showing 'Good' and 'Bad'

CREATE VIEW v1 AS
SELECT product_line, AVG(quantity) as sum
FROM sales
GROUP BY product_line;
ORDER BY sum DESC;

SELECT product_line, sum, 
	(CASE
        WHEN sum > (SELECT AVG(quantity) FROM sales) THEN 'Good'
        ELSE 'Bad'
    END
	) AS reception
FROM v1;
