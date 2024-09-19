--stored procedure, callable statement, nulló��, if, join, view
CREATE OR REPLACE PROCEDURE get_products (
    u_id IN VARCHAR2,
    v_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    IF u_id IS NULL  THEN --��ü ��ǰ ��ȸ
        OPEN v_cursor FOR
            SELECT 
                product_id, 
                product_name, 
                NVL(product_image, '/img/No_Image.jpg') AS product_image, 
                author
            FROM 
                PRODUCT;
    ELSE -- ������ ��ǰ ��ȸ
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