CREATE OR REPLACE PROCEDURE check_history(
    u_id IN VARCHAR2,
    p_id IN NUMBER,
    isInHistory OUT NUMBER
)
IS
    CURSOR history_cursor IS
        SELECT 1
        FROM HISTORY
        WHERE user_id = u_id AND product_id = p_id and status_name = '����';
    v_dummy NUMBER;
BEGIN
    OPEN history_cursor;
    
    LOOP
        FETCH history_cursor INTO v_dummy;
        
        EXIT WHEN history_cursor%FOUND;-- ���ǿ� �´� ���� ã���� ���� ����
        EXIT WHEN history_cursor%NOTFOUND;-- �� �̻� ó���� ���� ������ ���� ����
    END LOOP;
    
    IF history_cursor%FOUND THEN
        isInHistory := 1;
    ELSE
        isInHistory := 0;
    END IF;
    
    CLOSE history_cursor;
END;
/
