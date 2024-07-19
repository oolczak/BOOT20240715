-- SELECT * FROM JOBS;
/
DEsc jobs; -- Esto es un ejempo
/
SELECT DEPARTMENT_ID, DEPARTMENT_NAME 
FROM DEPARTMENTS;
/
SELECT last_name, LAST_NAME || q'( algo's )' || FIRST_NAME as "Nombre Completo", salary*12 "Salario Anual" --, SALARY
FROM   employees;
/
SELECT last_name, job_id, salary, commission_pct, salary * NVL(commission_pct,0)
FROM   employees;
/
SELECT DISTINCT department_id
FROM   employees;
/
desc employees

