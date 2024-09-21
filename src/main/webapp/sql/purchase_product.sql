DELIMITER $$

CREATE PROCEDURE purchase_product(
    IN p_user_id VARCHAR(64),
    IN p_product_ids TEXT,  -- ��ǥ�� ���е� product_ids ���ڿ�
    OUT result_message TEXT  -- ��� �޽����� ��ȯ�� OUT �Ķ����
)
BEGIN
    -- ���� ����
    DECLARE v_price DECIMAL(11, 2);
    DECLARE v_total_price DECIMAL(11, 2) DEFAULT 0;
    DECLARE v_point INT;
    DECLARE v_remaining_point DECIMAL(11, 2);
    DECLARE v_order_id INT;
    DECLARE v_product_id INT;
    DECLARE v_history_count INT;
    DECLARE v_pos INT DEFAULT 1;
    DECLARE v_len INT;
    DECLARE v_product_id_str VARCHAR(64);

    -- ���� ó�� �ڵ鷯 ����
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET result_message = '������ �߻��߽��ϴ�.';
        ROLLBACK;
    END;

    -- ����� ����Ʈ ��ȸ
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;

    -- p_product_ids ���� ���
    SET v_len = LENGTH(p_product_ids);

    -- �� ��ǰ�� ������ ��ȸ�ϰ� �� �ݾ��� ����ϴ� ����
    WHILE v_pos <= v_len DO
        -- ��ǥ�� ���е� product_id ����
        SET v_product_id_str = SUBSTRING_INDEX(SUBSTRING(p_product_ids, v_pos), ',', 1);
        
        -- ����� product_id�� ���������� ��ȯ
        SET v_product_id = CAST(v_product_id_str AS UNSIGNED);

        -- ��ǰ ���� ��ȸ
        SELECT price INTO v_price
        FROM PRODUCT
        WHERE product_id = v_product_id;

        -- �� �ݾ� ���
        SET v_total_price = v_total_price + v_price;

        -- ���� ��ǥ ��ġ ���
        SET v_pos = LOCATE(',', p_product_ids, v_pos) + 1;

        -- ��ǥ�� ������ ���� ����
        IF v_pos = 1 THEN
            SET v_pos = v_len + 1;
        END IF;
    END WHILE;

    -- ����Ʈ�� ������� Ȯ��
    IF v_point >= v_total_price THEN
        -- ����Ʈ ����
        UPDATE USERS
        SET point = point - v_total_price
        WHERE user_id = p_user_id;

        -- order_id ���� (HISTORY ���̺��� order_id�� �������� ����)
        SET v_order_id = (SELECT COALESCE(MAX(order_id), 0) + 1 FROM HISTORY);

        -- p_product_ids���� �� ��ǰ�� ���� �����丮 ���� ����
        SET v_pos = 1; -- v_pos �ʱ�ȭ
        WHILE v_pos <= v_len DO
            -- ��ǥ�� ���е� product_id ����
            SET v_product_id_str = SUBSTRING_INDEX(SUBSTRING(p_product_ids, v_pos), ',', 1);

            -- ����� product_id�� ���������� ��ȯ
            SET v_product_id = CAST(v_product_id_str AS UNSIGNED);

            -- history ���̺� �̹� �����ϴ��� Ȯ��
            SELECT COUNT(*) INTO v_history_count
            FROM HISTORY
            WHERE user_id = p_user_id AND product_id = v_product_id;

            IF v_history_count > 0 THEN
                -- �����ϸ� ������Ʈ
                UPDATE HISTORY
                SET status_name = '����', created_date = NOW(), order_id = v_order_id
                WHERE user_id = p_user_id AND product_id = v_product_id;
            ELSE
                -- �������� ������ ����
                INSERT INTO HISTORY (order_id, product_id, user_id, created_date, status_name) 
                VALUES (v_order_id, v_product_id, p_user_id, NOW(), '����');
            END IF;

            -- basket ���̺��� ����
            DELETE FROM BASKET WHERE user_id = p_user_id AND product_id = v_product_id;

            -- ���� ��ǥ ��ġ ���
            SET v_pos = LOCATE(',', p_product_ids, v_pos) + 1;

            -- ��ǥ�� ������ ���� ����
            IF v_pos = 1 THEN
                SET v_pos = v_len + 1;
            END IF;
        END WHILE;

        -- ���� �� ���� ����Ʈ ���
        SET v_remaining_point = v_point - v_total_price;
        SET result_message = CONCAT('������ ���������� �Ϸ�Ǿ����ϴ�. �� �ݾ�: ', v_total_price, ', ���� �� ���� ����Ʈ: ', v_remaining_point);
    ELSE
        SET result_message = '����Ʈ�� �����մϴ�.';
    END IF;

END $$

DELIMITER ;
