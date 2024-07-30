-- lab_05_01
/*
DECLARE 
   v_max_deptno  NUMBER;   
BEGIN 
    SELECT MAX(department_id)  INTO v_max_deptno  FROM departments;
    DBMS_OUTPUT.PUT_LINE('The maximum department_id is : ' || v_max_deptno); 
END;
*/
-- lab_05_02

DECLARE 
    v_max_deptno  NUMBER; 
    v_dept_name departments.department_name%TYPE:= 'Education'; 
    v_dept_id NUMBER;   
BEGIN 
    SELECT MAX(department_id)  INTO v_max_deptno  FROM departments;
    DBMS_OUTPUT.PUT_LINE('The maximum department_id is : ' || v_max_deptno); 
    v_dept_id := 10 + v_max_deptno; 
    INSERT INTO departments (department_id, department_name, 
    location_id)  
    VALUES (v_dept_id, v_dept_name, NULL);
    DBMS_OUTPUT.PUT_LINE (' SQL%ROWCOUNT gives ' || SQL%ROWCOUNT);
END;
-- SELECT * FROM departments WHERE department_id=280;

-- lab_05_03

DECLARE 
    v_max_deptno  NUMBER; 
    v_dept_name departments.department_name%TYPE:= 'Education'; 
    v_dept_id NUMBER;   
BEGIN 
    UPDATE departments 
    SET location_id=3000 
    WHERE department_id=280; 
    DBMS_OUTPUT.PUT_LINE (' SQL%ROWCOUNT gives ' || SQL%ROWCOUNT);
END;
-- ROLLBACK;
-- DELETE FROM departments WHERE department_id=280;