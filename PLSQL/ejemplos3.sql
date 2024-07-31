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
    --v_list := LISTA(FOR i IN 1..10 => RPAD('*', i, '*'));
    for i in 1..v_list.count() LOOP
        DBMS_OUTPUT.PUT_LINE (i || ': ' || v_list(i));
    end loop;
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
    v_mapa(0) := 'Ninguno';
    v_mapa(-90) := '--------';
    FOR k,v IN PAIRS OF v_mapa LOOP
        DBMS_OUTPUT.PUT_LINE(k || ' => '|| v);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_mapa(90));

    v_dic('DEPARTMENT_ID') := 90;
    v_dic('MINIMO') := 1000;
    v_dic('MAXIMO') := 6000;

    DBMS_OUTPUT.PUT_LINE ('Dept: ' || v_dic('DEPARTMENT_ID') || ' Min: ' || v_dic('MINIMO')  || ' Max: ' || v_dic('MAXIMO'));
    v_dic := DICCIONARIO('DEPARTMENT_ID' => 190, 'MINIMO' => 11000, 'MAXIMO' => 16000);
    FOR prop IN INDICES OF v_dic LOOP
        DBMS_OUTPUT.PUT_LINE(prop || ' => '|| v_dic(prop));
    END LOOP;    
END;

/

DECLARE
    CURSOR cur_dept IS select * from DEPARTMENTS;
    v_dept DEPARTMENTS%ROWTYPE;
BEGIN
    OPEN cur_dept;
    -- FETCH cur_dept INTO v_dept;
    -- WHILE cur_dept%found loop 
    --     DBMS_OUTPUT.PUT_LINE ('Dept: ' ||  v_dept.DEPARTMENT_ID || ' ' || v_dept.DEPARTMENT_NAME  || ' (' || v_dept.LOCATION_ID || ')');
    --     FETCH cur_dept INTO v_dept;
    -- end loop;
    loop 
        FETCH cur_dept INTO v_dept;
        EXIT when cur_dept%notfound;
        DBMS_OUTPUT.PUT_LINE ('Dept: ' ||  v_dept.DEPARTMENT_ID || ' ' || v_dept.DEPARTMENT_NAME  || ' (' || v_dept.LOCATION_ID || ')');
    end loop;
    CLOSE cur_dept;
END;

/

DECLARE
    v_dept DEPARTMENTS%ROWTYPE;
BEGIN
    for v_dept in (select * from DEPARTMENTS) loop
        DBMS_OUTPUT.PUT_LINE ('Dept: ' ||  v_dept.DEPARTMENT_ID || ' ' || v_dept.DEPARTMENT_NAME  || ' (' || v_dept.LOCATION_ID || ')');
    end loop;
END;

/
DECLARE
    not_blank_excetion EXCEPTION;
    v_last_name employees.last_name%type; -- default 'King';
BEGIN
    <<reintenta>>
    DECLARE
        v_id employees.employee_id%type;
    BEGIN
        if(v_last_name is null or LENGTH(TRIM(v_last_name)) = 0) THEN
            --RAISE not_blank_excetion;
            raise_application_error (-20001, 'El last_name tiene que tener valor');
        end if;
        SELECT employee_id
        into v_id
        FROM employees
        WHERE last_name = v_last_name;
        DBMS_OUTPUT.PUT_LINE ('-----------Dept: ' ||  v_id);
    EXCEPTION
        WHEN TOO_MANY_ROWS OR INVALID_CURSOR THEN
            DBMS_OUTPUT.PUT_LINE ('ERROR: Your SELECT statement retrieved multiple rows. Consider using a cursor.');
            v_last_name := 'Davies';  
            goto reintenta;
    END;
    DBMS_OUTPUT.PUT_LINE ('Terminado');
EXCEPTION
    WHEN not_blank_excetion THEN
        DBMS_OUTPUT.PUT_LINE ('ERROR:  No puede estar en blanco');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE ('ERROR:  Not Data Found');
    WHEN OTHERS THEN
        ROLLBACK;
        if SQLCODE = -20001 THEN
            DBMS_OUTPUT.PUT_LINE (SQLCODE || '------>' || SQLERRM);
        else
            DBMS_OUTPUT.PUT_LINE ('ERROR: ' || SQLCODE || '-' || SQLERRM);
        end if;
 --     error_code := SQLCODE ;
--     error_message := SQLERRM ;
--    INSERT INTO errors (e_user, e_date, error_code,
--    error_message) VALUES(USER,SYSDATE,error_code, 
--    error_message);

END;
/
CREATE FUNCTION check_sal(p_empno employees.employee_id%TYPE) RETURN Boolean IS
 v_dept_id employees.department_id%TYPE;
 v_sal     employees.salary%TYPE;
 v_avg_sal employees.salary%TYPE;
BEGIN
 SELECT salary,department_id INTO v_sal,v_dept_id FROM employees
   WHERE employee_id=p_empno;
 SELECT avg(salary) INTO v_avg_sal FROM employees 
   WHERE department_id=v_dept_id;
 IF v_sal > v_avg_sal THEN
  RETURN TRUE;
 ELSE
  RETURN FALSE;  
 END IF;
END;
/
-- runner for ALUMNO.SECURE_DML
SET SERVEROUTPUT ON
BEGIN
  ALUMNO.SECURE_DML();
  -- Rollback;
  SELECT check_sal(employee_id)
  from employees;
end;
/

DECLARE 
    TYPE LISTA is table of departments.department_id%TYPE;
    CURSOR  c_emp_cursor(v_deptno NUMBER) IS 
        SELECT last_name, salary, manager_id 
        FROM   employees 
        WHERE  department_id = v_deptno;
    v_departments LISTA DEFAULT LISTA(10,20,50,80);
    create function salario_anual(salario number(8,2)) return number(8,2) 
    as 
    begin
        return salario * 12; 
    end;

BEGIN 
    FOR i IN 1..v_departments.count() LOOP
        DBMS_OUTPUT.PUT_LINE ('Departamento: ' || v_departments(i)); 
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------'); 
        FOR emp_record IN c_emp_cursor(v_departments(i)) LOOP 
            IF check_sal(emp_record.manager_id) THEN 
                DBMS_OUTPUT.PUT_LINE ('    ' || emp_record.last_name || ' Debería recibir un aumento'); 
            ELSE 
                DBMS_OUTPUT.PUT_LINE ('    ' || emp_record.last_name || ' NO debería recibir un aumento'); 
            END IF; 
        END LOOP; 
    END LOOP; 
END; 