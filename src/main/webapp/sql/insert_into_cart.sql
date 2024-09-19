CREATE OR REPLACE PROCEDURE insert_into_cart (
    p_id IN PRODUCT.product_id%TYPE,
    s_id IN USERS.user_id%TYPE,
    o_message OUT VARCHAR2
) AS
    v_count_cart NUMBER;
    v_count_purchase NUMBER;
BEGIN
    -- cart 테이블에 주어진 p_id와 s_id가 존재하는지 확인
    SELECT COUNT(*)
    INTO v_count_cart
    FROM BASKET
    WHERE product_id = insert_into_cart.p_id
    AND user_id = insert_into_cart.s_id;

    -- history 테이블에 주어진 p_id와 s_id가 존재하고, status_name='구매'인지 확인
    SELECT COUNT(*)
    INTO v_count_purchase
    FROM HISTORY
    WHERE product_id = insert_into_cart.p_id
    AND user_id = insert_into_cart.s_id
    AND status_name = '구매';

    -- 이미 구매한 상품인지 확인
    IF v_count_purchase > 0 THEN
        o_message := '이미 구매한 상품입니다.';
    -- 장바구니에 이미 담긴 상품인지 확인
    ELSIF v_count_cart > 0 THEN
        o_message := '장바구니에 이미 담긴 상품입니다.';
    -- 새로운 상품인 경우 삽입
    ELSE
        INSERT INTO BASKET(product_id, user_id)
        VALUES (insert_into_cart.p_id, insert_into_cart.s_id);
        o_message := '장바구니에 상품을 성공적으로 추가했습니다.';
    END IF;
END;
/