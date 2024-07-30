DECLARE
    v_cuantos NUMBER;
    total NUMBER;

BEGIN
    --DBMS_OUTPUT.PUT_LINE('Hola ' || v_nombre);
    --v_nombre := 'tu';
    select count(*)
    into v_cuantos
    from EMPLOYEES 
    where EMPLOYEE_ID = 1203;
    if v_cuantos = 1 then
        DECLARE
            v_nombre VARCHAR2(100); -- not null; -- default 'Mundo';
            v_LAST_NAME EMPLOYEES.FIRST_NAME%TYPE;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Cuantos: ' || v_cuantos);
            v_cuantos := 1.2;
            select FIRST_NAME, LAST_NAME || v_LAST_NAME, SALARY * v_cuantos
            into v_nombre, v_LAST_NAME, total
            from EMPLOYEES 
            where EMPLOYEE_ID = 203;
            DBMS_OUTPUT.PUT_LINE('Hola ' || nvl(v_nombre, '(anonimo)') || ' tu salario es ' || total);
        END;
    elsif v_cuantos = 0 THEN
        <<exterior>>
        for x in 1..3 loop
            for i in reverse 1..10 by 2 loop
                DBMS_OUTPUT.PUT_LINE('No hay ninguno ' || i);
                EXIT when i in (6,5);
                -- EXIT exterior when x > 1;
                -- if i in (6,5) then goto sigo; end if;
            end loop;
            DBMS_OUTPUT.PUT_LINE('Terminada la vuelta ' || x);
        end loop;
    else 
        DBMS_OUTPUT.PUT_LINE('Hay demasiados');
    end if;
        DBMS_OUTPUT.PUT_LINE('sale bucle');
    <<sigo>>
        DBMS_OUTPUT.PUT_LINE('Terminado');
   
--EXCEPTION
END;

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
-- ROLLBACK;
