CREATE OR REPLACE PROCEDURE check_salary (p_the_job VARCHAR2,  p_the_salary NUMBER) IS 
    v_minsal jobs.min_salary%type; 
    v_maxsal jobs.max_salary%type; 
BEGIN 
    SELECT min_salary, max_salary 
    INTO v_minsal, v_maxsal 
    FROM jobs 
    WHERE job_id = UPPER(p_the_job); 
    IF p_the_salary NOT BETWEEN v_minsal AND v_maxsal THEN 
        RAISE_APPLICATION_ERROR(-20100,  
            'Invalid salary $' ||p_the_salary ||'. '|| 
            'Salaries for job '|| p_the_job ||  
            ' must be between $'|| v_minsal ||' and $' || v_maxsal); 
    END IF; 
END; 
/ 
SHOW ERRORS
/
CREATE OR REPLACE TRIGGER check_salary_trg  
BEFORE INSERT OR UPDATE OF job_id, salary ON employees 
FOR EACH ROW
WHEN (new.job_id <> NVL(old.job_id,'?') OR new.salary <> NVL(old.salary,0)) 
BEGIN 
    check_salary(:new.job_id, :new.salary); 
END; 
/ 
CREATE OR REPLACE TRIGGER delete_emp_trg 
BEFORE DELETE ON employees 
DECLARE 
  the_day VARCHAR2(3) := TO_CHAR(SYSDATE, 'DY'); 
  the_hour PLS_INTEGER := TO_NUMBER(TO_CHAR(LOCALTIMESTAMP, 'HH24')); 
BEGIN 
    IF (the_hour BETWEEN 8 AND 18) AND (the_day NOT IN ('SAT','SUN')) THEN 
        RAISE_APPLICATION_ERROR(-20150,  
            'Employee records cannot be deleted during the business hours of 8AM and 6PM'); 
    END IF; 
END; 
/ 
SHOW ERRORS 
/
BEGIN
    INSERT INTO ALUMNO.EMPLOYEES
        (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
        VALUES(EMPLOYEES_SEQ.NEXTVAL, 'PEPITO', 'GRILLO', 'pgrillo', '555 000 000',TO_CHAR(sysdate, 'DD/Mon/RR'), 'AD_PRES', 22000, null, null, 210);
    DBMS_OUTPUT.PUT_LINE ('Created: ' || EMPLOYEES_SEQ.CURRVAL);
    --COMMIT;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: ' || SQLERRM);
    ROLLBACK;
END;
/
UPDATE employees 
  SET salary = 2000 
WHERE employee_id = 115; 
/
UPDATE employees 
  SET job_id = 'HR_REP' 
WHERE employee_id = 115;
/
SELECT * FROM employees WHERE employee_id = 115;
UPDATE employees 
  SET salary = 2800 
WHERE employee_id = 115;
/
DELETE FROM employees WHERE employee_id = 115;
/
SELECT DBTIMEZONE, SYSTIMESTAMP, CURRENT_TIMESTAMP, LOCALTIMESTAMP, SESSIONTIMEZONE 
  FROM DUAL;
/
ROLLBACK;