CREATE OR REPLACE PROCEDURE check_basket(
    u_id IN VARCHAR2,
    p_id IN NUMBER,
    isInBasket OUT NUMBER
)
IS
    -- �Ķ���͸� ����ϴ� Ŀ�� ����
    CURSOR basket_cursor (c_user_id VARCHAR2, c_product_id NUMBER) IS
        SELECT 1
        FROM BASKET
        WHERE user_id = c_user_id AND product_id = c_product_id;
    v_dummy NUMBER;
BEGIN
    -- Ŀ���� ���� �Ķ���� ���� ����
    OPEN basket_cursor(u_id, p_id);
    FETCH basket_cursor INTO v_dummy;

    -- Ŀ�� ���¿� ���� isInBasket ���� ����
    IF basket_cursor%FOUND THEN
        isInBasket := 1;
    ELSE
        isInBasket := 0;
    END IF;

    -- Ŀ���� ����
    CLOSE basket_cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- ���� ó��
        DBMS_OUTPUT.PUT_LINE('ERR MESSAGE: ' || SQLERRM);
        isInBasket := 0;
END;
/
