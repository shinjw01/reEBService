DELIMITER $$

CREATE PROCEDURE insert_basket(
    IN s_id VARCHAR(64),  -- USERS.user_id%TYPE에 대응
    IN p_id INT,          -- PRODUCT.product_id%TYPE에 대응
    OUT o_code INT        -- OUT 파라미터로 숫자 코드 반환
)
BEGIN
    DECLARE v_count_cart INT DEFAULT 0;
    DECLARE v_count_purchase INT DEFAULT 0;

    -- BASKET 테이블에서 p_id와 s_id가 이미 존재하는지 확인
    SELECT COUNT(*)
    INTO v_count_cart
    FROM BASKET
    WHERE product_id = p_id
    AND user_id = s_id;

    -- HISTORY 테이블에서 p_id와 s_id가 존재하고 status_name = '구매' 인지 확인
    SELECT COUNT(*) 
    INTO v_count_purchase
    FROM HISTORY
    WHERE product_id = p_id
    AND user_id = s_id
    AND status_name = '구매';

    -- 이미 구매한 상품인지 확인
    IF v_count_purchase > 0 THEN
        SET o_code = 3; -- '이미 구매한 상품입니다.'에 대응하는 숫자 코드

    -- 장바구니에 이미 담긴 상품인지 확인
    ELSEIF v_count_cart > 0 THEN
        SET o_code = 2; -- '장바구니에 이미 담긴 상품입니다.'에 대응하는 숫자 코드

    -- 새로운 상품인 경우 삽입
    ELSE
        INSERT INTO BASKET(product_id, user_id)
        VALUES (p_id, s_id);
        SET o_code = 1; -- '장바구니에 성공적으로 추가했습니다.'에 대응하는 숫자 코드
    END IF;

END $$

DELIMITER ;
