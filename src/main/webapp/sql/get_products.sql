--stored procedure, callable statement, null처리, if, join, view
CREATE OR REPLACE PROCEDURE get_products (
    u_id IN VARCHAR2,
    v_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    IF u_id IS NULL  THEN --전체 상품 조회
        OPEN v_cursor FOR
            SELECT 
                product_id, 
                product_name, 
                NVL(product_image, '/img/No_Image.jpg') AS product_image, 
                author
            FROM 
                PRODUCT;
    ELSE -- 구매한 상품 조회
        OPEN v_cursor FOR
            SELECT 
                product_id, 
                product_name, 
                NVL(product_image, '/img/No_Image.jpg') AS product_image, 
                author, 
                created_date
            FROM 
                purchased_product
            WHERE 
                user_id = u_id;

    END IF;
END;
/