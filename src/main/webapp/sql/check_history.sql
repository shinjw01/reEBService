DELIMITER $$

CREATE PROCEDURE check_history(
    IN u_id VARCHAR(64),
    IN p_id INT,
    OUT isInHistory INT
)
BEGIN
    DECLARE v_count INT;

    -- �ش� ������ ��ǰ�� history�� �ִ��� Ȯ��
    SELECT COUNT(*)
    INTO v_count
    FROM HISTORY
    WHERE user_id = u_id
    AND product_id = p_id
    AND status_name = '����';

    -- ����� ���� OUT �Ķ���Ϳ� ���� ����
    IF v_count > 0 THEN
        SET isInHistory = 1; -- ���� ����� ����
    ELSE
        SET isInHistory = 0; -- ���� ����� ����
    END IF;
    
END $$

DELIMITER ;
