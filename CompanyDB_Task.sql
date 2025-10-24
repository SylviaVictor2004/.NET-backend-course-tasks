-- 1. Create a new database named "CompanyDB"
CREATE DATABASE CompanyDB;
GO

-- Switch to the new database
USE CompanyDB;
GO

-- 2. Create a schema named "Sales"
CREATE SCHEMA Sales;
GO

-- 3. Create the sequence (the "counter") first
--  Create the "employees" table within the "Sales" schema
CREATE SEQUENCE Sales.EmployeeID_Sequence
    AS INT
    START WITH 1
    INCREMENT BY 1;
GO

CREATE TABLE Sales.employees (
    employee_id INT PRIMARY KEY DEFAULT (NEXT VALUE FOR Sales.EmployeeID_Sequence),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    salary DECIMAL(10, 2)
);
GO

-- 4. Alter the "employees" table to add a new column named "hire_date" with the data type DATE.
ALTER TABLE Sales.employees
ADD hire_date DATE;
GO

-- 5. Add mock data to this table using Mockaroo.


--DATA MANIPULATION Exercises:
-- 1. Select all columns
SELECT * FROM Sales.employees;

-- 2. Retrieve only "first_name" and "last_name"
SELECT first_name, last_name FROM Sales.employees;

-- 3. Retrieve "full name" as one column
SELECT (first_name + ' ' + last_name) AS full_name
FROM Sales.employees;

-- 4. Show the average salary of all employees (Use AVG() function)
SELECT AVG(salary) AS average_salary FROM Sales.employees;

-- 5. Select employees whose salary is greater than 50000
SELECT * FROM Sales.employees WHERE salary > 50000;

-- 6. Retrieve employees hired in the year 2020
SELECT * FROM Sales.employees WHERE YEAR(hire_date) = 2020;

-- 7. List employees whose last names start with 'S'
SELECT * FROM Sales.employees WHERE last_name LIKE 'S%';

-- 8. Display the top 10 highest-paid employees
SELECT TOP 10 *
FROM Sales.employees
ORDER BY salary DESC;

-- 9. Find employees with salaries between 40000 and 60000
SELECT * FROM Sales.employees WHERE salary BETWEEN 40000 AND 60000;

-- 10. Show employees with names containing the substring 'man'
SELECT * FROM Sales.employees
WHERE first_name LIKE '%man%' OR last_name LIKE '%man%';

-- 11. Display employees with a NULL value in the "hire_date" column
SELECT * FROM Sales.employees WHERE hire_date IS NULL;

-- 12. Select employees with a salary in the set (40000, 45000, 50000)
SELECT * FROM Sales.employees WHERE salary IN (40000, 45000, 50000);

-- 13. Retrieve employees hired between '2020-01-01' and '2021-01-01'
SELECT * FROM Sales.employees
WHERE hire_date >= '2020-01-01' AND hire_date <= '2021-01-01';

-- 14. List employees with salaries in descending order
SELECT * FROM Sales.employees ORDER BY salary DESC;

-- 15. Show the first 5 employees ordered by "last_name" in ascending order
SELECT TOP 5 *
FROM Sales.employees
ORDER BY last_name ASC;

-- 16. Display employees with a salary > 55000 and hired in 2020
SELECT * FROM Sales.employees
WHERE salary > 55000 AND YEAR(hire_date) = 2020;

-- 17. Select employees whose first name is 'John' or 'Jane'
SELECT * FROM Sales.employees WHERE first_name IN ('John', 'Jane');

-- 18. List employees with a salary <= 55000 and a hire date after '2022-01-01'
SELECT * FROM Sales.employees
WHERE salary <= 55000 AND hire_date > '2022-01-01';

-- 19. Retrieve employees with a salary greater than the average salary
SELECT * FROM Sales.employees
WHERE salary > (SELECT AVG(salary) FROM Sales.employees);

-- 20. Display the 3rd to 7th highest-paid employees
SELECT *
FROM Sales.employees
ORDER BY salary DESC
OFFSET 2 ROWS 
FETCH NEXT 5 ROWS ONLY;

-- 21. List employees hired after '2021-01-01' in alphabetical order
SELECT * FROM Sales.employees
WHERE hire_date > '2021-01-01'
ORDER BY first_name, last_name;

-- 22. Retrieve employees with a salary > 50000 and last name not starting with 'A'
SELECT * FROM Sales.employees
WHERE salary > 50000 AND last_name NOT LIKE 'A%';

-- 23. Display employees with a salary that is not NULL
SELECT * FROM Sales.employees WHERE salary IS NOT NULL;

-- 24. Show employees with names containing 'e' or 'i' and a salary > 45000
SELECT * FROM Sales.employees
WHERE (first_name LIKE '%e%' OR first_name LIKE '%i%' OR last_name LIKE '%e%' OR last_name LIKE '%i%')
  AND salary > 45000;

 
 
 --JOIN-RELATED EXERCISES

  -- 25. Create a new table named "departments"
CREATE TABLE Sales.departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    manager_id INT,
    CONSTRAINT FK_Manager FOREIGN KEY (manager_id) REFERENCES Sales.employees(employee_id)
);
GO

-- 26. Add "department_id" column to "employees" table
ALTER TABLE Sales.employees
ADD department_id INT;
GO

-- Add the foreign key constraint to link employees to departments
ALTER TABLE Sales.employees
ADD CONSTRAINT FK_Department FOREIGN KEY (department_id) REFERENCES Sales.departments(department_id);
GO


--NOTE: Before running INSERT some data into Sales.departments
-- INSERT data into Sales.departments
INSERT INTO Sales.departments (department_id, department_name)
VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'HR');
GO

-- . UPDATE employees to assign them to departments

-- Assign employees with ID 1 to 25 to Engineering (ID 1)
UPDATE Sales.employees
SET department_id = 1
WHERE employee_id BETWEEN 1 AND 25;

-- Assign employees with ID 26 to 50 to Sales (ID 2)
UPDATE Sales.employees
SET department_id = 2
WHERE employee_id BETWEEN 26 AND 50;

-- Assign employees with ID 51 to 75 to Marketing (ID 3)
UPDATE Sales.employees
SET department_id = 3
WHERE employee_id BETWEEN 51 AND 75;

-- Assign employees with ID 76 to 100 to HR (ID 4)
UPDATE Sales.employees
SET department_id = 4
WHERE employee_id BETWEEN 76 AND 100;
GO


-- 27. Retrieve all employees with their department names (INNER JOIN)
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    Sales.employees AS e
INNER JOIN
    Sales.departments AS d ON e.department_id = d.department_id;

-- 28. Retrieve employees who don’t belong to any department (LEFT JOIN)
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    Sales.employees AS e
LEFT JOIN
    Sales.departments AS d ON e.department_id = d.department_id
WHERE
    d.department_name IS NULL;

-- 29. Show all departments and their employee count
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM
    Sales.departments AS d
LEFT JOIN -- Use LEFT JOIN to show departments with 0 employees
    Sales.employees AS e ON d.department_id = e.department_id
GROUP BY
    d.department_name;

-- 30. Retrieve the highest-paid employee in each department
WITH RankedEmployees AS (
    SELECT
        e.first_name,
        e.last_name,
        e.salary,
        d.department_name,
        -- This gives a rank (1, 2, 3...) to employees in each department based on salary
        ROW_NUMBER() OVER(PARTITION BY d.department_name ORDER BY e.salary DESC) AS rn
    FROM
        Sales.employees AS e
    INNER JOIN
        Sales.departments AS d ON e.department_id = d.department_id
)
SELECT
    department_name,
    first_name,
    last_name,
    salary
FROM
    RankedEmployees
WHERE
    rn = 1;