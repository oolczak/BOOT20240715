-- SELECT * FROM JOBS;
/
DEsc jobs; -- Esto es un ejempo
/
SELECT DEPARTMENT_ID, DEPARTMENT_NAME 
FROM DEPARTMENTS;
/
SELECT last_name, LAST_NAME || q'( algo's )' || FIRST_NAME as "Nombre Completo", (12*salary)+100 "Salario Anual" --, SALARY
FROM   employees;
/
SELECT last_name, job_id, salary, commission_pct, salary * NVL(commission_pct,0)
FROM   employees;
/
SELECT DISTINCT department_id
FROM   employees;
/
desc employees
/
SELECT salary, DEPARTMENT_ID, FIRST_NAME || ' ' || last_name nombre
FROM   employees
WHERE  salary BETWEEN 2500 AND 3500
order by 2, 1
/
SELECT last_name 
FROM   employees 
WHERE  last_name NOT BETWEEN 'King' AND 'Whalen'

SELECT last_name 
FROM   employees 
WHERE  last_name = 'King'
/
SELECT	first_name
FROM 	employees
WHERE	first_name LIKE '%\_%' ESCAPE '\' ;
/
SELECT last_name, manager_id
FROM   employees
WHERE  manager_id = NULL ;
/
SELECT *
FROM   employees
where (manager_id is null and commission_pct is null) or (manager_id = commission_pct)
/
SELECT rownum, last_name, department_id, salary
FROM   employees
WHERE  
department_id = 60 OR (department_id = 80 AND salary > 10000);
/
SELECT *
FROM   employees 
order by EMPLOYEE_ID
FETCH NEXT 10 ROWS ONLY;
/
set verify on
SELECT &&pide_puesto puesto, employees.*
FROM   employees 
where JOB_ID = &&pide_puesto;

undefine &&pide_puesto;
/
SELECT last_name, hire_date, ADD_MONTHS(hire_date, 5 * 12)
FROM employees