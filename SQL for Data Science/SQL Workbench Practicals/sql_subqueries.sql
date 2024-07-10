
CREATE DATABASE RETAIL;
USE RETAIL;
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create OrderItems table
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(255),
    price DECIMAL(10, 2)
);

-- Insert data into Customers
INSERT INTO Customers (customer_id, customer_name, email, city) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'New York'),
(2, 'Bob Smith', 'bob@example.com', 'Los Angeles'),
(3, 'Charlie Davis', 'charlie@example.com', 'Chicago'),
(4, 'Diana Evans', 'diana@example.com', 'Houston'),
(5, 'Edward Harris', 'edward@example.com', 'Phoenix');

-- Insert data into Products
INSERT INTO Products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 1000.00),
(2, 'Headphones', 'Electronics', 200.00),
(3, 'Book', 'Books', 15.00),
(4, 'Smartphone', 'Electronics', 800.00),
(5, 'Novel', 'Books', 20.00),
(6, 'Tablet', 'Electronics', 400.00),
(7, 'Biography', 'Books', 25.00);

-- Insert data into Orders
INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-01-10', 1015.00),
(2, 2, '2024-02-15', 1200.00),
(3, 3, '2024-03-20', 815.00),
(4, 4, '2024-04-25', 405.00),
(5, 5, '2024-05-30', 1020.00);

-- Insert data into OrderItems
INSERT INTO OrderItems (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1, 1000.00),
(2, 1, 3, 1, 15.00),
(3, 2, 2, 2, 200.00),
(4, 2, 4, 1, 800.00),
(5, 3, 4, 1, 800.00),
(6, 3, 3, 1, 15.00),
(7, 4, 6, 1, 400.00),
(8, 4, 5, 1, 20.00),
(9, 5, 1, 1, 1000.00),
(10, 5, 7, 1, 20.00);

-- Example 1: Find Customers Who Placed Orders Worth More Than the Average Order Amount

SELECT customer_id,customer_name FROM Customers WHERE customer_id IN (SELECT customer_id FROM Orders GROUP BY customer_id HAVING SUM(total_amount) > (SELECT AVG(total_amount) FROM ORDERS));

-- Example 2: Find Products That Have Never Been Ordered

SELECT product_id,product_name FROM Products WHERE Products.product_id NOT IN (SELECT product_id FROM OrderItems);

SELECT product_id, product_name
FROM Products
WHERE product_id NOT IN (
  SELECT DISTINCT product_id
  FROM OrderItems
);
# The above both queries are correct

-- Example 3: List Customers Who Have Ordered Products in the "Electronics" Category

SELECT customer_id,customer_name FROM Customers WHERE customer_id IN (SELECT category FROM Products WHERE category = "Electronics");  # This query comes in mind but this wrong
SELECT category FROM Products WHERE category = "Electronics"; # This is wrong run and identify

## Define Properly
# Method 01

SELECT customer_id, customer_name
FROM Customers
WHERE customer_id IN (
  SELECT customer_id
  FROM Orders 
  WHERE order_id IN (
    SELECT order_id
    FROM OrderItems 
    WHERE product_id IN (
      SELECT product_id
      FROM Products 
      WHERE category = 'Electronics'
    )
  )
);

# Method 2

SELECT customer_id, customer_name
FROM Customers
WHERE customer_id IN (
  SELECT DISTINCT o.customer_id
  FROM Orders o
  JOIN OrderItems oi ON o.order_id = oi.order_id
  JOIN Products p ON oi.product_id = p.product_id
  WHERE p.category = 'Electronics'
);

-- Example 4: Get the Top 5 Customers by Order Value

SELECT customer_id, customer_name, total_spent
FROM (
  SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
  FROM Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.customer_name
  ORDER BY total_spent DESC
) AS customer_totals
LIMIT 5;
## Every derived table must have its own alias otherwise error occurs

-- Example 5: Find Orders Where All Items Are from the "Books" Category
-- SELECT 1 FROM TABLE" is a simple way to check if there are any rows in the specified MySQL table. It doesn't retrieve any data from the table but rather returns a result set with a single column containing the value 1 for each row that satisfies the conditions in the WHERE clause (if any).

SELECT order_id
FROM Orders o
WHERE NOT EXISTS (
  SELECT 1
  FROM OrderItems oi
  JOIN Products p ON oi.product_id = p.product_id
  WHERE oi.order_id = o.order_id AND p.category != 'Books'
);

-- Example 6: Get the Average Order Value by City

SELECT city, AVG(order_value) AS avg_order_value
FROM (
  SELECT c.city, o.order_id, o.total_amount AS order_value
  FROM Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
) AS city_orders
GROUP BY city;

-- Example 7: Find Customers Who Have Ordered More Than 5 Different Products

SELECT customer_id, customer_name
FROM Customers
WHERE customer_id IN (
  SELECT customer_id
  FROM Orders o
  JOIN OrderItems oi ON o.order_id = oi.order_id
  GROUP BY customer_id
  HAVING COUNT(DISTINCT product_id) > 5
);

-- Example 8: List the Most Frequently Ordered Product in Each Category

## COUNT FUNCTION
SELECT COUNT(*) AS total_customers
FROM Customers;


SELECT category, product_id, product_name, order_count
FROM (
  SELECT p.category, p.product_id, p.product_name, COUNT(*) AS order_count,
         RANK() OVER (PARTITION BY p.category ORDER BY COUNT(*) DESC) AS r
  FROM OrderItems oi
  JOIN Products p ON oi.product_id = p.product_id
  GROUP BY p.category, p.product_id, p.product_name
) AS ranked_products
WHERE r = 1;

