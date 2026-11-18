-- Create tables
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE projects (
    proj_id INT PRIMARY KEY,
    proj_name VARCHAR(100),
    budget DECIMAL(12,2),
    dept_id INT,
FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);-- Insert sample data
INSERT INTO departments VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Operations', 'Building C');
INSERT INTO employees VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 101, 55000),
(3, 'Mike Johnson', 102, 48000),
(4, 'Sarah Williams', 102, 52000),
(5, 'Tom Brown', 103, 60000);
INSERT INTO projects VALUES
(201, 'Website Redesign', 75000, 101),
(202, 'Database Migration', 120000, 101),
(203, 'HR System Upgrade', 50000, 102);

--===============================================================
--Part 2
--2.1
create index emp_salary_idx on employees(salary);

select indexname, indexdef
from pg_indexes
where tablename = 'employees';
-- 2 index

--2.2
create index emp_dept_idx on employees(dept_id);

select * from employees where dept_id = 101;

-- Because foreign keys are frequently used in JOIN operations to connect tables,
-- indexing them speeds up data retrieval and makes queries, updates, and deletions in the parent table much faster
EXPLAIN ANALYZE SELECT * FROM employees WHERE dept_id = 101;

--2.3
select
    tablename,
    pg_indexes.indexname,
    pg_indexes.indexdef
from pg_indexes
where schemaname = 'public'
order by tablename, indexname;
-- All indexes found (12 total):
-- 1. assignments_pkey
-- 2. categories_pkey
-- 3. departments_pkey
-- 4. developers_pkey
-- 5. emp_dept_idx
-- 6. emp_salary_idx
-- 7. employees_pkey
-- 8. faculties_pkey
-- 9. projects_pkey
-- 10. sales_pkey
-- 11. students_pkey
-- 12. tasks_pkey

-- Automatically created indexes:
-- All indexes ending with '_pkey' (assignments_pkey, categories_pkey, departments_pkey,
-- developers_pkey, employees_pkey, faculties_pkey, projects_pkey, sales_pkey, students_pkey, tasks_pkey)
-- were created automatically by PostgreSQL for PRIMARY KEY constraints
-- (Hint: PRIMARY KEY creates an automatic index)
-- (Note: emp_dept_idx and emp_salary_idx were created manually)
--===================================================================
--Part 3
--3.1
CREATE INDEX emp_dept_salary_idx ON employees(dept_id, salary);

select employees.emp_name, employees.salary
from employees
where dept_id = 101 and salary > 52000;

--No, this index would not be useful for a query that only filters by salary.
--Why: Multicolumn B-tree indexes follow the leftmost prefix rule. Data in this index is sorted
--first by dept_id, and then by salary only within each dept_id. Without a condition on the leading
--column (dept_id), the database cannot efficiently navigate the index tree to find specific salary
--values and will likely fall back to a full table scan (Sequential Scan)

--3.2
CREATE INDEX emp_salary_dept_idx ON employees(salary, dept_id);
explain analyse --you can see this query is slower than the second query
select * from employees where dept_id = 102 and salary > 50000;
explain analyse --this query is faster than first query
select * from employees where salary > 50000 and dept_id = 102;

--Yes, the order of columns in a multicolumn index matters significantly
--Explanation:
--In the WHERE clause: The order of conditions (Query 1 vs Query 2) does not matter because the
--database query optimizer evaluates and optimizes them identically. Both queries will use the
--index in the same way
--In the index definition: The order of columns does matter because a B-tree index sorts data strictly
--by the columns in the specified order (salary first, then dept_id)

--Part 4
--4.1
alter table employees add column email varchar(100);
UPDATE employees SET email = 'john.smith@company.com' WHERE emp_id = 1;
UPDATE employees SET email = 'jane.doe@company.com' WHERE emp_id = 2;
UPDATE employees SET email = 'mike.johnson@company.com' WHERE emp_id = 3;
UPDATE employees SET email = 'sarah.williams@company.com' WHERE emp_id = 4;
UPDATE employees SET email = 'tom.brown@company.com' WHERE emp_id = 5;

create unique index emp_email_unique_idx ON employees(email);

INSERT INTO employees (emp_id, emp_name, dept_id, salary, email)
VALUES (6, 'New Employee', 101, 55000, 'john.smith@company.com');

--I receive you cant use insert into when email is repeating because the index is unique
--[23505] ОШИБКА: повторяющееся значение ключа нарушает ограничение уникальности "emp_email_unique_idx"
--Подробности: Ключ "(email)=(john.smith@company.com)" уже существует.

--4.2
ALTER TABLE employees ADD COLUMN phone VARCHAR(20) UNIQUE;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees' AND indexname LIKE '%phone%';
--Yes, PostgreSQL automatically created an index
--The type of index is a B-tree index and its name is employees_phone_key

--Part 5
--5.1
CREATE INDEX emp_salary_desc_idx ON employees(salary DESC);

SELECT emp_name, salary
FROM employees
ORDER BY salary DESC;
--Yes, this index helps significantly with ORDER BY salary DESC queries.
--The index is created with DESC order, which means PostgreSQL stores the salary values pre-sorted
--in descending order from the beginning. When you run an ORDER BY salary DESC query, the database
--does not need to perform a costly Sort operation. It can directly read the pre-sorted data from
--the B-tree index, making the query execution much faster.

--5.2
CREATE INDEX proj_budget_nulls_first_idx ON projects(budget NULLS FIRST);

SELECT proj_name, budget
FROM projects
ORDER BY budget NULLS FIRST;

--Part 6
--6.1
CREATE INDEX emp_name_lower_idx ON employees(LOWER(emp_name));

SELECT * FROM employees WHERE LOWER(emp_name) = 'john smith';
--the first query is search all table then change lower case

--6.2
ALTER TABLE employees ADD COLUMN hire_date DATE;

UPDATE employees SET hire_date = '2020-01-15' WHERE emp_id = 1;
UPDATE employees SET hire_date = '2019-06-20' WHERE emp_id = 2;
UPDATE employees SET hire_date = '2021-03-10' WHERE emp_id = 3;
UPDATE employees SET hire_date = '2020-11-05' WHERE emp_id = 4;
UPDATE employees SET hire_date = '2018-08-25' WHERE emp_id = 5;

CREATE INDEX emp_hire_year_idx ON employees(EXTRACT(YEAR FROM hire_date));
--BRUH🥀
SELECT emp_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2020;

--Part 7
--7.1
ALTER INDEX emp_salary_idx RENAME TO employees_salary_index;

SELECT indexname FROM pg_indexes WHERE tablename = 'employees';

--7.2
DROP INDEX emp_salary_dept_idx;
--when it isn't need and don't give more pressure to the database

--7.3
REINDEX INDEX employees_salary_index;

--Part 8
--8.1
SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000
ORDER BY e.salary DESC;

CREATE INDEX emp_salary_filter_idx ON employees(salary) WHERE salary > 50000;
-- Index for the JOIN
-- (already created: emp_dept_idx)
-- Index for ORDER BY
-- (already created: emp_salary_desc_idx)

--8.2
CREATE INDEX proj_high_budget_idx ON projects(budget)
WHERE budget > 80000;

SELECT proj_name, budget
FROM projects
WHERE budget > 80000;
--partial index it check first and if the where is valid and valid the query where then receive the result
--regular index for do the query faster and save the database resource

--8.3
EXPLAIN SELECT * FROM employees WHERE salary > 52000;
--the Seq Scan on employees  (cost=0.00..1.06 rows=2 width=522)
--this tell the scan all table

--Part 9
--9.1
CREATE INDEX dept_name_hash_idx ON departments USING HASH (dept_name);

SELECT * FROM departments WHERE dept_name = 'IT';

--9.2
CREATE INDEX proj_name_btree_idx ON projects(proj_name);

CREATE INDEX proj_name_hash_idx ON projects USING HASH (proj_name);

-- Equality search (both can be used)
SELECT * FROM projects WHERE proj_name = 'Website Redesign';-- Range search (only B-tree can be used)
SELECT * FROM projects WHERE proj_name > 'Database';

--Part 10
--10.1
SELECT
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

--10.2
-- Drop the duplicate expression indexes
DROP INDEX IF EXISTS proj_name_hash_idx;-- Keep only necessary indexe

--10.3
CREATE VIEW index_documentation AS
SELECT
    tablename,
    indexname,
    indexdef,
'Improves salary-based queries' as purpose
FROM pg_indexes
WHERE schemaname = 'public'
AND indexname LIKE '%salary%';
SELECT * FROM index_documentation;