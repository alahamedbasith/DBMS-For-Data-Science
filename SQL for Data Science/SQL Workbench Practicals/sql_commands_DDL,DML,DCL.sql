create database info;
use info;

-- 2.SQL Commands

-- Data Definition Language (DDL)

-- CREATE
create table employees(
employeeID int primary key,
firstname varchar(50),
lastname varchar(50),
Dob date
);

-- ALTER
alter table employees add email varchar(100);

-- DROP
drop table employees;

DESCRIBE employees;


-- Data Manipulation Language (DML)

-- INSERT
insert into employees(employeeID,firstname,lastname,Dob) values (1,'John','Doe','2003-04-29');
insert into employees(employeeID,firstname,lastname,Dob) values (2,'ken','Paul','2004-04-29');

-- SELECT
DESCRIBE employees;
select firstname, lastname from employees where employeeID = 1;
select firstname, lastname from employees where employeeID = 2;

-- UPDATE
update employees set email="ahamedbasith006@gmail.com" where employeeID = 1;
select * from employees;

-- DELETE
delete from employees where employeeID = 1;
select * from employees;


-- Data Control Language (DCL)

-- GRANT
CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'password123';
GRANT SELECT ON info.employees TO 'test_user'@'localhost';
FLUSH PRIVILEGES;

GRANT UPDATE ON info.employees TO 'test_user'@'localhost';
FLUSH PRIVILEGES;

-- REVOKE 
REVOKE UPDATE ON info.employees from 'test_user'@'localhost';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'test_user'@'localhost';

-- GRANT and REVOKE uses verify by coommand prompt:
-- 1. Type the command 'mysql -u test_user -p' in the command prompt
-- 2. Then type select query to check all the data are retrieved
-- 3. After that apply grant and revoke like above to see the difference
-- 4.Verify the Granted Privileges using 'SHOW GRANTS FOR 'test_user'@'localhost';



