# Retail Sales Analysis using SQL

## Project Overview
This project focuses on analyzing retail sales data using **MySQL** to identify sales trends, customer purchasing behavior, product category performance, and business insights.

The project involves creating a retail sales database, performing data cleaning, and writing SQL queries to answer important business questions.

## Objectives
- Analyze overall retail sales performance.
- Identify top-performing product categories.
- Understand customer purchasing patterns.
- Analyze monthly sales trends.
- Identify high-value customers.
- Calculate running sales totals.
- Understand sales distribution across different age groups and time shifts.

## Tools & Technologies
- **Database:** MySQL
- **Language:** SQL
- **Concepts Used:**
  - SELECT, WHERE, ORDER BY
  - GROUP BY and HAVING
  - Aggregate Functions (SUM, AVG, COUNT)
  - Joins (where applicable)
  - Common Table Expressions (CTEs)
  - CASE Statements
  - Window Functions (RANK, SUM OVER)
  - Data Cleaning

## Database Structure

**Table Name:** `retail_sales`

| Column Name | Data Type |
|---|---|
| transactions_id | INT (Primary Key) |
| sale_date | DATE |
| sale_time | TIME |
| customer_id | INT |
| gender | VARCHAR(10) |
| age | INT |
| category | VARCHAR(100) |
| quantiy | INT |
| price_per_unit | DECIMAL(10,2) |
| cogs | DECIMAL(10,2) |
| total_sale | DECIMAL(10,2) |

## Data Cleaning

Performed the following data-cleaning operations:

- Checked for NULL values across all columns.
- Identified records containing missing values.
- Removed records with NULL values to maintain data consistency.
- Checked the number of unique customers.
- Identified the number of unique product categories.

## Business Questions & SQL Analysis

The project answers the following 13 business questions:

1. Retrieve all sales transactions made on November 5, 2022.
2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
3. Calculate total sales and number of orders for each product category.
4. Find the average age of customers purchasing products from the Beauty category.
5. Identify transactions where total sales exceed 1000.
6. Find the number of transactions by gender in each product category.
7. Calculate average monthly sales and identify the best-selling month in each year.
8. Find the top 5 customers based on total sales.
9. Calculate the number of unique customers purchasing from each category.
10. Categorize orders into Morning, Afternoon, and Evening shifts.
11. Group customers into age bands and calculate total sales for each group.
12. Identify the top 3 customers in each product category based on total spending.
13. Calculate the running total of sales ordered by date using SQL window functions.

## SQL Concepts Demonstrated

This project demonstrates practical applications of:

- Data retrieval and filtering
- Data aggregation and grouping
- Date and time functions
- Conditional logic using CASE
- CTEs for structured queries
- Ranking using RANK()
- Running totals using window functions
- Business-oriented data analysis

## Key Learnings

Through this project, I gained practical experience in:

- Designing and working with relational databases.
- Cleaning and preparing data for analysis.
- Writing SQL queries to solve real-world business problems.
- Using aggregate and window functions for analytical tasks.
- Converting business requirements into SQL queries.

## Project Structure

```text
Retail-Sales-Analysis/
│
├── SQL-RETAIL Sales Analysis_utf.csv
├── SQL_QUERY_PROJECT_!.sql
└── README.md
```

## Conclusion

This project helped me strengthen my SQL skills and understand how databases can be used to analyze retail business performance.

It provided hands-on experience in data cleaning, aggregation, customer segmentation, sales analysis, and analytical SQL queries.

---

**Author:** Srajan Sharma

**Project:** Retail Sales Analysis using SQL
