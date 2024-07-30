DECLARE
    TYPE rango IS RECORD (
        DEPARTMENT_ID DEPARTMENTS.DEPARTMENT_ID%TYPE,
        MINIMO employees.SALARY%TYPE,
        MAXIMO employees.SALARY%TYPE
    );
    V_RANGO RANGO DEFAULT RANGO(1, 2, 3);    
    V_RANGO90 RANGO;
    DEPT DEPARTMENTS%ROWTYPE;
BEGIN
    V_RANGO.MAXIMO := 100;
    select DEPARTMENT_ID, MIN(SALARY), MAX(SALARY)
    into V_RANGO
    from EMPLOYEES
    where DEPARTMENT_ID = 20
    GROUP by DEPARTMENT_ID;
    DBMS_OUTPUT.PUT_LINE ('Dept: ' ||  V_RANGO.DEPARTMENT_ID || ' Min: ' || V_RANGO.MINIMO  || ' Max: ' || V_RANGO.MAXIMO);
    select DEPARTMENT_ID, MIN(SALARY), MAX(SALARY)
    into V_RANGO90
    from EMPLOYEES
    where DEPARTMENT_ID = 90
    GROUP by DEPARTMENT_ID;
    DBMS_OUTPUT.PUT_LINE ('Dept: ' ||  V_RANGO90.DEPARTMENT_ID || ' Min: ' || V_RANGO90.MINIMO  || ' Max: ' || V_RANGO90.MAXIMO);
    IF V_RANGO.MINIMO > V_RANGO90.MINIMO THEN
        V_RANGO.MINIMO := V_RANGO90.MINIMO;
    END IF;
    IF V_RANGO.MAXIMO < V_RANGO90.MAXIMO THEN
        V_RANGO.MAXIMO := V_RANGO90.MAXIMO;
    END IF;
    DBMS_OUTPUT.PUT_LINE ('Dept: ' ||  V_RANGO.DEPARTMENT_ID || ' Min: ' || V_RANGO.MINIMO  || ' Max: ' || V_RANGO.MAXIMO);
    select * into dept from DEPARTMENTS where DEPARTMENT_ID = 90;
    DBMS_OUTPUT.PUT_LINE ('Dept: ' ||  DEPT.DEPARTMENT_ID || ' ' || DEPT.DEPARTMENT_NAME  || ' (' || DEPT.LOCATION_ID || ')');
END;
/
select DEPARTMENT_ID, MIN(SALARY), MAX(SALARY)
from EMPLOYEES
-- where DEPARTMENT_ID = 20
GROUP by DEPARTMENT_ID;
/

DECLARE
    TYPE LISTA is table of VARCHAR2(30);
    TYPE MAPA is table of VARCHAR2(30) INDEX BY PLS_INTEGER;
    TYPE DICCIONARIO is table of NUMBER INDEX BY VARCHAR2(50);
    v_list LISTA;
    v_mapa MAPA;
    v_dic DICCIONARIO; 
    v_id DEPARTMENTS.DEPARTMENT_ID%TYPE;
BEGIN
    v_list := LISTA('uno', 'dos', 'tres', 'cuatro');
    -- for i in 1..v_list.count() LOOP
    --     DBMS_OUTPUT.PUT_LINE (i || ': ' || v_list(i));
    -- end loop;
    -- v_list.delete(2);
    -- for i in 1..v_list.count() LOOP
    --     DBMS_OUTPUT.PUT_LINE (i || ': ' || v_list(i));
    -- end loop;
    -- select DEPARTMENT_NAME 
    -- bulk collect into v_list 
    -- from DEPARTMENTS;
    -- for i in 1..v_list.count() LOOP
    --     DBMS_OUTPUT.PUT_LINE (i || ': ' || v_list(i));
    -- end loop;
    v_id := 20;
    select DEPARTMENT_NAME 
    into v_mapa(v_id) 
    from DEPARTMENTS
    WHERE DEPARTMENT_ID = v_id;
    v_id := 90;
    select DEPARTMENT_NAME 
    into v_mapa(v_id) 
    from DEPARTMENTS
    WHERE DEPARTMENT_ID = v_id;
    FOR k,v IN PAIRS OF v_mapa LOOP
        DBMS_OUTPUT.PUT_LINE(k || ' => '|| v);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_mapa(90));

    v_dic('DEPARTMENT_ID') := 90;
    v_dic('MINIMO') := 1000;
    v_dic('MAXIMO') := 6000;

    DBMS_OUTPUT.PUT_LINE ('Dept: ' || v_dic('DEPARTMENT_ID') || ' Min: ' || v_dic('MINIMO')  || ' Max: ' || v_dic('MAXIMO'));
    FOR prop IN INDICES OF v_dic LOOP
        DBMS_OUTPUT.PUT_LINE(prop || ' => '|| v_dic(prop));
    END LOOP;    
END;