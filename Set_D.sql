/*
====================================================================
DEPARTMENT OF COMPUTER SCIENCE & ENGINEERING
B.Tech AIML — 3rd Semester | DBMS Lab Examination
SET D Solutions [Total: 20 Marks]
====================================================================
*/

-- =================================================================
-- PREREQUISITE TABLES (Referenced by Employees)
-- =================================================================
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);


-- =================================================================
-- QUESTION 1 [4 Marks]
-- Create the Employees(emp_id INT, emp_name VARCHAR(50), salary DECIMAL(10,2), 
-- dept_id INT, hire_date DATE) table with emp_id as Primary Key, 
-- dept_id as Foreign Key referencing Departments, and a constraint that 
-- salary cannot be NULL and must be greater than 15,000.
-- =================================================================

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10, 2) NOT NULL,
    dept_id INT,
    hire_date DATE,
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    CONSTRAINT chk_emp_salary CHECK (salary > 15000)
);


-- =================================================================
-- QUESTION 2 [3 Marks]
-- Find all employees who joined between January 1, 2024 and December 31, 2025, 
-- and whose names contain the substring 'an'.
-- =================================================================

SELECT *
FROM Employees
WHERE hire_date BETWEEN '2024-01-01' AND '2025-12-31'
  AND emp_name LIKE '%an%';


-- =================================================================
-- QUESTION 3 [4 Marks]
-- Write an SQL query using LEFT JOIN to list all departments and the names 
-- of employees working in them, including departments that currently 
-- have no assigned employees.
-- =================================================================

SELECT 
    d.dept_name,
    e.emp_name
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id;


-- =================================================================
-- QUESTION 4 [4 Marks]
-- Display the dept_name, maximum salary, and minimum salary for each 
-- department having more than 3 employees.
-- =================================================================

SELECT 
    d.dept_name,
    MAX(e.salary) AS max_salary,
    MIN(e.salary) AS min_salary
FROM Departments d
INNER JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING COUNT(e.emp_id) > 3;


-- =================================================================
-- QUESTION 5 [5 Marks]
-- Write a query using a correlated subquery to find the employee(s) 
-- who earn a salary strictly greater than the average salary of their 
-- respective department.
-- =================================================================

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.salary,
    e1.dept_id,
    e1.hire_date
FROM Employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.dept_id = e1.dept_id
);
