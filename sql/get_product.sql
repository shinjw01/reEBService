CREATE OR REPLACE FUNCTION get_product(p_id IN VARCHAR2)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT product_id, product_name, price, detail, published_date, publisher, NVL(product_image, '/img/No_Image.jpg') as product_image, author
        FROM product
        WHERE product_id = p_id;
    RETURN v_cursor;
END;
/
