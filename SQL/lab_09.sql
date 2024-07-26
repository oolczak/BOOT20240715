-- lab_09_01
SELECT department_id
FROM departments
MINUS
SELECT department_id
FROM employees
WHERE job_id = 'ST_CLERK';

SELECT DISTINCT department_id
FROM departments
WHERE department_id not in (
    SELECT DISTINCT department_id
    FROM employees
    WHERE job_id = 'ST_CLERK'
)
ORDER BY 1;

-- lab_09_02
SELECT country_id, country_name
FROM countries
MINUS
SELECT c.country_id, c.country_name
FROM locations l
    JOIN countries c ON l.country_id = c.country_id
    JOIN departments d ON l.location_id = d.location_id;

-- lab_09_03
SELECT employee_id, job_id, department_id --, 1
FROM employees
WHERE department_id=50
UNION
SELECT employee_id, job_id, department_id --, 2
FROM employees
WHERE department_id=80;

-- lab_09_04
SELECT employee_id
FROM employees
WHERE job_id='SA_REP'
INTERSECT
SELECT employee_id
FROM employees
WHERE department_id=80;
--SELECT employee_id
--FROM employees
--WHERE job_id='SA_REP' AND department_id=80;

-- lab_09_05
SELECT last_name, department_id, TO_CHAR(NULL) department_name
FROM employees
UNION
SELECT TO_CHAR(NULL), department_id, department_name
FROM departments;

SELECT department_id, last_name, salary
FROM (
    SELECT department_id, last_name, salary, 0 orden
    FROM employees
    UNION
    SELECT department_id, 'Total', SUM(salary), 1
    FROM employees
    GROUP BY department_id
)
ORDER BY 1, orden, 2;
