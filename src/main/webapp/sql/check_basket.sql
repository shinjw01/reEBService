DELIMITER $$

CREATE PROCEDURE check_basket(
    IN u_id VARCHAR(64),
    IN p_id INT,
    OUT isInBasket INT
)
BEGIN
    DECLARE v_count INT;

    -- ���� ó�� �ڵ鷯
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- ���� �߻� �� ó��
        SET isInBasket = 0;
    END;

    -- ��ٱ��Ͽ� �־��� ���� ID�� ��ǰ ID�� �����ϴ��� Ȯ��
    SELECT COUNT(*)
    INTO v_count
    FROM BASKET
    WHERE user_id = u_id
    AND product_id = p_id;

    -- ���� ���ο� ���� isInBasket �� ����
    IF v_count > 0 THEN
        SET isInBasket = 1;  -- ��ٱ��Ͽ� ����
    ELSE
        SET isInBasket = 0;  -- ��ٱ��Ͽ� ����
    END IF;

END $$

DELIMITER ;
