CREATE DATABASE Triggers;
USE Triggers;

-- DROP TABLE IF EXISTS Products;
-- DROP TABLE IF EXISTS inventory_log;
-- DROP DATABASE IF EXISTS TRIGGERS;

CREATE TABLE Products(
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    stock INT
);

CREATE TABLE inventory_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    change_type VARCHAR(50),
    change_amount INT,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Products (product_id, name, stock) VALUES (1,'Laptop',10);
INSERT INTO Products (product_id, name, stock) VALUES (2,'Monitor',8);

SELECT * FROM Products;

-- AFTER UPDATE
DELIMITER //

CREATE TRIGGER after_stock_update 
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    DECLARE change_amount INT;

    -- Calculate the change in stock
    SET change_amount = NEW.stock - OLD.stock;

    -- Insert into inventory_log table
    INSERT INTO inventory_log (product_id, change_type, change_amount)
    VALUES (NEW.product_id, 'Stock Change', change_amount);
END;
//

DELIMITER ;



-- Update the stock of Laptop from 10 to 15
UPDATE Products SET stock = 15 WHERE product_id = 1;

-- Update the stock of Monitor from 5 to 3
UPDATE Products SET stock = 3 WHERE product_id = 2;



SELECT * FROM Products;
SELECT * FROM inventory_log;

-- BEFORE UPDATE

DELIMITER //

CREATE TRIGGER before_stock_update 
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    DECLARE change_amount INT;

    -- Calculate the change in stock
    SET change_amount = NEW.stock - OLD.stock;

    -- Insert into inventory_log table
    INSERT INTO inventory_log (product_id, change_type, change_amount)
    VALUES (NEW.product_id, 'Stock Change', change_amount);
END;
//

DELIMITER ;
