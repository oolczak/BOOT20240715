-- lab_08_01

DECLARE 
    v_deptno NUMBER := 10; 
    CURSOR  c_emp_cursor IS 
        SELECT last_name, salary, manager_id 
        FROM   employees 
        WHERE  department_id = v_deptno;
BEGIN 
    FOR emp_record IN c_emp_cursor LOOP 
        IF emp_record.salary < 5000 AND emp_record.manager_id in (101, 124) THEN 
            DBMS_OUTPUT.PUT_LINE (emp_record.last_name || ' Debería recibir un aumento'); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE (emp_record.last_name || ' No debería recibir un aumento'); 
        END IF; 
    END LOOP; 
END; 
/
DECLARE 
    TYPE LISTA is table of departments.department_id%TYPE;
    CURSOR  c_emp_cursor(v_deptno NUMBER) IS 
        SELECT last_name, salary, manager_id 
        FROM   employees 
        WHERE  department_id = v_deptno;
    v_departments LISTA DEFAULT LISTA(10,20,50,80);
BEGIN 
    FOR i IN 1..v_departments.count() LOOP
        DBMS_OUTPUT.PUT_LINE ('Departamento: ' || v_departments(i)); 
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------'); 
        FOR emp_record IN c_emp_cursor(v_departments(i)) LOOP 
            IF emp_record.salary < 5000 AND emp_record.manager_id in (101, 124) THEN 
                DBMS_OUTPUT.PUT_LINE ('    ' || emp_record.last_name || ' Debería recibir un aumento'); 
            ELSE 
                DBMS_OUTPUT.PUT_LINE ('    ' || emp_record.last_name || ' NO debería recibir un aumento'); 
            END IF; 
        END LOOP; 
    END LOOP; 
END; 
/
-- lab_08_02

DECLARE 
    CURSOR c_dept_cursor IS 
        SELECT department_id,department_name 
        FROM  departments 
        WHERE department_id < 100 
        ORDER BY    department_id;
    CURSOR c_emp_cursor(v_deptno NUMBER) IS 
        SELECT last_name,job_id,hire_date,salary 
        FROM  employees 
        WHERE department_id = v_deptno 
        AND employee_id < 120;
    v_current_deptno departments.department_id%TYPE; 
    v_current_dname  departments.department_name%TYPE; 
    v_ename employees.last_name%TYPE; 
    v_job employees.job_id%TYPE;  
    v_hiredate employees.hire_date%TYPE; 
    v_sal employees.salary%TYPE;
BEGIN 
    OPEN c_dept_cursor; 
    LOOP 
        FETCH c_dept_cursor INTO v_current_deptno, v_current_dname; 
        EXIT WHEN c_dept_cursor%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE ('Department Number : ' || v_current_deptno || 
            '  Department Name : ' || v_current_dname);
        IF c_emp_cursor%ISOPEN THEN 
            CLOSE c_emp_cursor; 
        END IF; 
        OPEN c_emp_cursor (v_current_deptno); 
        LOOP 
            FETCH c_emp_cursor INTO  v_ename,v_job,v_hiredate,v_sal; 
            EXIT WHEN c_emp_cursor%NOTFOUND; 
            DBMS_OUTPUT.PUT_LINE (v_ename || '    ' ||  v_job || '   '  ||  
                v_hiredate || '   ' ||  v_sal);        
        END LOOP; 
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------'); 
        CLOSE c_emp_cursor; 
    END LOOP;        
    CLOSE c_dept_cursor; 
END;
/
DECLARE 
    TYPE dept IS RECORD(
        id departments.department_id%TYPE, 
        name  departments.department_name%TYPE,
        num_emp NUMBER,
        total NUMBER
    );
    TYPE emp IS RECORD(
        name employees.last_name%TYPE,
        job employees.job_id%TYPE,  
        hiredate employees.hire_date%TYPE,
        salary employees.salary%TYPE
    );
    CURSOR c_dept_cursor IS 
        SELECT department_id,department_name, 0, 0 
        FROM  departments 
        WHERE department_id < 100 
        ORDER BY    department_id;
    CURSOR c_emp_cursor(v_deptno NUMBER) IS 
        SELECT last_name,job_id,hire_date,salary 
        FROM  employees 
        WHERE department_id = v_deptno AND employee_id < 120;
    v_dept dept; 
    v_emp emp;
    v_sal_prior employees.salary%TYPE;
BEGIN 
    OPEN c_dept_cursor; 
    LOOP 
        FETCH c_dept_cursor INTO v_dept; 
        EXIT WHEN c_dept_cursor%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE ('Department Number : ' || v_dept.id || 
            '  Department Name : ' || v_dept.name);
        v_sal_prior := null;
        OPEN c_emp_cursor (v_dept.id); 
        LOOP 
            FETCH c_emp_cursor INTO v_emp; 
            EXIT WHEN c_emp_cursor%NOTFOUND;
            v_dept.num_emp := v_dept.num_emp + 1;
            v_dept.total := v_dept.total + v_emp.salary;
            DBMS_OUTPUT.PUT_LINE (RPAD(v_dept.num_emp, 3, ' ') || '    ' ||  RPAD(v_emp.name, 15, ' ') || '    ' ||  
                RPAD(v_emp.job, 10, ' ') || '   '  || v_emp.hiredate || '   ' ||  
                LPAD(v_emp.salary, 6, ' ') || '   ' ||  LPAD(v_emp.salary - v_sal_prior, 6, ' ')); 
            v_sal_prior := v_emp.salary;       
        END LOOP; -- RPAD(, , ' ')
        IF v_dept.num_emp > 0 THEN
            DBMS_OUTPUT.PUT_LINE('    ------------------------------------------------------------------------------------'); 
            DBMS_OUTPUT.PUT_LINE('    TOTAL: ' || v_dept.total || '    MEDIA: ' || ROUND(v_dept.total / v_dept.num_emp, 2) );        
        END IF;
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------'); 
        CLOSE c_emp_cursor; 
    END LOOP;        
    CLOSE c_dept_cursor; 
END;
/
-- lab_08_03
/*
-- DROP TABLE TOP_SALARIES;
CREATE TABLE TOP_SALARIES(
  ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 START WITH 1 NOT NULL 
, SALARY NUMBER(8,2) NOT NULL 
, CONSTRAINT TOP_SALARIES_PK PRIMARY KEY (ID) ENABLE 
);
CREATE TABLE TOP_SALARIES(SALARY NUMBER(8,2) NOT NULL);
*/

DECLARE 
    v_num         NUMBER(3) := 5; 
    v_sal         employees.salary%TYPE; 
    CURSOR        c_emp_cursor IS 
        SELECT      salary 
        FROM        employees 
        ORDER BY    salary DESC; 
BEGIN 
    DELETE FROM top_salaries;
    OPEN c_emp_cursor; 
    FETCH c_emp_cursor INTO v_sal; 
    WHILE c_emp_cursor%ROWCOUNT <= v_num AND c_emp_cursor%FOUND LOOP 
        INSERT INTO top_salaries(salary) VALUES (v_sal);   
        FETCH c_emp_cursor INTO v_sal; 
    END LOOP; 
    CLOSE c_emp_cursor;   
END; 
/ 
SELECT * FROM top_salaries; 
