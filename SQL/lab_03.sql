-- lab_03_01
SELECT last_name, salary
FROM employees
WHERE salary > 1200;

-- lab_03_02
SELECT last_name, department_id
FROM employees
WHERE employee_id = 176;

-- lab_03_03
SELECT last_name, salary
FROM employees
WHERE salary NOT BETWEEN 5000 AND 12000;

-- lab_03_04
SELECT ALL last_name, job_id, hire_date
FROM employees
WHERE last_name in ('Matos', 'Taylor')
ORDER BY hire_date ASC;

-- lab_03_05
SELECT last_name, department_id
FROM employees
WHERE department_id IN (20,50)
ORDER BY last_name ASC;

-- lab_03_06
SELECT last_name "Employee", salary "Monthly Salary"
FROM employees
WHERE salary NOT BETWEEN 5000 AND 12000
    AND department_id IN (20,50);

-- lab_03_07
-- ALTER SESSION SET NLS_LANGUAGE=English;
SELECT last_name, hire_date
FROM employees
where '01-JAN-06' <= hire_date AND hire_date < '01-JAN-07';

-- ALTER SESSION SET NLS_LANGUAGE=Spanish;
SELECT last_name, hire_date
FROM employees
--where '01-ENE-06' <= hire_date AND hire_date < '01-ENE-07';
where hire_date BETWEEN '01-ENE-10' AND '31-DIC-10';

-- lab_03_08
SELECT last_name, job_id 
FROM employees
WHERE manager_id IS NULL;

-- lab_03_09
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY 2 DESC, 3 DESC;

-- lab_03_10
SELECT last_name, salary
FROM employees
WHERE salary > &sal_amt;

-- lab_03_11
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE manager_id = &mgr_num
ORDER BY &order_col;
--SELECT manager_id, employee_id FROM employees WHERE manager_id IS NOT NULL ORDER BY 1;
-- (103, last_name) (100, salary) (124, employee_id) 

-- lab_03_12
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';

-- lab_03_13
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';

-- lab_03_14
SELECT last_name, job_id, salary
FROM employees
WHERE job_id in ('SA_REP', 'ST_CLERK')
    AND salary NOT IN (2500, 3500, 7000);

-- lab_03_15
SELECT last_name "Employee", salary "Monthly Salary", commission_pct
FROM employees
WHERE commission_pct = .20;
