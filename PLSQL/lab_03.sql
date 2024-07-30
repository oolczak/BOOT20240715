-- lab_03_03
/*
DECLARE 
  v_fname VARCHAR2(20); 
  v_lname VARCHAR2(15) DEFAULT 'fernandez'; 
BEGIN 
  DBMS_OUTPUT.PUT_LINE(v_fname || ' ' ||v_lname); 
END;
*/

-- lab_03_04
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
-- lab_03_05
VARIABLE b_basic_percent NUMBER 
VARIABLE b_pf_percent NUMBER 

DECLARE 
   v_today DATE:=SYSDATE;
   v_tomorrow v_today%TYPE;
BEGIN 
   v_tomorrow:=v_today +1; 
   DBMS_OUTPUT.PUT_LINE(' Hello World '); 
   DBMS_OUTPUT.PUT_LINE('TODAY IS : '|| v_today); 
   DBMS_OUTPUT.PUT_LINE('TOMORROW IS : ' || v_tomorrow); 
   :b_basic_percent:=45; 
   :b_pf_percent:=12;
END;
/ 
PRINT b_basic_percent 
PRINT b_pf_percent 
