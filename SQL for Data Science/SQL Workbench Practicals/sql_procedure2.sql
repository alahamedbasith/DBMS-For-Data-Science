## Error Handling in SQL Stored Procedures
-- 1.Error Handling with DECLARE HANDLER

CREATE DATABASE Error_Handling;
USE Error_Handling;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, DepartmentID)
VALUES
(1, 'John', 'Doe', 60000, 101),
(2, 'Jane', 'Smith', 75000, 102),
(3, 'Jim', 'Brown', 50000, 103);

DELIMITER //
CREATE PROCEDURE UpdateEmployeeSalary(
    IN empID INT, 
    IN newSalary DECIMAL(10, 2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'An error occurred while updating the salary.' AS ErrorMessage;
    END;

    START TRANSACTION;
    
    UPDATE Employees
    SET Salary = newSalary
    WHERE EmployeeID = empID;
    
    COMMIT;
END;
// DELIMITER ;

CALL UpdateEmployeeSalary(1, 65000);

SELECT * FROM Employees;

-- 2.Error Handling with DECLARE CONTINUE HANDLER

DELIMITER //

CREATE PROCEDURE IncreaseAllSalaries(
    IN percentageIncrease DECIMAL(5, 2)
)
BEGIN
    DECLARE empID INT DEFAULT 1;
    DECLARE maxEmpID INT;

    -- Declare the error handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log the error or take other actions
        SELECT 'An error occurred while updating the salary for an employee.' AS ErrorMessage;
    END;

    -- Find the maximum EmployeeID
    SELECT MAX(EmployeeID) INTO maxEmpID FROM Employees;

    raise_loop: LOOP
        IF empID > maxEmpID THEN
            LEAVE raise_loop;
        END IF;

        -- Update salary
        UPDATE Employees
        SET Salary = Salary * (1 + percentageIncrease / 100)
        WHERE EmployeeID = empID;

        -- Move to the next employee
        SET empID = empID + 1;
    END LOOP raise_loop;
END$$

DELIMITER ;

-- Call the procedure
CALL IncreaseAllSalaries(5);

SELECT * FROM Employees;

-- 3.Raising Custom Errors with SIGNAL

DELIMITER //
CREATE PROCEDURE SetEmployeeSalary(
    IN empID INT, 
    IN newSalary DECIMAL(10, 2)
)
BEGIN
    IF newSalary < 30000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary must be at least 30000.';
    ELSE
        UPDATE Employees
        SET Salary = newSalary
        WHERE EmployeeID = empID;
    END IF;
END;

// DELIMITER ;

CALL SetEmployeeSalary(2, 25000); -- This will raise a custom error
CALL SetEmployeeSalary(2, 35000);

SELECT * FROM Employees; 

-- 4. Using EXIT HANDLER for Cleanup

DELIMITER //
CREATE PROCEDURE TransferEmployee(
    IN empID INT, 
    IN newDeptID INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        -- Additional cleanup actions can be performed here
        SELECT 'An error occurred during the transfer. The transaction has been rolled back.' AS ErrorMessage;
    END;

    START TRANSACTION;
    
    UPDATE Employees
    SET DepartmentID = newDeptID
    WHERE EmployeeID = empID;
    
    COMMIT;
END;
// DELIMITER ;

CALL TransferEmployee(3, 400);

SELECT * FROM Employees;