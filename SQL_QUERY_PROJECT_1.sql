-- CREATE DATABASE retail_sales;
USE retail_sales;

CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,	
    sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(100),
	quantiy INT,
	price_per_unit DECIMAL(10, 2),
	cogs DECIMAL(10,2),
	total_sale DECIMAL(10,2)
);

SELECT COUNT(*) FROM retail_sales;

-- data cleaning
SELECT * FROM retail_sales
WHERE 
	 transactions_id IS NULL
     OR
     sale_date IS NULL
     OR
     sale_time IS NULL
     OR
     customer_id IS NULL
     OR
     gender IS NULL
     OR
     age IS NULL
     OR
     category IS NULL
     OR 
     quantiy IS NULL
     OR
     price_per_unit IS NULL
     OR
     cogs IS NULL
     OR
     total_sale IS NULL;
     
DELETE FROM retail_sales
WHERE 
	 transactions_id IS NULL
     OR
     sale_date IS NULL
     OR
     sale_time IS NULL
     OR
     customer_id IS NULL
     OR
     gender IS NULL
     OR
     age IS NULL
     OR
     category IS NULL
     OR 
     quantiy IS NULL
     OR
     price_per_unit IS NULL
     OR
     cogs IS NULL
     OR
     total_sale IS NULL;

-- UNIQUE CUSTOMER
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- UNIQUE CATEGORY
SELECT COUNT(DISTINCT category) FROM retail_sales;

-- DATA ANALYSIS AND BUISNESS KEY PROBLEMS AND ANSWERS

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT           -- SELECT ROUND(AVG(age),2) FROM retail_sales WHERE category = 'Beauty';
	category,
    ROUND(AVG(age),2)
FROM retail_sales
GROUP BY category
HAVING category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, 
	   gender,
       COUNT(*) AS total_sales
FROM retail_sales
GROUP 
	BY 
	category,
	gender
ORDER BY category;
    
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM (
	SELECT 
		YEAR(sale_date) AS year_sale,
		MONTH(sale_date) AS month_sale,
		AVG(total_sale) AS avg_sale,
		RANK() OVER (
		PARTITION BY YEAR(sale_date) 
		ORDER BY AVG(total_sale) DESC)
		AS rnk
	FROM retail_sales
	GROUP 
		BY
		year_sale,
		month_sale
) AS t1
WHERE rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
    SUM(total_sale) AS sale
FROM retail_sales
GROUP BY customer_id
ORDER BY sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales 
AS (
	SELECT *, 
		CASE
			WHEN HOUR(sale_time) < 12 THEN 'Morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
)
SELECT 
	shift,
    COUNT(*) AS number_of_orders
FROM hourly_sales
GROUP BY shift;

-- Q.11 Group customers into age bands (under 25, 25 to 40, over 40) and find the total sales for each band.
WITH age_class
AS (
SELECT *,
	CASE
		WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 40 THEN '25 to 40'
        ELSE 'Above 40'
	END AS age_c
FROM retail_sales
)
SELECT 
	age_c,
    SUM(total_sale) AS total_sale_by_age
FROM age_class
GROUP BY age_c;

-- Q.12 Find the top 3 customers in each category by total spend
SELECT * FROM (
SELECT 
	customer_id,
    category,
    SUM(total_sale),
    RANK() OVER(
    PARTITION BY category 
		ORDER BY SUM(total_sale) DESC)
		AS rnk
FROM retail_sales
GROUP 
	BY 
	customer_id,
    category
) AS t2
WHERE rnk <= 3;

-- Q.13 Calculate the running total of sales across the whole year, ordered by date
SELECT 
	sale_date,
    SUM(total_sale) AS day_sales,
    SUM(SUM(total_sale)) OVER (ORDER BY sale_date) AS running_total
FROM retail_sales
GROUP 
	BY 
    sale_date
ORDER 
	BY 
    sale_date;
    
-- END OF PROJECT