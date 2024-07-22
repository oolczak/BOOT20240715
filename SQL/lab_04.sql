-- lab_04_01
SELECT sysdate "Date"
FROM dual;

-- lab_04_02
SELECT employee_id, last_name, salary, 
    salary + (salary * 15.5 / 100) "Sin redondeo",
    ROUND(salary * 1.155, 0) "New Salary"
FROM employees;

-- lab_04_04
SELECT employee_id, last_name, salary, 
    ROUND(salary * 1.155, 0) "New Salary",
    ROUND(salary * 1.155, 0) - salary "Increase"
FROM employees;

-- lab_04_05a
SELECT INITCAP(last_name) "Name",
    LENGTH(last_name) "Length"
FROM employees
WHERE last_name LIKE 'M%' OR last_name LIKE 'A%'
ORDER BY last_name;

-- lab_04_05b
SELECT INITCAP(last_name) "Name",
    LENGTH(last_name) "Length"
FROM employees
WHERE last_name LIKE '&start_letter%'
ORDER BY last_name;

-- lab_04_05c
SELECT INITCAP(last_name) "Name",
    LENGTH(last_name) "Length"
FROM employees
WHERE UPPER(last_name) LIKE UPPER('&start_letter%')
ORDER BY last_name;

-- lab_04_06
SELECT last_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) MONTHS_WORKED
FROM employees
ORDER BY MONTHS_WORKED;

-- lab_04_07
SELECT last_name, LPAD(salary, 15, '$') SALARY
FROM employees;

-- lab_04_08
SELECT last_name, RPAD('*', (salary/1000), '*') SALARIES_IN_ASTERISK --, salary
FROM employees
ORDER BY salary DESC;

-- lab_04_09
SELECT last_name, TRUNC((SYSDATE - hire_date)/7) TENURE
FROM employees
ORDER BY TENURE DESC;
