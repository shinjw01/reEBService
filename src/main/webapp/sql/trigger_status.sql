set serveroutput on;

CREATE OR REPLACE TRIGGER trigger_status
AFTER UPDATE ON history
FOR EACH ROW
BEGIN

    DBMS_OUTPUT.PUT_LINE('변경 전 상태 : ' || :OLD.status_name);
    DBMS_OUTPUT.PUT_LINE('변경 후 상태 : ' || :NEW.status_name);
END;
/

----위의 코드만 SQL에 넣으면 됨!



--실행 예시 
DECLARE
    user_id VARCHAR2(50) := 'JH1234'; --유저 아이디
    product_ids SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST(1, 2); //환불할 제품ID
BEGIN
    refund_products(user_id, product_ids);
END;
/