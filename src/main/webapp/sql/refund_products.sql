DELIMITER $$

CREATE PROCEDURE refund_products(
    IN p_user_id VARCHAR(64),
    IN p_order_id INT,
    OUT result_message TEXT
)
BEGIN
    -- ���� ����
    DECLARE v_product_id INT;
    DECLARE v_price DECIMAL(11, 2);
    DECLARE v_total_refund DECIMAL(11, 2) DEFAULT 0;
    DECLARE v_point DECIMAL(11, 2);
    DECLARE v_count INT;
    DECLARE done INT DEFAULT FALSE;

    -- Ŀ�� ����
    DECLARE product_cursor CURSOR FOR 
        SELECT product_id FROM HISTORY WHERE user_id = p_user_id AND order_id = p_order_id;

    -- ���� ó�� �ڵ鷯 ����
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET result_message = '������ �߻��߽��ϴ�.';
        ROLLBACK;
    END;

    -- NOT FOUND �ڵ鷯 ����
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- ����� ����Ʈ ��ȸ
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;

    -- Ŀ���� ���� �� product_id�� ��ȸ
    OPEN product_cursor;

    refund_loop: LOOP
        FETCH product_cursor INTO v_product_id;
        IF done THEN
            LEAVE refund_loop;
        END IF;

        -- ��ǰ�� ���� �̷°� ȯ�� ���� Ȯ��
        SELECT COUNT(*) INTO v_count
        FROM HISTORY
        WHERE product_id = v_product_id
        AND user_id = p_user_id
        AND status_name != 'ȯ��';

        IF v_count = 0 THEN
            -- ���� �߻�: ��ǰ�� ȯ�� �Ұ� ������
            SET result_message = CONCAT('��ǰ ID ', v_product_id, '�� ȯ���� �Ұ����մϴ� (���� �̷� ���� Ȥ�� �̹� ȯ�ҵ�).');
            LEAVE refund_loop;
        END IF;

        -- ��ǰ ���� ��ȸ
        SELECT price INTO v_price
        FROM PRODUCT
        WHERE product_id = v_product_id;

        -- ȯ�� �ݾ� ����
        SET v_total_refund = v_total_refund + v_price;

        -- HISTORY ���̺��� ���¸� 'ȯ��'�� ����
        UPDATE HISTORY
        SET status_name = 'ȯ��'
        WHERE user_id = p_user_id
        AND product_id = v_product_id
        AND status_name != 'ȯ��';
    END LOOP;

    CLOSE product_cursor;

    -- ����Ʈ ȯ��
    UPDATE USERS
    SET point = point + v_total_refund
    WHERE user_id = p_user_id;

    -- ��� �޽��� ����
    SET result_message = CONCAT('ȯ���� ���������� �Ϸ�Ǿ����ϴ�. ȯ�� �ݾ�: ', v_total_refund, ', ȯ�� �� ����Ʈ: ', (v_point + v_total_refund));

    -- Ŀ��
    COMMIT;

END $$

DELIMITER ;
