# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_sales` (MySQL 8.0+)

This project demonstrates the SQL skills data analysts use to clean, explore and analyze retail sales data. It covers setting up a database, cleaning the data, exploratory data analysis (EDA), and answering 13 business questions with SQL, from simple filters to CTEs and window functions.

## Objectives

1. **Set up a retail sales database**: Create a database and table, and load the provided sales data.
2. **Data Cleaning**: Identify and remove records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Get a basic understanding of the dataset (record count, unique customers, categories).
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Tech Used

- **Database**: MySQL 8.0+
- **Language**: SQL
- **Tool**: MySQL Workbench
- **Data Format**: CSV (`SQL_-_Retail_Sales_Analysis_utf_.csv`)
- **Version Control**: Git and GitHub

## Concepts Used

- **Database and table design**: `CREATE DATABASE`, `CREATE TABLE`, data types (`INT`, `DATE`, `TIME`, `VARCHAR`, `DECIMAL`), primary key
- **Data cleaning**: `IS NULL` checks, `DELETE ... WHERE`, handling blanks with `NULLIF`
- **Filtering and sorting**: `WHERE`, `AND` / `OR`, `ORDER BY`, `LIMIT`
- **Aggregate functions**: `COUNT`, `COUNT(DISTINCT ...)`, `SUM`, `AVG`, `ROUND`
- **Grouping**: `GROUP BY` on one or more columns, `HAVING`
- **Date and time functions**: `DATE_FORMAT`, `YEAR`, `MONTH`, `HOUR`
- **Conditional logic**: `CASE WHEN` for shifts and age bands
- **Common Table Expressions (CTEs)**: `WITH ... AS`
- **Subqueries**: filtering on a ranked inner query
- **Window functions**: `RANK() OVER (PARTITION BY ...)`, `SUM() OVER (ORDER BY ...)` for running totals

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales`.
- **Table Creation**: A table named `retail_sales` stores the sales data. Its columns are transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales;
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
    cogs DECIMAL(10, 2),
    total_sale DECIMAL(10, 2)
);
```

> The quantity column is named `quantiy` (as in the source file), so all queries use that spelling.

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify the unique product categories.
- **Null Value Check**: Check for null values and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT COUNT(DISTINCT category) FROM retail_sales;

SELECT * FROM retail_sales
WHERE
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR
    category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL OR
    cogs IS NULL OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR
    category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL OR
    cogs IS NULL OR total_sale IS NULL;
```

The source file has 2,000 rows. 13 of them had blank values (10 with a missing `age`, 3 with missing quantity, price, COGS and total), so **1,987 rows** remain after cleaning.

> **Import note:** MySQL Workbench's import wizard silently skips rows with blank cells in numeric columns. Loading the CSV into a text-only staging table first and converting blanks with `NULLIF(col, '')` keeps every row. Two rows in the CSV also use `DD-MM-YYYY` dates instead of `YYYY-MM-DD`, which should be converted so they load as valid dates.

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05'**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 or more in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    category,
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
GROUP BY category
HAVING category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT *
FROM (
    SELECT
        YEAR(sale_date) AS year_sale,
        MONTH(sale_date) AS month_sale,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY year_sale, month_sale
) AS t1
WHERE rnk = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Morning < 12, Afternoon between 12 & 17, Evening > 17)**:
```sql
WITH hourly_sales AS (
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
```

11. **Write a SQL query to group customers into age bands (under 25, 25 to 40, over 40) and find the total sales for each band.**:
```sql
WITH age_class AS (
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
```

12. **Write a SQL query to find the top 3 customers in each category by total spend.**:
```sql
SELECT *
FROM (
    SELECT
        customer_id,
        category,
        SUM(total_sale) AS total_spent,
        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY customer_id, category
) AS t2
WHERE rnk <= 3;
```

13. **Write a SQL query to calculate the running total of sales ordered by date.**:
```sql
SELECT
    sale_date,
    SUM(total_sale) AS day_sales,
    SUM(SUM(total_sale)) OVER (ORDER BY sale_date) AS running_total
FROM retail_sales
GROUP BY sale_date
ORDER BY sale_date;
```

## Findings

- **Dataset Size**: After cleaning, 1,987 transactions from 155 unique customers across three categories: Beauty, Clothing and Electronics. Total sales come to 908,230.
- **Category Performance**: Electronics leads in revenue (311,445), followed closely by Clothing (309,995) and Beauty (286,790). Clothing has the most orders (698), then Electronics (678) and Beauty (611).
- **Customer Demographics**: Female customers made 1,012 transactions and male customers 975. The average age of Beauty customers is 40.42.
- **Age Groups**: Customers over 40 generate the most revenue (450,745), then ages 25 to 40 (308,325), then under 25 (149,160).
- **High-Value Transactions**: 306 transactions had a total sale above 1000, indicating premium purchases.
- **Top Customers**: Customer 3 spends the most (38,440), followed by customers 1, 5, 2 and 4.
- **Shift Analysis**: Evening is by far the busiest shift (1,062 orders), ahead of Morning (548) and Afternoon (377).
- **Sales Trends**: The best month by average sale differs by year, for example August 2023, March 2024 and February 2025. 2022 and 2028 are partial years in the data.

## Reports

- **Sales Summary**: Total sales, order counts and category performance.
- **Customer Insights**: Top customers overall and per category, unique customers per category, and spend by age band.
- **Trend Analysis**: Best month per year, sales by shift, and a running total of sales over time.

## Conclusion

This project is an introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis and business-driven queries. The findings show which categories, customer groups and times of day drive sales, which can support decisions on stocking, promotions and staffing.

## How to Use

1. **Clone the Repository**: Clone or download this project from GitHub.
2. **Set Up the Database**: Create the database and table, then import `SQL_-_Retail_Sales_Analysis_utf_.csv` (see the import note above).
3. **Run the Queries**: Open `SQL_QUERY_PROJECT_1.sql` in MySQL Workbench and run the queries in order.
4. **Explore and Modify**: Change the queries to explore other questions about the data.

## Requirements

- MySQL 8.0 or later (CTEs and window functions are not available in earlier versions)
- MySQL Workbench (or any MySQL client)

## Author - Srajan Sharma

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions or feedback, feel free to get in touch!

- **LinkedIn**: [Add your profile link]
- **GitHub**: [Add your profile link]
