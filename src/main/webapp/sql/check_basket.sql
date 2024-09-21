DELIMITER $$

CREATE PROCEDURE check_basket(
    IN u_id VARCHAR(64),
    IN p_id INT,
    OUT isInBasket INT
)
BEGIN
    DECLARE v_count INT;

    -- 예외 처리 핸들러
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- 예외 발생 시 처리
        SET isInBasket = 0;
    END;

    -- 장바구니에 주어진 유저 ID와 제품 ID가 존재하는지 확인
    SELECT COUNT(*)
    INTO v_count
    FROM BASKET
    WHERE user_id = u_id
    AND product_id = p_id;

    -- 존재 여부에 따라 isInBasket 값 설정
    IF v_count > 0 THEN
        SET isInBasket = 1;  -- 장바구니에 존재
    ELSE
        SET isInBasket = 0;  -- 장바구니에 없음
    END IF;

END $$

DELIMITER ;
