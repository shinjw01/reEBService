set serveroutput on;

CREATE OR REPLACE TRIGGER trigger_status
AFTER UPDATE ON history
FOR EACH ROW
BEGIN

    DBMS_OUTPUT.PUT_LINE('���� �� ���� : ' || :OLD.status_name);
    DBMS_OUTPUT.PUT_LINE('���� �� ���� : ' || :NEW.status_name);
END;
/

----���� �ڵ常 SQL�� ������ ��!



--���� ���� 
DECLARE
    user_id VARCHAR2(50) := 'JH1234'; --���� ���̵�
    product_ids SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST(1, 2); //ȯ���� ��ǰID
BEGIN
    refund_products(user_id, product_ids);
END;
/