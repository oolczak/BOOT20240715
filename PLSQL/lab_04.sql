
DECLARE 
 v_weight    NUMBER(3) := 600; 
 v_message   VARCHAR2(255) := 'Product 10012'; 
 v_new_locn  VARCHAR2(50) := 'falta'; 
BEGIN 
  DECLARE 
   v_weight  NUMBER(3) := 1; 
   v_message   VARCHAR2(255) := 'Product 11001'; 
   v_new_locn  VARCHAR2(50) := 'Europe'; 
  BEGIN 
   v_weight := v_weight + 1; 
   v_new_locn := 'Western ' || v_new_locn; 
 
  END; 
 v_weight := v_weight + 1; 
 v_message := v_message || ' is in stock'; 
 v_new_locn := 'Western ' || v_new_locn; 
 
END; 