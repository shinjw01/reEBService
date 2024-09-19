CREATE OR REPLACE PROCEDURE check_basket(
    u_id IN VARCHAR2,
    p_id IN NUMBER,
    isInBasket OUT NUMBER
)
IS
    -- 파라미터를 사용하는 커서 선언
    CURSOR basket_cursor (c_user_id VARCHAR2, c_product_id NUMBER) IS
        SELECT 1
        FROM BASKET
        WHERE user_id = c_user_id AND product_id = c_product_id;
    v_dummy NUMBER;
BEGIN
    -- 커서를 열고 파라미터 값을 전달
    OPEN basket_cursor(u_id, p_id);
    FETCH basket_cursor INTO v_dummy;

    -- 커서 상태에 따라 isInBasket 값을 설정
    IF basket_cursor%FOUND THEN
        isInBasket := 1;
    ELSE
        isInBasket := 0;
    END IF;

    -- 커서를 닫음
    CLOSE basket_cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- 예외 처리
        DBMS_OUTPUT.PUT_LINE('ERR MESSAGE: ' || SQLERRM);
        isInBasket := 0;
END;
/
