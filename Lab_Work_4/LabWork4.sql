-- Create tables
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE,
    manager_id INTEGER,
    email VARCHAR(100)
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    budget NUMERIC(12,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);

CREATE TABLE assignments (
    assignment_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    project_id INTEGER REFERENCES projects(project_id),
    hours_worked NUMERIC(5,1),
    assignment_date DATE
);

-- Insert sample data
INSERT INTO employees (first_name, last_name, department, salary, hire_date, manager_id, email)
VALUES
    ('John', 'Smith', 'IT', 75000, '2020-01-15', NULL, 'john.smith@company.com'),
    ('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1, 'sarah.j@company.com'),
    ('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL, 'mbrown@company.com'),
    ('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL, 'emily.davis@company.com'),
    ('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
    ('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,'lisa.a@company.com');

INSERT INTO projects (project_name, budget, start_date, end_date, status)
VALUES
    ('Website Redesign', 150000, '2024-01-01', '2024-06-30','Active'),
    ('CRM Implementation', 200000, '2024-02-15', '2024-12-31','Active'),
    ('Marketing Campaign', 80000, '2024-03-01', '2024-05-31','Completed'),
    ('Database Migration', 120000, '2024-01-10', NULL, 'Active');

INSERT INTO assignments (employee_id, project_id, hours_worked, assignment_date)
VALUES
    (1, 1, 120.5, '2024-01-15'),
    (2, 1, 95.0, '2024-01-20'),
    (1, 4, 80.0, '2024-02-01'),
    (3, 3, 60.0, '2024-03-05'),
    (5, 2, 110.0, '2024-02-20'),
    (6, 3, 75.5, '2024-03-10');


--================== 1 ==================

SELECT (first_name || ' ' || last_name) AS full_name,
department, salary
FROM employees;

SELECT DISTINCT department
FROM employees;

SELECT projects.project_name, projects.budget,
       CASE
           WHEN projects.budget > 150000 THEN 'Large'
           WHEN projects.budget BETWEEN 100000 AND 150000 THEN 'Medium'
           ELSE 'Small'
END AS Budget_category
FROM projects;

SELECT
    (first_name || ' ' || last_name) AS full_name,
    COALESCE(employees.email,'No email provided') AS email
FROM employees;

--================== 2 ==================

SELECT *
FROM employees
WHERE hire_date > '2020-01-01';

SELECT *
FROM employees
WHERE salary BETWEEN 60000 AND 70000;

SELECT *
FROM employees
WHERE last_name LIKE 'S%' OR last_name LIKE 'J%';

SELECT *
FROM employees
WHERE manager_id IS NOT NULL AND department = 'IT';

--================== 3 ==================

SELECT upper((first_name || ' ' || last_name)) AS Uppercase_name,
       length(last_name) AS Lastname_Length,
       SUBSTRING(email FROM 1 FOR 3) AS Email_p
FROM employees;

SELECT (first_name || ' ' || last_name) AS full_name,
       employees.salary AS monthly,
       employees.salary * 12 AS Annual_salary,
       employees.salary * 0.10 AS Raise
FROM employees;

SELECT
    FORMAT('Project: %s - Budget: $%s - Status: %s', project_name, budget, status)
        AS project_details
FROM projects;

SELECT (first_name || ' ' || last_name) AS full_name,
       extract(YEAR FROM AGE(CURRENT_DATE, employees.hire_date)) AS years_with_company
FROM employees;

--================== 4 ==================

SELECT department, AVG(employees.salary) AS average_salary
FROM employees
GROUP BY department;

SELECT project_name, SUM(assignments.hours_worked) AS Total_Hours
FROM assignments
JOIN projects p on p.project_id = assignments.project_id
GROUP BY project_name;

SELECT COUNT(*) AS Employes_count
FROM employees
GROUP BY department
HAVING count(*) > 1;

SELECT MAX(employees.salary) AS Max_Salary,
       MIN(salary) AS Min_Salary,
       SUM(salary) AS Total_Salary
FROM employees;

--================== 5 ==================

SELECT employees.salary, employee_id, (employees.first_name || ' ' || employees.last_name) AS Full_Name
FROM employees
WHERE salary > 65000
UNION
SELECT  salary,employees.employee_id, (employees.first_name || ' ' || employees.last_name) AS Full_Name
FROM employees
WHERE hire_date < '2020-01-01';

SELECT department, salary, (first_name || ' ' || last_name) AS Full_Name
    FROM employees
WHERE department = 'IT'
INTERSECT
SELECT employees.department, employees.salary,
       (first_name || ' ' || last_name) AS Full_Name
FROM employees
WHERE salary > 65000;

SELECT employees.employee_id, (first_name || ' ' || last_name) AS Full_Name
FROM employees
EXCEPT
SELECT employees.employee_id, (first_name || ' ' || last_name) AS Full_Name
FROM employees
JOIN assignments ON employees.employee_id = assignments.employee_id;

--================== 6 ==================

SELECT employees.employee_id, (first_name || ' ' || last_name) AS Full_Name, department
FROM employees
WHERE EXISTS(
    SELECT 1
    FROM assignments
    WHERE assignment_id = employees.employee_id
);

SELECT employees.employee_id, (first_name || ' ' || last_name) AS Full_Name, department
FROM employees
WHERE employee_id IN (
    SELECT employee_id
    FROM assignments
    JOIN projects ON employee_id = assignment_id
    WHERE status = 'Active'
    );

SELECT employees.employee_id, (first_name || ' ' || last_name) AS Full_Name, department, employees.salary
FROM employees
WHERE salary > ANY(
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
    );

--================== 7 ==================

SELECT department,
       count(*) AS Total_Number,
       AVG(salary) AS Avarage_Salary,


FROM employees
GROUP BY department;

