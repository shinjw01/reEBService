-- �������̵� ������ ���� ������ ���, �Լ� �ۼ� ���� ���� �ۼ��ؾ� ��
CREATE SEQUENCE HISTORY_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;

-- ��ǰ ���� �Լ�, history ���� sql �߰�
CREATE OR REPLACE FUNCTION purchase_products(
    p_user_id USERS.user_id%TYPE, 
    p_product_ids SYS.ODCINUMBERLIST 
) RETURN VARCHAR2 IS
    v_price PRODUCT.price%TYPE;
    v_total_price NUMBER := 0;
    v_point USERS.point%TYPE;
    v_remaining_point NUMBER;
    v_order_id NUMBER;
BEGIN
    -- ����� ����Ʈ ��ȸ
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;

    -- ������ �� ��ǰ�� ������ ��ȸ�ϰ� �� �ݾ� ���
    FOR i IN 1 .. p_product_ids.COUNT LOOP
        BEGIN
            SELECT price INTO v_price
            FROM PRODUCT
            WHERE product_id = p_product_ids(i);

            v_total_price := v_total_price + v_price;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN '��ǰ ID ' || p_product_ids(i) || '��(��) ã�� �� �����ϴ�.';
        END;
    END LOOP;

    -- ����Ʈ�� ������� Ȯ��
    IF v_point >= v_total_price THEN
        -- ����Ʈ ����
        UPDATE USERS
        SET point = point - v_total_price
        WHERE user_id = p_user_id;

        -- Ʈ����� Ŀ���� ���� �ֹ� ID ���� ����
        SELECT HISTORY_SEQ.NEXTVAL INTO v_order_id FROM DUAL;

        -- history ���̺� ��ǰ �� ���� & basket ���̺��� ����
        FOR i IN 1 .. p_product_ids.COUNT LOOP
            -- history ���̺� �̹� �����ϴ��� Ȯ��
            DECLARE
                v_history_count NUMBER;
            BEGIN
                SELECT COUNT(*) INTO v_history_count
                FROM HISTORY
                WHERE user_id = p_user_id AND product_id = p_product_ids(i);

                IF v_history_count > 0 THEN
                    -- �����ϸ� status_name, created_date ������Ʈ
                    UPDATE HISTORY
                    SET status_name = '����', created_date = SYSTIMESTAMP, order_id = v_order_id
                    WHERE user_id = p_user_id AND product_id = p_product_ids(i);
                ELSE
                    -- �������� ������ ����
                    INSERT INTO HISTORY (order_id, product_id, user_id, created_date, status_name) 
                    VALUES (v_order_id, p_product_ids(i), p_user_id, SYSTIMESTAMP, '����');
                END IF;

                -- basket ���̺��� ����
                DELETE FROM BASKET WHERE user_id = p_user_id AND product_id = p_product_ids(i);
            END;
        END LOOP;

        COMMIT;

        -- ���� �� ���� ����Ʈ ���
        v_remaining_point := v_point - v_total_price;

        RETURN '������ ���������� �Ϸ�Ǿ����ϴ�. �� �ݾ�: ' || v_total_price || ', ���� �� ���� ����Ʈ: ' || v_remaining_point;
    ELSE
        RETURN '����Ʈ�� �����մϴ�.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '����ڸ� ã�� �� �����ϴ�.';
    WHEN OTHERS THEN
        RETURN '������ �߻��߽��ϴ�: ' || SQLERRM;
END purchase_products;
/

--���� ����
DECLARE
    v_result VARCHAR2(200);
    v_product_ids SYS.ODCINUMBERLIST;
BEGIN
    v_product_ids := SYS.ODCINUMBERLIST(1, 2, 3);  -- ����: ��ǰ ID ���
    v_result := purchase_products('JH1234', v_product_ids);  -- ����: ����� ID 1
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
