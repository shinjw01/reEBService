CREATE OR REPLACE PROCEDURE refund_products (
    p_user_id USERS.user_id%TYPE,
    p_order_id HISTORY.order_id%TYPE
) IS
    TYPE t_product_ids IS TABLE OF NUMBER;
    v_product_ids t_product_ids;
    v_price PRODUCT.price%TYPE;
    v_total_refund NUMBER := 0;
    v_point USERS.point%TYPE;
    v_count NUMBER;
BEGIN
    -- ����� ����Ʈ ��ȸ
    
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;
    
    --�ش� user�� �ش� oder_id���� �ֹ��� ��ǰid
    SELECT product_id
    BULK COLLECT INTO v_product_ids
    FROM HISTORY
    WHERE user_id = p_user_id
    AND order_id = p_order_id;

    FOR i IN 1 .. v_product_ids.COUNT LOOP
        -- ��ǰ�� ���� �̷°� ȯ�� ���� Ȯ��
        SELECT COUNT(*)
        INTO v_count
        FROM HISTORY
        WHERE product_id = v_product_ids(i)
          AND status_name != 'ȯ��';

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, '��ǰ ID ' || v_product_ids(i) || '�� ȯ���� �Ұ����մϴ� (���� �̷� ���� Ȥ�� �̹� ȯ�ҵ�).');
        END IF;

        -- ��ǰ ���� ��ȸ
        SELECT price INTO v_price
        FROM PRODUCT
        WHERE product_id = v_product_ids(i);

        -- ȯ�� �ݾ� ����
        v_total_refund := v_total_refund + v_price;

        -- HISTORY ���̺��� ���¸� 'ȯ��'�� ����
        UPDATE HISTORY
        SET status_name = 'ȯ��'
        WHERE user_id = p_user_id
          AND product_id = v_product_ids(i)
          AND status_name != 'ȯ��';
    END LOOP;

    -- ����Ʈ ȯ��
    UPDATE USERS
    SET point = point + v_total_refund
    WHERE user_id = p_user_id;

    COMMIT;

    -- ��� �޽��� 
    DBMS_OUTPUT.PUT_LINE('ȯ���� ���������� �Ϸ�Ǿ����ϴ�. ȯ�� �ݾ�: ' || v_total_refund || ', ȯ�� �� ����Ʈ: ' || (v_point + v_total_refund));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('����ڸ� ã�� �� �����ϴ�.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������ �߻��߽��ϴ�: ' || SQLERRM);
END;
/
