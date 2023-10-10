-- --------------------------------------- CUSTOMER EDA ------------------------------------

-- --------------------------------------------------------------------------------------
#Q1. Which of the customers type brings the most revenue?

SELECT customer_type, sum(total) as total
FROM sales
GROUP BY customer_type
ORDER BY total DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------
#Q2. What is the Gender of the most of the customers?

SELECT gender, COUNT(gender) as count
FROM sales
GROUP BY gender
ORDER BY count;

-- --------------------------------------------------------------------------------------
#Q3. Gender distribution per branch?

SELECT gender, branch, COUNT(gender) as gen_count
FROM sales
GROUP BY gender, branch
ORDER BY branch;

-- --------------------------------------------------------------------------------------
#Q4 Which day of the week has the best avg ratings

SELECT day_name, AVG(rating) as avg_rate
FROM sales
GROUP BY day_name
ORDER BY avg_rate DESC;

-- --------------------------------------------------------------------------------------
#Q5 Which time of the day do customer give most ratings

SELECT time_of_day, COUNT(rating) as count_rate
FROM sales
GROUP BY time_of_day
ORDER BY count_rate DESC;

-- --------------------------------------------------------------------------------------
#Q6 Which time of the day do customer give most ratings per branch

SELECT time_of_day, branch, COUNT(rating) as count_rate
FROM sales
GROUP BY time_of_day, branch
ORDER BY branch;

-- --------------------------------------------------------------------------------------
#Q6 Which day of the week has the best average ratings per branch

SELECT day_name, branch, COUNT(rating) as count_rate
FROM sales
GROUP BY day_name, branch
ORDER BY count_rate;






