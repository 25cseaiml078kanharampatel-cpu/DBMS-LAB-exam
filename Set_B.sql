/*
====================================================================
DEPARTMENT OF COMPUTER SCIENCE & ENGINEERING
B.Tech AIML — 3rd Semester | DBMS Lab Examination
SET B Solutions [Total: 20 Marks]
====================================================================
*/

-- =================================================================
-- PREREQUISITE TABLES (Referenced by Orders & Order Details)
-- =================================================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2)
);


-- =================================================================
-- QUESTION 1 [4 Marks]
-- Write SQL DDL statements to create the Orders(order_id INT, customer_id INT, 
-- order_date DATE, total_amount DECIMAL(10,2)) table with order_id as Primary Key, 
-- customer_id as Foreign Key with ON DELETE CASCADE, and a default value 
-- of the current date for order_date.
-- =================================================================

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    total_amount DECIMAL(10, 2),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) 
        REFERENCES Customers(customer_id) 
        ON DELETE CASCADE
);

-- Note: For Question 3, standard schema includes an Order_Items table:
CREATE TABLE Order_Items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


-- =================================================================
-- QUESTION 2 [3 Marks]
-- List all distinct cities where customers have placed orders 
-- with a total_amount exceeding 5,000.
-- =================================================================

SELECT DISTINCT c.city
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 5000;


-- =================================================================
-- QUESTION 3 [4 Marks]
-- Display customer_name, product_name, and quantity for all orders 
-- placed in the year 2026 using appropriate table joins.
-- =================================================================

SELECT 
    c.customer_name,
    p.product_name,
    oi.quantity
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2026;
-- Alternative syntax for MySQL:
-- WHERE YEAR(o.order_date) = 2026;
-- Or date range check:
-- WHERE o.order_date BETWEEN '2026-01-01' AND '2026-12-31';


-- =================================================================
-- QUESTION 4 [4 Marks]
-- Write a query to display each customer_id, customer name, and their 
-- total spending (SUM(total_amount)), including only customers who have 
-- placed 2 or more orders.
-- =================================================================

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spending
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;


-- =================================================================
-- QUESTION 5 [5 Marks]
-- Retrieve the details of customers who have never placed any order 
-- using a nested subquery (NOT EXISTS or NOT IN).
-- =================================================================

-- Approach 1: Using NOT IN
SELECT *
FROM Customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM Orders
    WHERE customer_id IS NOT NULL
);

-- Approach 2: Using NOT EXISTS
SELECT *
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
