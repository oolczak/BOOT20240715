-- lab_08_01
UNDEFINE name
DEFINE name=Zlotkey

SELECT last_name, HIRE_DATE
FROM employees
WHERE last_name <> '&&name' AND department_id IN (
    SELECT department_id
    FROM employees
    WHERE last_name = '&name'
    );

-- lab_08_02
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    )
ORDER BY salary;

-- lab_08_03
SELECT employee_id, last_name
FROM employees
WHERE 
    department_id = ANY (
--    department_id in (
    SELECT department_id
    FROM employees
    WHERE LOWER(last_name) like '%u%'
    );

-- lab_08_04
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id in (
    SELECT department_id
    FROM departments
    WHERE location_id = 1700
--    WHERE location_id = &location
    );

-- lab_08_05
SELECT last_name, salary
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'King'
    );

-- lab_08_06
SELECT department_id, last_name, job_id
FROM employees
WHERE department_id in (
    SELECT department_id
    FROM departments
    WHERE department_name = 'Executive'
    );

-- lab_08_07
SELECT last_name
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department_id = 60
    )
ORDER BY salary;

SELECT last_name
FROM employees
WHERE salary > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 60
    )
ORDER BY salary;

-- lab_08_08
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id in (
        SELECT department_id
        FROM employees
        WHERE last_name like '%u%'
    ) AND salary > (
        SELECT AVG(salary)
        FROM employees
    );
