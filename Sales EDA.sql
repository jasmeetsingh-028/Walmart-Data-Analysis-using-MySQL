
-- --------------------------------------- SALES EDA ------------------------------------

-- --------------------------------------------------------------------------------------
#Q1. Which of the customers type brings the most revenue?

SELECT customer_type, sum(total) as total
FROM sales
GROUP BY customer_type
ORDER BY total DESC;
-- --------------------------------------------------------------------------------------

#Q2. Which city has highest tax percentage?

SELECT city, AVG(VAT) as avg
FROM sales
GROUP BY city
ORDER BY avg DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------

#Q3. Which customer type pays the most VAT?

SELECT customer_type, SUM(VAT) as sum
FROM sales
GROUP BY customer_type
ORDER BY sum DESC
LIMIT 1;