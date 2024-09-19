CREATE OR REPLACE PROCEDURE insert_into_cart (
    p_id IN PRODUCT.product_id%TYPE,
    s_id IN USERS.user_id%TYPE,
    o_message OUT VARCHAR2
) AS
    v_count_cart NUMBER;
    v_count_purchase NUMBER;
BEGIN
    -- cart ���̺� �־��� p_id�� s_id�� �����ϴ��� Ȯ��
    SELECT COUNT(*)
    INTO v_count_cart
    FROM BASKET
    WHERE product_id = insert_into_cart.p_id
    AND user_id = insert_into_cart.s_id;

    -- history ���̺� �־��� p_id�� s_id�� �����ϰ�, status_name='����'���� Ȯ��
    SELECT COUNT(*)
    INTO v_count_purchase
    FROM HISTORY
    WHERE product_id = insert_into_cart.p_id
    AND user_id = insert_into_cart.s_id
    AND status_name = '����';

    -- �̹� ������ ��ǰ���� Ȯ��
    IF v_count_purchase > 0 THEN
        o_message := '�̹� ������ ��ǰ�Դϴ�.';
    -- ��ٱ��Ͽ� �̹� ��� ��ǰ���� Ȯ��
    ELSIF v_count_cart > 0 THEN
        o_message := '��ٱ��Ͽ� �̹� ��� ��ǰ�Դϴ�.';
    -- ���ο� ��ǰ�� ��� ����
    ELSE
        INSERT INTO BASKET(product_id, user_id)
        VALUES (insert_into_cart.p_id, insert_into_cart.s_id);
        o_message := '��ٱ��Ͽ� ��ǰ�� ���������� �߰��߽��ϴ�.';
    END IF;
END;
/