-- lab_10_01

DECLARE 
   v_today DATE:=SYSDATE; 
   v_tomorrow v_today%TYPE; 
BEGIN 
   v_tomorrow:=v_today +1; 
   DBMS_OUTPUT.PUT_LINE(' Hello World '); 
   DBMS_OUTPUT.PUT_LINE('TODAY IS : '|| v_today); 
   DBMS_OUTPUT.PUT_LINE('TOMORROW IS : ' || v_tomorrow); 
END;
/

DECLARE 
    PROCEDURE local IS
        v_today DATE:=SYSDATE; 
        v_tomorrow v_today%TYPE; 
    BEGIN 
        v_tomorrow:=v_today +1; 
        DBMS_OUTPUT.PUT_LINE(' Hello World '); 
        DBMS_OUTPUT.PUT_LINE('TODAY IS : '|| v_today); 
        DBMS_OUTPUT.PUT_LINE('TOMORROW IS : ' || v_tomorrow); 
    END;
BEGIN
    local;
    local;
END;
/
CREATE OR REPLACE PROCEDURE greet(p_name VARCHAR2) IS
    v_today DATE:=SYSDATE; 
    v_tomorrow v_today%TYPE; 
BEGIN 
    v_tomorrow:=v_today +1; 
    DBMS_OUTPUT.PUT_LINE(' Hello ' || p_name); 
    DBMS_OUTPUT.PUT_LINE('TODAY IS : '|| v_today); 
    DBMS_OUTPUT.PUT_LINE('TOMORROW IS : ' || v_tomorrow); 
END;
--DROP PROCEDURE greet;
/
BEGIN
    greet('Nancy'); 
END;