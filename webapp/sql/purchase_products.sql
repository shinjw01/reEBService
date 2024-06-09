
-- 오더아이디 생성을 위해 시퀀스 사용, 함수 작성 전에 먼저 작성해야 됨

CREATE SEQUENCE HISTORY_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;


-- 제품 구매 함수, history 삽입 sql 추가
CREATE OR REPLACE FUNCTION purchase_products(
    p_user_id USERS.user_id%TYPE, 
    p_product_ids SYS.ODCINUMBERLIST 
) RETURN VARCHAR2 IS
    v_price PRODUCT.price%TYPE;
    v_total_price NUMBER := 0;
    v_point USERS.point%TYPE;
    v_remaining_point NUMBER;
    v_order_id NUMBER;
BEGIN
    -- 사용자 포인트 조회
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;

    -- 선택한 각 제품의 가격을 조회하고 총 금액 계산
    FOR i IN 1 .. p_product_ids.COUNT LOOP
        BEGIN
            SELECT price INTO v_price
            FROM PRODUCT
            WHERE product_id = p_product_ids(i);

            v_total_price := v_total_price + v_price;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN '상품 ID ' || p_product_ids(i) || '을(를) 찾을 수 없습니다.';
        END;
    END LOOP;

    -- 포인트가 충분한지 확인
    IF v_point >= v_total_price THEN
        -- 포인트 차감
        UPDATE USERS
        SET point = point - v_total_price
        WHERE user_id = p_user_id;

        -- 트랜잭션 커밋을 위해 주문 ID 먼저 생성
        SELECT HISTORY_SEQ.NEXTVAL INTO v_order_id FROM DUAL;

        -- history 테이블에 제품 값 삽입 & basket 테이블에서 삭제
		FOR i IN 1 .. p_product_ids.COUNT LOOP
    		-- history 테이블에 이미 존재하는지 확인
    		SELECT COUNT(*) INTO v_order_id
    	FROM HISTORY
    		WHERE user_id = p_user_id AND product_id = p_product_ids(i);
    
    		IF v_order_id > 0 THEN
        		-- 존재하면 status_name, created_date, v_order_id 업데이트
       		 UPDATE HISTORY
        		SET status_name = '구매', created_date = SYSTIMESTAMP, order_id = v_order_id
        		WHERE user_id = p_user_id AND product_id = p_product_ids(i);
    		ELSE
        		-- 존재하지 않으면 삽입
        		INSERT INTO HISTORY (order_id, product_id, user_id, created_date, status_name) 
        		VALUES (HISTORY_SEQ.NEXTVAL, p_product_ids(i), p_user_id, SYSTIMESTAMP, '구매');
    		END IF;

    		-- basket 테이블에서 삭제
    		DELETE FROM BASKET WHERE user_id = p_user_id AND product_id = p_product_ids(i);
		END LOOP;


        COMMIT;

        -- 결제 후 남는 포인트 계산
        v_remaining_point := v_point - v_total_price;

        RETURN '결제가 성공적으로 완료되었습니다. 총 금액: ' || v_total_price || ', 결제 후 남는 포인트: ' || v_remaining_point;
    ELSE
        RETURN '포인트가 부족합니다.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '사용자를 찾을 수 없습니다.';
    WHEN OTHERS THEN
        RETURN '오류가 발생했습니다: ' || SQLERRM;
END purchase_products;
/


--실행 예시
DECLARE
    v_result VARCHAR2(200);
    v_product_ids SYS.ODCINUMBERLIST;
BEGIN
    v_product_ids := SYS.ODCINUMBERLIST(1, 2, 3);  -- 예제: 제품 ID 목록
    v_result := purchase_products('JH1234', v_product_ids);  -- 예제: 사용자 ID 1
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/