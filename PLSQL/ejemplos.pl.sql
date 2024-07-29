DECLARE
    v_nombre VARCHAR2(100); -- not null; -- default 'Mundo';
    v_LAST_NAME EMPLOYEES.FIRST_NAME%TYPE;
    v_cuantos NUMBER;
    total NUMBER;
BEGIN
    --DBMS_OUTPUT.PUT_LINE('Hola ' || v_nombre);
    --v_nombre := 'tu';
    select count(*)
    into v_cuantos
    from EMPLOYEES 
    where EMPLOYEE_ID = 1203;
    DBMS_OUTPUT.PUT_LINE('Cuantos: ' || v_cuantos);
    v_cuantos := 1.2;
    select FIRST_NAME, LAST_NAME || v_LAST_NAME, SALARY * v_cuantos
    into v_nombre, v_LAST_NAME, total
    from EMPLOYEES 
    where EMPLOYEE_ID = 203;
    DBMS_OUTPUT.PUT_LINE('Hola ' || nvl(v_nombre, '(anonimo)') || ' tu salario es ' || total);
--EXCEPTION
END;
