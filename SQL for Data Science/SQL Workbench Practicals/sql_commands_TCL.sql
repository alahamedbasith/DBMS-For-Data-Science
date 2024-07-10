-- Transactional Control Language

-- COMMIT - The COMMIT command is used to save all changes made during the current transaction.
-- ROLLBACK - The ROLLBACK command is used to undo all changes made during the current transaction.
-- SAVEPOINT - The SAVEPOINT command is used to set a point within a transaction to which you can later roll back.

# Create database
create database info;
use info;

# Create the table
create table Workers (
    employeeID int primary key,
    firstname varchar(50),
    lastname varchar(50),
    Dob date
);

-- Start a new transaction
START TRANSACTION;

-- Insert some data
INSERT INTO Workers (employeeID, firstname, lastname, Dob) VALUES (1, 'John', 'Doe', '1980-01-01');

-- Set a savepoint
SAVEPOINT savepoint1;

-- Insert more data
INSERT INTO Workers (employeeID, firstname, lastname, Dob) VALUES (2, 'Jane', 'Smith', '1990-02-02');

-- Insert another row
INSERT INTO Workers (employeeID, firstname, lastname, Dob) VALUES (3, 'Alice', 'Johnson', '1985-03-03');

select * from Workers;

-- Rollback to the savepoint
ROLLBACK TO savepoint1;

select * from Workers;

-- Insert a different row after rollback
INSERT INTO Workers (employeeID, firstname, lastname, Dob) VALUES (4, 'Bob', 'Brown', '1975-04-04');

select * from Workers;

-- Commit the transaction
COMMIT;

select * from Workers;

-- REAL TIME EXAMPLE
## Let's consider a real-world scenario where a transaction involving multiple steps needs to be completed as an atomic unit. 
## Suppose we have a simple e-commerce system with two tables: orders and inventory. 
## When a customer places an order, the system should insert a record into the orders table and update the inventory table to reflect the decrease in stock. 
## If either of these operations fails, the transaction should be rolled back to maintain data integrity.

-- Create a new database named 'ecommerce'
CREATE DATABASE ecommerce;

-- Select the database
USE ecommerce;

-- Create the inventory table
CREATE TABLE inventory (
    productID INT PRIMARY KEY,
    productName VARCHAR(50),
    stock INT
);

-- Create the orders table
CREATE TABLE orders (
    orderID INT PRIMARY KEY AUTO_INCREMENT,
    productID INT,
    quantity INT,
    orderDate DATE,
    FOREIGN KEY (productID) REFERENCES inventory(productID)
);


-- Insert sample data into inventory
INSERT INTO inventory (productID, productName, stock) VALUES (1, 'Laptop', 10),(2, 'Smartphone', 20);



-- Start a new transaction
START TRANSACTION;

-- Insert a new order
INSERT INTO orders (productID, quantity, orderDate) VALUES (1, 2, CURDATE());

-- Check if there is enough stock before updating inventory

-- Set @current_stock
SELECT @current_stock := stock FROM inventory WHERE productID = 1 FOR UPDATE;

-- Check stock level and perform actions accordingly
IF @current_stock >= 2 THEN
    -- Update the inventory to decrease stock
    UPDATE inventory SET stock = stock - 2 WHERE productID = 1;
    
    -- Commit the transaction
    COMMIT;
ELSE
    -- Rollback the transaction if there is not enough stock
    ROLLBACK;
END IF;


-- IF,ELSE not work means update mysql server 
