CREATE OR REPLACE PROCEDURE refund_products (
    p_user_id USERS.user_id%TYPE,
    p_order_id HISTORY.order_id%TYPE
) IS
    TYPE t_product_ids IS TABLE OF NUMBER;
    v_product_ids t_product_ids;
    v_price PRODUCT.price%TYPE;
    v_total_refund NUMBER := 0;
    v_point USERS.point%TYPE;
    v_count NUMBER;
BEGIN
    -- 사용자 포인트 조회
    
    SELECT point INTO v_point
    FROM USERS
    WHERE user_id = p_user_id;
    
    --해당 user가 해당 oder_id에서 주문한 제품id
    SELECT product_id
    BULK COLLECT INTO v_product_ids
    FROM HISTORY
    WHERE user_id = p_user_id
    AND order_id = p_order_id;

    FOR i IN 1 .. v_product_ids.COUNT LOOP
        -- 제품의 구매 이력과 환불 여부 확인
        SELECT COUNT(*)
        INTO v_count
        FROM HISTORY
        WHERE product_id = v_product_ids(i)
          AND status_name != '환불';

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, '제품 ID ' || v_product_ids(i) || '는 환불이 불가능합니다 (구매 이력 없음 혹은 이미 환불됨).');
        END IF;

        -- 제품 가격 조회
        SELECT price INTO v_price
        FROM PRODUCT
        WHERE product_id = v_product_ids(i);

        -- 환불 금액 누적
        v_total_refund := v_total_refund + v_price;

        -- HISTORY 테이블의 상태를 '환불'로 변경
        UPDATE HISTORY
        SET status_name = '환불'
        WHERE user_id = p_user_id
          AND product_id = v_product_ids(i)
          AND status_name != '환불';
    END LOOP;

    -- 포인트 환불
    UPDATE USERS
    SET point = point + v_total_refund
    WHERE user_id = p_user_id;

    COMMIT;

    -- 결과 메시지 
    DBMS_OUTPUT.PUT_LINE('환불이 성공적으로 완료되었습니다. 환불 금액: ' || v_total_refund || ', 환불 후 포인트: ' || (v_point + v_total_refund));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('사용자를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END;
/
