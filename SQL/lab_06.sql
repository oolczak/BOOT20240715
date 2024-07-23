-- lab_06_01
-- TRUE

-- lab_06_02
-- FALSE

-- lab_06_03
-- TRUE

-- lab_06_04
SELECT ROUND(MAX(salary), 0) "Maximum",
    ROUND(MIN(salary), 0) "Minimum",
    ROUND(SUM(salary), 0) "Sum",
    ROUND(AVG(salary), 0) "Average"
FROM employees;

-- lab_06_05
SELECT job_id, ROUND(MAX(salary), 0) "Maximum",
    ROUND(MIN(salary), 0) "Minimum",
    ROUND(SUM(salary), 0) "Sum",
    ROUND(AVG(salary), 0) "Average"
FROM employees
GROUP BY job_id;

-- lab_06_06
SELECT job_id, COUNT(*)
FROM employees
GROUP BY job_id;

-- lab_06_07
SELECT COUNT(DISTINCT manager_id) "Number of Managers"
FROM employees;

-- lab_06_08
SELECT MAX(salary) - MIN(salary) DIFERENCE
FROM employees;

-- lab_06_09
SELECT manager_id, MIN(salary)
FROM employees 
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) > 6000
ORDER BY MIN(salary) DESC;

SELECT manager_id, MIN(salary)
FROM employees 
WHERE manager_id IS NOT NULL and salary > 6000
GROUP BY manager_id
ORDER BY MIN(salary) DESC;

-- lab_06_10
SELECT COUNT(*) TOTAL,
    SUM(CASE TO_CHAR(hire_date, 'YYYY') WHEN '2003' THEN 1 ELSE 0 END) "2003 a",
    COUNT(CASE TO_CHAR(hire_date, 'YYYY') WHEN '2003' THEN 1 END) "2003 b",
    SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2003, 1, 0)) "2003",
   SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2004, 1, 0)) "2004",
   SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2005, 1, 0)) "2005",
   SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2006, 1, 0)) "2006",
    SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2009, 1, 0)) "2009",
    SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2010, 1, 0)) "2010",
    SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2011, 1, 0)) "2011",
    SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2012, 1, 0)) "2012"
FROM employees
--where hire_date BETWEEN '01-01-2003' and '31-12-2009'
--where TO_CHAR(hire_date, 'YYYY') BETWEEN '2003' and '2009'
;

-- lab_06_11
SELECT job_id "Job",
    SUM(DECODE(department_id, 20, salary, 0)) "Dept 20",
    SUM(DECODE(department_id, 50, salary)) "Dept 50",
    SUM(DECODE(department_id, 80, salary)) "Dept 80",
    SUM(DECODE(department_id, 90, salary)) "Dept 90",
    SUM(salary) "Total"
FROM employees
WHERE department_id in (20,50,80,90)
GROUP BY job_id;


