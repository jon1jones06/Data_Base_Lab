-- =================== PART_A ===================

CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INT,
    manager_id INT
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    start_date DATE,
    end_date DATE,
    budget INT
);

-- =================== PART_B ===================

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (1,'ALI','AL','IT');

INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('JON', 'JONI','IT', DEFAULT, DEFAULT);

INSERT INTO departments (dept_name, budget, manager_id)
VALUES
    ('IT',1000000,1),
    ('IT',500000,2),
    ('IT',100000,3);

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('JONNI','JONNII','IT',50000 * 1.1,CURRENT_DATE);

CREATE TABLE temp_employees (
    emp_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50)
);

INSERT INTO temp_employees (emp_id, first_name, last_name, department)
SELECT employees.emp_id,employees.first_name,employees.last_name,employees.department
FROM employees WHERE department = 'IT';

-- =================== PART_C ===================

UPDATE employees
SET salary = salary * 1.10;

UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

UPDATE departments d
SET budget = (
    SELECT AVG(salary) * 1.20
    FROM employees e
    WHERE e.department = d.dept_name
)
WHERE EXISTS(
    SELECT 1
    FROM employees e
    WHERE e.department = d.dept_name
);

UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

-- =================== PART_D ===================

DELETE FROM employees
WHERE status = 'Terminated';

DELETE FROM employees
WHERE salary < 40000
    AND hire_date > '2023-01-01'
    AND department IS NULL;

DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT employees.department
    FROM employees
    WHERE department IS NULL
);

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

-- =================== PART_E ===================

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('KIM','INN',NULL,NULL,CURRENT_DATE);

UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

-- =================== PART_F ===================

INSERT INTO employees(first_name, last_name, department, salary, hire_date)
VALUES('SAKE', 'MAKE', 'IT', 10000000, CURRENT_DATE)
RETURNING emp_id, first_name || ' ' || last_name AS full_name;

UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;

DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

-- =================== PART_G ===================

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'DAKE', 'MURKA', 'IT', 1000000, CURRENT_DATE
WHERE NOT EXISTS(
    SELECT 1 FROM employees WHERE first_name = 'DAKE' AND last_name = 'MURKA'
);

UPDATE employees e
SET salary = CASE
    WHEN(SELECT budget FROM departments d WHERE d.dept_name = e.department ) > 100000
THEN salary * 1.10
ELSE salary * 1.05
END
WHERE department IS NOT NULL;

INSERT INTO employees(first_name, last_name, department, salary, hire_date)
VALUES (
        ('MBAPPE', 'KILIAN', 'IT', 50000, CURRENT_DATE),
        ('RONALDO', 'CRISTIANO', 'IT',50000,CURRENT_DATE),
        ('SON', 'MIN','IT', 50000, CURRENT_DATE),
        ('KANE', 'HARRY', 'IT', 50000, CURRENT_DATE),
        ('TOTTI', 'FRANCESCO', 'IT', 50000, CURRENT_DATE)
       );

UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT' AND salary <= 50000;

CREATE TABLE employee_archive(
    emp_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE,
    status VARCHAR(20)
);

INSERT INTO employee_archive
SELECT FROM employees WHERE status = 'Inactive';

DELETE FROM employees WHERE status = 'Inactive';

UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
AND dept_id IN(
    SELECT dept_id
    FROM departments
    JOIN employees ON dept_name = department
    GROUP BY dept_id
    HAVING count(emp_id) > 3
    );
