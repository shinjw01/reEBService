DELIMITER $$

CREATE PROCEDURE refund_products(
    IN p_user_id VARCHAR(64),
    IN p_order_id INT,
    OUT result_message TEXT
)
BEGIN
    -- 변수 선언
    DECLARE v_product_id INT;
    DECLARE v_price DECIMAL(11, 2);
    DECLARE v_total_refund DECIMAL(11, 2) DEFAULT 0;
    DECLARE v_point DECIMAL(11, 2);
    DECLARE v_count INT;
    DECLARE done INT DEFAULT FALSE;

    -- 커서 선언
    DECLARE product_cursor CURSOR FOR 
        SELECT product_id FROM HISTORY WHERE user_id = p_user_id AND order_id = p_order_id;

    -- 예외 처리 핸들러 선언
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET result_message = '오류가 발생했습니다.';
        ROLLBACK;
    END;

    -- NOT FOUND 핸들러 선언
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 사용자 포인트 조회
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;

    -- 커서를 열고 각 product_id를 조회
    OPEN product_cursor;

    refund_loop: LOOP
        FETCH product_cursor INTO v_product_id;
        IF done THEN
            LEAVE refund_loop;
        END IF;

        -- 제품의 구매 이력과 환불 여부 확인
        SELECT COUNT(*) INTO v_count
        FROM HISTORY
        WHERE product_id = v_product_id
        AND user_id = p_user_id
        AND status_name != '환불';

        IF v_count = 0 THEN
            -- 에러 발생: 제품이 환불 불가 상태임
            SET result_message = CONCAT('제품 ID ', v_product_id, '는 환불이 불가능합니다 (구매 이력 없음 혹은 이미 환불됨).');
            LEAVE refund_loop;
        END IF;

        -- 제품 가격 조회
        SELECT price INTO v_price
        FROM PRODUCT
        WHERE product_id = v_product_id;

        -- 환불 금액 누적
        SET v_total_refund = v_total_refund + v_price;

        -- HISTORY 테이블의 상태를 '환불'로 변경
        UPDATE HISTORY
        SET status_name = '환불'
        WHERE user_id = p_user_id
        AND product_id = v_product_id
        AND status_name != '환불';
    END LOOP;

    CLOSE product_cursor;

    -- 포인트 환불
    UPDATE USERS
    SET point = point + v_total_refund
    WHERE user_id = p_user_id;

    -- 결과 메시지 설정
    SET result_message = CONCAT('환불이 성공적으로 완료되었습니다. 환불 금액: ', v_total_refund, ', 환불 후 포인트: ', (v_point + v_total_refund));

    -- 커밋
    COMMIT;

END $$

DELIMITER ;
