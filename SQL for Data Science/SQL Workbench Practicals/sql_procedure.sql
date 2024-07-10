CREATE DATABASE Company;
USE Company;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);

-- DROP TABLE IF EXISTS Employees;


INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, DepartmentID)
VALUES
(1, 'John', 'Doe', 60000, 101),
(2, 'Jane', 'Smith', 75000, 102),
(3, 'Jim', 'Brown', 50000, 103);

SELECT * FROM Employees;
DELIMITER //

CREATE PROCEDURE GetEmployeeDetails(IN EmpID INT)
BEGIN
    SELECT EmployeeID, FirstName, LastName, Salary, DepartmentID
    FROM Employees
    WHERE EmployeeID = EmpID;
END 

// DELIMITER ;

CALL GetEmployeeDetails(1);









CREATE TABLE Employees1 (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);

-- DROP TABLE IF EXISTS Employees1;


INSERT INTO Employees1 (EmployeeID, FirstName, LastName, Salary, DepartmentID)
VALUES
(1, 'John', 'Doe', 60000, 101),
(2, 'Jane', 'Smith', 75000, 102),
(3, 'Jim', 'Brown', 50000, 103),
(4, 'Jim', 'White', 50000, 102),
(5, 'Jim', 'John', 75000, 103);


-- DROP PROCEDURE GetTotalSalaryByDepartment;


DELIMITER //
# SUM(Salary): This calculates the total salary for employees in a specific department.
# INTO totalSalary: This part specifies that the result of the SUM(Salary) calculation should be stored in the variable totalSalary.

CREATE PROCEDURE GetTotalSalaryByDepartment(IN DeptID INT,OUT totalSalary INT)
BEGIN
	SELECT SUM(Salary) INTO totalSalary FROM Employees1 WHERE DepartmentID = DeptID;
END
// DELIMITER ;

# Declare a variable to hold the output and call the procedure.
SET @totalSalary = 0;

CALL GetTotalSalaryByDepartment(103,@totalSalary);

SELECT @totalSalary;

## THIS IS THE WORKING FOR OUT PARAMETER









### PROCEDURES USING CONTROL FLOW STATEMENT

CREATE TABLE Employees2 (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);

 -- DROP TABLE IF EXISTS Employees2;


INSERT INTO Employees2 (EmployeeID, FirstName, LastName, Salary, DepartmentID)
VALUES
(1, 'John', 'Doe', 60000, 101),
(2, 'Jane', 'Smith', 75000, 102),
(3, 'Jim', 'Brown', 50000, 103),
(4, 'Jim', 'White', 50000, 102),
(5, 'Jim', 'John', 75000, 103);

-- DROP PROCEDURE GiveRaise;

-- Create a procedure to give a raise to employees based on their performance rating.

DELIMITER //

CREATE PROCEDURE GiveRaise(IN empID INT, IN rating CHAR(1))
BEGIN
    IF rating = 'A' THEN
        UPDATE Employees2
        SET Salary = Salary * 1.10
        WHERE EmployeeID = empID;
    ELSEIF rating = 'B' THEN
        UPDATE Employees2
        SET Salary = Salary * 1.05
        WHERE EmployeeID = empID;
    ELSE
        UPDATE Employees2
        SET Salary = Salary * 1.02
        WHERE EmployeeID = empID;
    END IF;
END
// DELIMITER ;

CALL GiveRaise(2, 'A');
SELECT Salary FROM Employees2;

### PROCEDURES USING HANDLER ERROR HANDLING

CREATE TABLE Employees3 (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);

 -- DROP TABLE IF EXISTS Employees3;


INSERT INTO Employees3 (EmployeeID, FirstName, LastName, Salary, DepartmentID)
VALUES
(1, 'John', 'Doe', 60000, 101),
(2, 'Jane', 'Smith', 75000, 102),
(3, 'Jim', 'Brown', 50000, 103),
(4, 'Jim', 'White', 50000, 102),
(5, 'Jim', 'John', 75000, 103);

-- DROP PROCEDURE TransferEmployee;


DELIMITER //

CREATE PROCEDURE TransferEmployee(IN empID INT, IN newDeptID INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Employees3
    SET DepartmentID = newDeptID
    WHERE EmployeeID = empID;

    COMMIT;
END;

// DELIMITER ;


CALL TransferEmployee(3, 104);

SELECT * FROM Employees3;


