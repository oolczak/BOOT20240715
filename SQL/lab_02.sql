-- lab_02_01
SELECT last_name, job_id, salary AS Sal
FROM employees;

-- lab_02_02
SELECT * FROM job_grades;

-- lab_02_03
--SELECT employee_id, last_name
--     sal x 12 ANNUAL SALARY
--FROM employees;
SELECT employee_id, last_name,
     salary * 12 "ANNUAL SALARY"
FROM employees;

-- lab_02_04a
DESCRIBE departments
-- lab_02_04b
SELECT * FROM departments;

-- lab_02_05a
DESCRIBE employees
-- lab_02_05b
SELECT employee_id, last_name, job_id, hire_date StartDate 
FROM employees;

-- lab_02_06
SELECT DISTINCT job_id
FROM employees;

-- lab_02_07
SELECT employee_id "Emp #", last_name "Employee", 
    job_id "Job", hire_date "Hire Date"
FROM employees;

-- lab_02_08
SELECT last_name || ', ' || job_id "Employee and Title"
FROM employees;

-- lab_02_09
SELECT employee_id || ', ' || first_name || ', ' || last_name 
    || ', ' || email || ', ' || phone_number || ', ' || job_id 
    || ', ' || manager_id || ', ' || hire_date || ', ' 
    || salary || ', ' || commission_pct  || ', ' || department_id
    THE_OUTPUT
FROM employees;

