DELIMITER $$

CREATE PROCEDURE purchase_product(
    IN p_user_id VARCHAR(64),
    IN p_product_ids TEXT,  -- 쉼표로 구분된 product_ids 문자열
    OUT result_message TEXT  -- 결과 메시지를 반환할 OUT 파라미터
)
BEGIN
    -- 변수 선언
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

    -- 예외 처리 핸들러 선언
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET result_message = '오류가 발생했습니다.';
        ROLLBACK;
    END;

    -- 사용자 포인트 조회
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;

    -- p_product_ids 길이 계산
    SET v_len = LENGTH(p_product_ids);

    -- 각 제품의 가격을 조회하고 총 금액을 계산하는 루프
    WHILE v_pos <= v_len DO
        -- 쉼표로 구분된 product_id 추출
        SET v_product_id_str = SUBSTRING_INDEX(SUBSTRING(p_product_ids, v_pos), ',', 1);
        
        -- 추출된 product_id를 정수형으로 변환
        SET v_product_id = CAST(v_product_id_str AS UNSIGNED);

        -- 제품 가격 조회
        SELECT price INTO v_price
        FROM PRODUCT
        WHERE product_id = v_product_id;

        -- 총 금액 계산
        SET v_total_price = v_total_price + v_price;

        -- 다음 쉼표 위치 계산
        SET v_pos = LOCATE(',', p_product_ids, v_pos) + 1;

        -- 쉼표가 없으면 루프 종료
        IF v_pos = 1 THEN
            SET v_pos = v_len + 1;
        END IF;
    END WHILE;

    -- 포인트가 충분한지 확인
    IF v_point >= v_total_price THEN
        -- 포인트 차감
        UPDATE USERS
        SET point = point - v_total_price
        WHERE user_id = p_user_id;

        -- order_id 생성 (HISTORY 테이블의 order_id는 수동으로 삽입)
        SET v_order_id = (SELECT COALESCE(MAX(order_id), 0) + 1 FROM HISTORY);

        -- p_product_ids에서 각 제품에 대한 히스토리 삽입 루프
        SET v_pos = 1; -- v_pos 초기화
        WHILE v_pos <= v_len DO
            -- 쉼표로 구분된 product_id 추출
            SET v_product_id_str = SUBSTRING_INDEX(SUBSTRING(p_product_ids, v_pos), ',', 1);

            -- 추출된 product_id를 정수형으로 변환
            SET v_product_id = CAST(v_product_id_str AS UNSIGNED);

            -- history 테이블에 이미 존재하는지 확인
            SELECT COUNT(*) INTO v_history_count
            FROM HISTORY
            WHERE user_id = p_user_id AND product_id = v_product_id;

            IF v_history_count > 0 THEN
                -- 존재하면 업데이트
                UPDATE HISTORY
                SET status_name = '구매', created_date = NOW(), order_id = v_order_id
                WHERE user_id = p_user_id AND product_id = v_product_id;
            ELSE
                -- 존재하지 않으면 삽입
                INSERT INTO HISTORY (order_id, product_id, user_id, created_date, status_name) 
                VALUES (v_order_id, v_product_id, p_user_id, NOW(), '구매');
            END IF;

            -- basket 테이블에서 삭제
            DELETE FROM BASKET WHERE user_id = p_user_id AND product_id = v_product_id;

            -- 다음 쉼표 위치 계산
            SET v_pos = LOCATE(',', p_product_ids, v_pos) + 1;

            -- 쉼표가 없으면 루프 종료
            IF v_pos = 1 THEN
                SET v_pos = v_len + 1;
            END IF;
        END WHILE;

        -- 결제 후 남는 포인트 계산
        SET v_remaining_point = v_point - v_total_price;
        SET result_message = CONCAT('결제가 성공적으로 완료되었습니다. 총 금액: ', v_total_price, ', 결제 후 남는 포인트: ', v_remaining_point);
    ELSE
        SET result_message = '포인트가 부족합니다.';
    END IF;

END $$

DELIMITER ;
