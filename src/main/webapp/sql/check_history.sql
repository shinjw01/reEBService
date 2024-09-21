DELIMITER $$

CREATE PROCEDURE check_history(
    IN u_id VARCHAR(64),
    IN p_id INT,
    OUT isInHistory INT
)
BEGIN
    DECLARE v_count INT;

    -- 해당 유저와 상품이 history에 있는지 확인
    SELECT COUNT(*)
    INTO v_count
    FROM HISTORY
    WHERE user_id = u_id
    AND product_id = p_id
    AND status_name = '구매';

    -- 결과에 따라 OUT 파라미터에 값을 설정
    IF v_count > 0 THEN
        SET isInHistory = 1; -- 구매 기록이 존재
    ELSE
        SET isInHistory = 0; -- 구매 기록이 없음
    END IF;
    
END $$

DELIMITER ;
