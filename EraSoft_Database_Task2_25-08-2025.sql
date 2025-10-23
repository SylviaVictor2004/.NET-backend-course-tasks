-- EraSoft_Database_Task2_25-08-2025

CREATE Database Database_Task2_25082025;
GO

USE Database_Task2_25082025;
GO

CREATE SCHEMA EraTasks;
GO



-- 1.Create a table named "Employees" with columns for ID (integer), Name (varchar), and Salary (decimal).
CREATE TABLE EraTasks.Employees(
ID INT,
Name VARCHAR(30),
Salary DECIMAL (10,2)
);

-- 2.Add a new column named "Department" to the "Employees" table with data type varchar(50).
ALTER TABLE EraTasks.Employees
ADD Department VARCHAR(50);

-- 3.Remove the "Salary" column from the "Employees" table.
ALTER TABLE EraTasks.Employees
DROP COLUMN Salary;

-- 4. Rename the "Department" column in the "Employees" table to "DeptName".
EXEC sp_rename 'EraTasks.Employees.Department', 'DeptName', 'COLUMN';
GO

-- 5. Create a new table called "Projects" with columns for ProjectID (integer) and ProjectName (varchar).
CREATE TABLE EraTasks.Projects (
    ProjectID INT,
    ProjectName VARCHAR(100)
);
GO

-- 6. Add a primary key constraint to the "Employees" table for the "ID" column.
ALTER TABLE EraTasks.Employees
ALTER COLUMN ID INT NOT NULL;
GO

ALTER TABLE EraTasks.Employees
ADD CONSTRAINT PK_Employees PRIMARY KEY (ID);
GO

-- 7. Add a unique constraint to the "Name" column in the "Employees" table.
ALTER TABLE EraTasks.Employees
ADD CONSTRAINT UQ_Employees_Name UNIQUE (Name);
GO

-- 8. Create a table named "Customers" with columns for CustomerID (integer), FirstName (varchar), LastName (varchar), and Email (varchar), and Status (varchar).
CREATE TABLE EraTasks.Customers (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Status VARCHAR(20)
);
GO

-- 9. Add a unique constraint to the combination of "FirstName" and "LastName" columns in the "Customers" table.
ALTER TABLE EraTasks.Customers
ADD CONSTRAINT UQ_Customers_FullName UNIQUE (FirstName, LastName);
GO

-- 10. Create a table named "Orders" with columns for OrderID (integer), CustomerID (integer), OrderDate (datetime), and TotalAmount (decimal).
CREATE TABLE EraTasks.Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(12, 2)
);
GO

-- 11. Add a check constraint to the "TotalAmount" column in the "Orders" table to ensure that it is greater than zero.
ALTER TABLE EraTasks.Orders
ADD CONSTRAINT CHK_Orders_TotalAmount CHECK (TotalAmount > 0);
GO

-- 12. Create a schema named "Sales" and move the "Orders" table into this schema.
CREATE SCHEMA Sales;
GO

ALTER SCHEMA Sales
TRANSFER EraTasks.Orders;
GO

-- 13. Rename the "Orders" table to "SalesOrders."
EXEC sp_rename 'Sales.Orders', 'SalesOrders';
GO