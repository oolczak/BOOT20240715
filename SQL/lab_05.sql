-- lab_05_01
SELECT last_name || ' earns ' || TO_CHAR(salary, 'fm$99,999.00')
    || ' monthly but wants ' || TO_CHAR(salary * 3, 'fm$99,999.00')
    || '.' "Dream Salaries"
FROM employees;

-- lab_05_02
--ALTER SESSION SET NLS_LANGUAGE=English;
SELECT TO_CHAR(NEXT_DAY(SYSDATE, 0),'Day') from DUAL;

SELECT TO_CHAR(TO_DATE('31-07-2000', 'DD-MM-YYYY'), 'fmDay, "the" Ddspth "of" Month, YYYY') FROM dual;

SELECT last_name, hire_date,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 2), -- 'MONDAY' 'LUNES'
        'fmDay, "the" Ddspth "of" Month, YYYY', 'NLS_DATE_LANGUAGE = ENGLISH' 
    ) REVIEW
FROM employees;
SELECT last_name, hire_date,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 2), -- 'MONDAY' 'LUNES'
        'fmDay, "el" Ddspth "de" Month "de" YYYY', 'NLS_DATE_LANGUAGE = SPANISH' 
    ) REVIEW
FROM employees;

-- lab_05_03
SELECT last_name, NVL(TO_CHAR(commission_pct, '0.00'), 'No commission') COMM, NVL(commission_pct, 0) * salary,
case 
    when commission_pct is null then 'No commission'
    else TO_CHAR(commission_pct, '0.00')
end "con case"
FROM employees
--where commission_pct is not null
;

-- lab_05_04
SELECT /*DISTINCT*/ job_id, CASE job_id
    WHEN 'ST_CLERK' THEN 'E'
    WHEN 'SA_REP' THEN 'D'
    WHEN 'IT_PROG' THEN 'C'
    WHEN 'ST_MAN' THEN 'B'
    WHEN 'AD_PRES' THEN 'A'
    ELSE 'O'
    END GRADE
FROM employees
-- WHERE CASE job_id
--     WHEN 'ST_CLERK' THEN 'E'
--     WHEN 'SA_REP' THEN 'D'
--     WHEN 'IT_PROG' THEN 'C'
--     WHEN 'ST_MAN' THEN 'B'
--     WHEN 'AD_PRES' THEN 'A'
--     ELSE 'O'
--     END in ('E', 'C')
ORDER BY GRADE
;

-- lab_05_05
SELECT job_id, CASE
    WHEN job_id = 'ST_CLERK' THEN 'E'
    WHEN job_id = 'SA_REP' THEN 'D'
    WHEN job_id = 'IT_PROG' THEN 'C'
    WHEN job_id = 'ST_MAN' THEN 'B'
    WHEN job_id = 'AD_PRES' THEN 'A'
    ELSE 'O'
    END GRADE
FROM employees;

-- lab_05_06
SELECT job_id, DECODE(job_id, 
    'ST_CLERK','E',
    'SA_REP', 'D',
    'IT_PROG', 'C',
    'ST_MAN', 'B',
    'AD_PRES', 'A',
    'O'
    ) GRADE
FROM employees;
