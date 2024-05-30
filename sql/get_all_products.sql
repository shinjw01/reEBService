
CREATE OR REPLACE PROCEDURE get_all_products (v_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN v_cursor FOR
        SELECT product_id, product_name, NVL(product_image, '/img/No_Image.jpg') as product_image, author
        FROM product;
END;

