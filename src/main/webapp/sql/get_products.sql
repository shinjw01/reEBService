DELIMITER //

CREATE PROCEDURE get_products (
    IN u_id VARCHAR(255)  -- MySQL������ IN �Ű������� ���
)
BEGIN
    IF u_id IS NULL THEN
        -- ��ü ��ǰ ��ȸ
        SELECT 
            product_id, 
            product_name, 
            IFNULL(product_image, '/img/No_Image.jpg') AS product_image, 
            author
        FROM 
            PRODUCT;
    ELSE
        -- ������ ��ǰ ��ȸ
        SELECT 
            product_id, 
            product_name, 
            IFNULL(product_image, '/img/No_Image.jpg') AS product_image, 
            author, 
            created_date
        FROM 
            purchased_product
        WHERE 
            user_id = u_id;
    END IF;
END //

DELIMITER ;
