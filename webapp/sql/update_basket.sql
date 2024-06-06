CREATE OR REPLACE PROCEDURE update_basket(
	u_id IN VARCHAR2,
	p_id IN NUMBER,
	inBasket IN NUMBER)
IS
BEGIN
    IF inBasket = 1 THEN
        DELETE FROM basket WHERE user_id = u_id AND product_id = p_id;
    ELSE
        INSERT INTO basket VALUES (u_id, p_id);
    END IF;
END;
/