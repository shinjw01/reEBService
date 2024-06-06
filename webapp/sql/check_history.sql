CREATE OR REPLACE PROCEDURE check_history(
    u_id IN VARCHAR2,
    p_id IN NUMBER,
    isInHistory OUT NUMBER
)
IS
    CURSOR history_cursor IS
        SELECT 1
        FROM HISTORY
        WHERE user_id = u_id AND product_id = p_id;
    v_dummy NUMBER;
BEGIN
    OPEN history_cursor;
    
    LOOP
        FETCH history_cursor INTO v_dummy;
        
        EXIT WHEN history_cursor%FOUND;-- 조건에 맞는 행을 찾으면 루프 종료
        EXIT WHEN history_cursor%NOTFOUND;-- 더 이상 처리할 행이 없으면 루프 종료
    END LOOP;
    
    IF history_cursor%FOUND THEN
        isInHistory := 1;
    ELSE
        isInHistory := 0;
    END IF;
    
    CLOSE history_cursor;
END;
/
