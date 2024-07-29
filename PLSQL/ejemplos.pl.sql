DECLARE
    v_nombre VARCHAR2(100); -- not null; -- default 'Mundo';
    v_cuantos NUMBER;
BEGIN
    --DBMS_OUTPUT.PUT_LINE('Hola ' || v_nombre);
    --v_nombre := 'tu';
    select count(*)
    into v_cuantos
    from EMPLOYEES 
    where EMPLOYEE_ID = 1203;
    DBMS_OUTPUT.PUT_LINE('Cuantos: ' || v_cuantos);
    select FIRST_NAME
    into v_nombre
    from EMPLOYEES 
    where EMPLOYEE_ID = 203;
    DBMS_OUTPUT.PUT_LINE('Hola ' || nvl(v_nombre, '(anonimo)'));
--EXCEPTION
END;
