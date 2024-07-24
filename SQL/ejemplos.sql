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
FROM employees;
/
SELECT SYSDATE, SYSDATE - 7, SYSDATE - TO_DATE('01-JUN-2024'), TO_CHAR(SYSDATE, 'DD-MON-RR')
from dual;
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR';
SELECT EMPLOYEE_ID, SYSDATE - HIRE_DATE "Dias en la empresa", HIRE_DATE
FROM   employees;
/
SELECT last_name,salary, 
upper((CASE 
      WHEN salary>20000 THEN 'Good' 
      WHEN COMMISSION_PCT IS NOT NULL THEN 'Medium' 
      WHEN LAST_NAME = 'King' then 'jefe'
    WHEN salary>5000 THEN 'Low' 
    WHEN SALARY IS NULL THEN 'SIN SALARIO'
      ELSE 'Excellent' 
END) || ' algo') qualified_salary 
FROM employees
where upper((CASE 
      WHEN salary>20000 THEN 'Good' 
      WHEN COMMISSION_PCT IS NOT NULL THEN 'Medium' 
      WHEN LAST_NAME = 'King' then 'jefe'
    WHEN salary>5000 THEN 'Low' 
    WHEN SALARY IS NULL THEN 'SIN SALARIO'
      ELSE 'Excellent' 
END) || ' algo') is not null ;
/
-- lab_03_07
-- ALTER SESSION SET NLS_LANGUAGE=English;
SELECT last_name, hire_date
FROM employees
where EXTRACT(YEAR FROM hire_date) = 2006
    OR TO_CHAR(hire_date, 'YEAR') = '2006'
;
/
SELECT count(*), count(1), count(EMPLOYEE_ID), count(COMMISSION_PCT), max(SALARY), min(SALARY)
FROM employees;
/
SELECT avg(COMMISSION_PCT), sum(COMMISSION_PCT)/count(COMMISSION_PCT), sum(COMMISSION_PCT)/count(1), avg(nvl(COMMISSION_PCT,0))
FROM employees;
/
SELECT department_id, job_id, min(FIRST_NAME), count(*), count(1), count(EMPLOYEE_ID), count(COMMISSION_PCT), max(SALARY), min(SALARY)
FROM employees
--WHERE SALARY > 3000 AND DEPARTMENT_ID IN (50,60,80)
GROUP BY department_id, job_id
HAVING count(1) = 1 AND AVG(SALARY) > 3000
order by department_id, job_id
;
/

SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM employees

/
SELECT DEPARTMENT_ID, avg(SALARY)
FROM employees
GROUP BY department_id
/
SELECT EMPLOYEE_ID, LAST_NAME, SALARY,  avg(SALARY) over(PARTITION by department_id)
FROM employees
--WHERE  SALARY > avg(SALARY) over(PARTITION by department_id)
; --AVG(salary) OVER (PARTITION BY manager_id ORDER BY hire_date
/
SELECT CASE GROUPING(department_id) WHEN 0 THEN to_char(department_id) ELSE 'TOTAL' END departamento, 
    CASE GROUPING(job_id) WHEN 0 THEN job_id ELSE 'TOTAL' END PUESTO, count(*), GROUPING(department_id), GROUPING(job_id)
FROM employees
GROUP BY ROLLUP(department_id, job_id)
order by department_id, job_id
;

SELECT TO_CHAR(department_id) department_id, job_id, count(*) EMPLEADOS, 1 CONSULTA
FROM employees
GROUP BY department_id, JOB_ID
UNION
    SELECT TO_CHAR(department_id) department_id, 'Total DEL DEPARTAMENTO' JOB_ID, count(*) EMPLEADOS, 2 CONSULTA
    FROM employees
    GROUP BY department_id
UNION
    SELECT 'Total DE LA EMPRESA' department_id, '' JOB_ID, count(*) EMPLEADOS, 3 CONSULTA
    FROM employees
    order by department_id, CONSULTA, job_id




;
/
SELECT DECODE(GROUPING(department_name), 1, 'all Departments',
      department_name) AS department_name,
   DECODE(GROUPING(job_id), 1, 'all Jobs', job_id) AS job_id,
   COUNT(*) "Total Empl", AVG(salary) * 12 "Average Sal"
   FROM employees e, departments d
   WHERE d.department_id = e.department_id
   GROUP BY CUBE (department_name, job_id)
   ORDER BY department_name, job_id;
/   
SELECT * FROM (
    SELECT job_id, department_id, salary
    FROM employees
    WHERE department_id in (20,50,80,90)
) PIVOT (
    sum(salary) for department_id in (20 as "Dept 20", 50 as "Dept 50", 80 as "Dept 80", 90 as "Dept 90")
);
/
SELECT EXTRACT(YEAR FROM hire_date) AÑO, TO_NUMBER(TO_CHAR(hire_date, 'q')) trimestre, ROUND(AVG(SALARY),2)
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date), TO_NUMBER(TO_CHAR(hire_date, 'q'))
ORDER BY año, trimestre;
/
SELECT * FROM (
    SELECT EXTRACT(YEAR FROM hire_date) AÑO, TO_NUMBER(TO_CHAR(hire_date, 'q')) trimestre, SALARY
    FROM employees
) PIVOT (
    avg(salary) for trimestre in (1 as "T1", 2 as "T2", 3 as "T3", 4 as "T4")
)
ORDER BY 1;
/
SELECT AÑO, NVL(ROUND(T1, 2),0) T1, NVL(ROUND(T2, 2),0) T2, NVL(ROUND(T3, 2),0) T3, NVL(ROUND(T4, 2),0) T4,
    NVL(ROUND(T1, 2),0) + NVL(ROUND(T2, 2),0) + NVL(ROUND(T3, 2),0) + NVL(ROUND(T4, 2),0) Total
  FROM (
    SELECT EXTRACT(YEAR FROM hire_date) AÑO, TO_NUMBER(TO_CHAR(hire_date, 'q')) trimestre, SALARY
    FROM employees
) PIVOT (
    avg(salary) for trimestre in (1 as "T1", 2 as "T2", 3 as "T3", 4 as "T4")
)
ORDER BY 1;
