E-Commerce Business Analysis using MySQL

-- Project Overview

This project focuses on real-time E-Commerce Business Analysis using MySQL.
The goal is to design a relational database and use SQL queries to answer real business questions related to sales, customers, orders, and returns.
This project simulates how SQL is used in real companies for data-driven decision making.

--Tools & Technologies

Database: MySQL
Language: SQL

Concepts Used:
Joins
Group By & Having
Subqueries
Common Table Expressions (CTE)
Window Functions (LAG)
Date Functions

-- Database Schema

The project consists of the following tables:
customers – Stores customer details
products – Stores product information
orders – Stores order-level data
order_items – Stores product-level order details
returns – Stores returned order details

Primary and foreign keys are used to maintain data integrity.

-- Business Questions Answered
1.Sales Analysis
Total revenue per month
Top 5 selling products
Revenue by product category
Month-on-month sales growth

2. Customer Analysis
Top customers by revenue
Repeat vs new customers
Customer Lifetime Value (CLV)

3.Order Analysis
Cancellation rate by month
Most used payment method
Average Order Value (AOV)

4.Return Analysis
Products with highest return count
Analysis of return reasons



ecommerce-sql-business-analysis/
│
├── schema.sql        # CREATE TABLE statements
├── data.sql          # INSERT statements (sample data)
├── analysis.sql      # Business analysis SQL queries
└── README.md         # Project documentation

--Key Learnings

Designed a normalized relational database
Applied SQL to solve real business problems
Improved understanding of analytical SQL queries
Gained hands-on experience with advanced SQL concepts

Author

Venkata Manikanta
Aspiring Data Analyst | SQL | MySQL
Actively looking for entry-level Data Analyst / SQL Analyst opportunities.
