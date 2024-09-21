DELIMITER $$

CREATE PROCEDURE insert_basket(
    IN s_id VARCHAR(64),  -- USERS.user_id%TYPE�� ����
    IN p_id INT,          -- PRODUCT.product_id%TYPE�� ����
    OUT o_code INT        -- OUT �Ķ���ͷ� ���� �ڵ� ��ȯ
)
BEGIN
    DECLARE v_count_cart INT DEFAULT 0;
    DECLARE v_count_purchase INT DEFAULT 0;

    -- BASKET ���̺��� p_id�� s_id�� �̹� �����ϴ��� Ȯ��
    SELECT COUNT(*)
    INTO v_count_cart
    FROM BASKET
    WHERE product_id = p_id
    AND user_id = s_id;

    -- HISTORY ���̺��� p_id�� s_id�� �����ϰ� status_name = '����' ���� Ȯ��
    SELECT COUNT(*) 
    INTO v_count_purchase
    FROM HISTORY
    WHERE product_id = p_id
    AND user_id = s_id
    AND status_name = '����';

    -- �̹� ������ ��ǰ���� Ȯ��
    IF v_count_purchase > 0 THEN
        SET o_code = 3; -- '�̹� ������ ��ǰ�Դϴ�.'�� �����ϴ� ���� �ڵ�

    -- ��ٱ��Ͽ� �̹� ��� ��ǰ���� Ȯ��
    ELSEIF v_count_cart > 0 THEN
        SET o_code = 2; -- '��ٱ��Ͽ� �̹� ��� ��ǰ�Դϴ�.'�� �����ϴ� ���� �ڵ�

    -- ���ο� ��ǰ�� ��� ����
    ELSE
        INSERT INTO BASKET(product_id, user_id)
        VALUES (p_id, s_id);
        SET o_code = 1; -- '��ٱ��Ͽ� ���������� �߰��߽��ϴ�.'�� �����ϴ� ���� �ڵ�
    END IF;

END $$

DELIMITER ;
