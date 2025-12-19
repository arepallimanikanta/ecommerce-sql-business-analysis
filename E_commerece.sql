create database E_Commerce;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);
INSERT INTO customers VALUES
(1, 'Amit Sharma', 'amit@gmail.com', 'Delhi', '2023-01-10'),
(2, 'Priya Verma', 'priya@gmail.com', 'Mumbai', '2023-02-15'),
(3, 'Rahul Singh', 'rahul@gmail.com', 'Bangalore', '2023-03-05'),
(4, 'Sneha Reddy', 'sneha@gmail.com', 'Hyderabad', '2023-03-20'),
(5, 'Arjun Mehta', 'arjun@gmail.com', 'Pune', '2023-04-01'),
(6, 'Neha Gupta', 'neha@gmail.com', 'Chennai', '2023-04-18'),
(7, 'Vikram Rao', 'vikram@gmail.com', 'Bangalore', '2023-05-10'),
(8, 'Kavya Nair', 'kavya@gmail.com', 'Kochi', '2023-06-02');
select * from products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
INSERT INTO products VALUES
(101, 'iPhone 14', 'Electronics', 70000),
(102, 'Samsung TV', 'Electronics', 45000),
(103, 'Nike Shoes', 'Fashion', 6000),
(104, 'Levi Jeans', 'Fashion', 3500),
(105, 'Boat Headphones', 'Electronics', 2500),
(106, 'Kitchen Mixer', 'Home Appliances', 8000),
(107, 'Office Chair', 'Furniture', 12000),
(108, 'Smart Watch', 'Electronics', 15000);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    payment_method VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO orders VALUES
(1001, 1, '2023-06-01', 'Completed', 'Credit Card'),
(1002, 2, '2023-06-05', 'Completed', 'UPI'),
(1003, 3, '2023-06-10', 'Cancelled', 'Debit Card'),
(1004, 4, '2023-06-12', 'Completed', 'Net Banking'),
(1005, 5, '2023-06-18', 'Completed', 'UPI'),
(1006, 1, '2023-07-02', 'Completed', 'Credit Card'),
(1007, 6, '2023-07-05', 'Completed', 'UPI'),
(1008, 7, '2023-07-10', 'Returned', 'Debit Card'),
(1009, 8, '2023-07-12', 'Completed', 'Credit Card');
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO order_items VALUES
(1, 1001, 101, 1, 70000),
(2, 1001, 105, 2, 2500),
(3, 1002, 103, 1, 6000),
(4, 1002, 104, 1, 3500),
(5, 1003, 102, 1, 45000),
(6, 1004, 106, 1, 8000),
(7, 1005, 108, 1, 15000),
(8, 1006, 107, 1, 12000),
(9, 1007, 105, 1, 2500),
(10, 1008, 103, 2, 6000),
(11, 1009, 101, 1, 70000);
show tables;
select * from customers;
desc orders;
-- Total Revenue per Month
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.item_price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY month
ORDER BY month;

-- Top 5 Selling Products (by quantity)
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Revenue by Product Category
SELECT 
    p.category,
    SUM(oi.quantity * oi.item_price) AS category_revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Month-on-Month Sales Growth
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(oi.quantity * oi.item_price) AS revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY month
)
SELECT 
    month,
    revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS month_growth
FROM monthly_sales;


-- CUSTOMER ANALYSIS
-- Top 10 Customers by Revenue
SELECT 
    c.customer_id,
    c.name,
    SUM(oi.quantity * oi.item_price) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- Repeat vs New Customers

SELECT 
    CASE 
        WHEN COUNT(o.order_id) > 1 THEN 'Repeat Customer'
        ELSE 'New Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Customer Lifetime Value
SELECT 
    c.customer_id,
    c.name,
    SUM(oi.quantity * oi.item_price) AS lifetime_value
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC;

-- ORDER ANALYSIS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(CASE WHEN order_status = 'Cancelled' THEN 1 END) 
        * 100.0 / COUNT(*) AS cancellation_rate
FROM orders
GROUP BY month;
-- Most Used Payment Method
SELECT 
    payment_method,
    COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method
ORDER BY total_orders DESC;

-- Average Order Value
SELECT 
    SUM(oi.quantity * oi.item_price) 
        / COUNT(DISTINCT o.order_id) AS average_order_value
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

-- Products with Highest Return Count
SELECT 
    p.product_name,
    COUNT(r.return_id) AS total_returns
FROM returns r
JOIN orders o 
    ON r.order_id = o.order_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_returns DESC;


-- Return Reasons Analysis
SELECT 
    reason,
    COUNT(*) AS return_count
FROM returns
GROUP BY reason
ORDER BY return_count DESC;









