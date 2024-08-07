-- lab_09_01
SELECT SALARY, count(*) FROM EMPLOYEES GROUP BY SALARY ORDER BY 2;
/
declare
    TYPE LISTA is table of employees.salary%TYPE;
    v_lista LISTA DEFAULT LISTA(2000, 4400, 6000, -1000, 24000);
begin
    for v_salary in values of v_lista loop
        declare
            v_ename   employees.last_name%type;
            v_emp_sal employees.salary%type;
        begin
            if v_salary < 0 then
                v_emp_sal := v_salary / 0;
            end if;
            v_emp_sal := v_salary;
            select last_name
            into v_ename
            from employees
            where salary = v_emp_sal;
            insert into messages ( results ) values ( v_ename || ' - ' || v_emp_sal );
        exception
            when no_data_found then
                insert into messages ( results ) values ( 'No employee with a salary of ' || to_char(v_emp_sal) );
            when too_many_rows then
                insert into messages ( results ) values ( 'More than one employee with a salary of ' || to_char(v_emp_sal) );
            when others then
                insert into messages ( results ) values ( 'Some other error occurred.' );
        end;
    end loop;
end;
/
select *  from messages order by 1 desc;
--ROLLBACK;
/
-- lab_09_02
DECLARE   
    e_childrecord_exists EXCEPTION; 
    PRAGMA EXCEPTION_INIT(e_childrecord_exists, -02292);
BEGIN 
    DBMS_OUTPUT.PUT_LINE(' Deleting department 40........'); 
    delete from departments where department_id=40; 
EXCEPTION 
    WHEN e_childrecord_exists THEN 
        DBMS_OUTPUT.PUT_LINE('ERROR: Cannot delete this department. There are employees in this department (child records exist.) '); 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ('ERROR: ' || SQLERRM);
END;
/