/*
-- DROP TABLE MESSAGES;
CREATE TABLE MESSAGES(
  ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 START WITH 1 NOT NULL 
, RESULTS VARCHAR2(500) NOT NULL 
, CREATE_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL 
, CONSTRAINT MESSAGES_PK PRIMARY KEY (ID) ENABLE 
);
ALTER TABLE MESSAGES
ADD CONSTRAINT MESSAGES_RESULTS_NOT_BLANK 
	CHECK (NVL(LENGTH(TRIM(RESULTS)),0) > 0) ENABLE;

INSERT INTO MESSAGES(RESULTS) VALUES('Table created');

COMMIT;

*/
-- lab_05_01
/*
DECLARE 
   v_max_deptno  NUMBER;   
BEGIN 
    SELECT MAX(department_id)  INTO v_max_deptno  FROM departments;
    DBMS_OUTPUT.PUT_LINE('The maximum department_id is : ' || v_max_deptno); 
END;
*/
-- lab_06_01
--             INSERT INTO messages(results) 
--             VALUES ('kk'); 
-- SELECT * from messages

BEGIN 
    FOR i in 1..10 LOOP 
        -- IF i = 6 or i = 8 THEN 
        --     null; 
        -- ELSE 
        --     INSERT INTO messages(results) 
        --     VALUES (i); 
        -- END IF;  
        -- IF i NOT IN (6, 8) THEN
        --     INSERT INTO messages(results) VALUES ('Message: ' || i); 
        -- END IF;
        CONTINUE WHEN i IN (6, 8);
        INSERT INTO messages(results) VALUES ('Message: ' || i); 
    END LOOP; 
    COMMIT; 
END;

-- 
SELECT * 
FROM messages 
order by id desc 
FETCH NEXT 10 ROWS ONLY;

-- lab_06_02
/*
--drop table emp;
create table emp 
as select * from employees;
alter table EMP add(STARS VARCHAR2(50));
*/

DECLARE 
    v_empno         emp.employee_id%TYPE := 176; 
    v_asterisk      emp.stars%TYPE := NULL; 
    v_sal           emp.salary%TYPE;
BEGIN 
    SELECT NVL(ROUND(salary/1000), 0)  INTO v_sal 
        FROM emp  WHERE employee_id = v_empno; 

    FOR i IN 1..v_sal LOOP 
        v_asterisk := v_asterisk ||'*'; 
    END LOOP; 
    UPDATE emp 
        SET stars = v_asterisk 
        WHERE employee_id = v_empno; 
    COMMIT; 
END;
/
SELECT employee_id,salary, stars, RPAD('*', ROUND((salary/1000)), '*') SALARIES_IN_ASTERISK 
FROM emp WHERE employee_id =176;

-- lab_04_08
SELECT last_name, RPAD('*', (salary/1000), '*') SALARIES_IN_ASTERISK --, salary
FROM employees
ORDER BY salary DESC;
