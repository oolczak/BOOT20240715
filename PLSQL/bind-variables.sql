VARIABLE b_new_salary NUMBER 
VARIABLE b_emp_id NUMBER
VARIABLE b_percent NUMBER 

DECLARE 
   v_salary EMPLOYEES.SALARY%TYPE;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Porcentaje: ' || &b_percent);
    select SALARY * nvl(&b_percent, 1)
    into v_salary
    from EMPLOYEES 
    where EMPLOYEE_ID = &b_emp_id;
    DBMS_OUTPUT.PUT_LINE('Nuevo salario: ' || v_salary);
    :b_new_salary := v_salary;
END;
/
PRINT b_new_salary
