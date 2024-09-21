DELIMITER //

CREATE PROCEDURE get_products (
    IN u_id VARCHAR(255)  -- MySQL에서는 IN 매개변수만 사용
)
BEGIN
    IF u_id IS NULL THEN
        -- 전체 상품 조회
        SELECT 
            product_id, 
            product_name, 
            IFNULL(product_image, '/img/No_Image.jpg') AS product_image, 
            author
        FROM 
            PRODUCT;
    ELSE
        -- 구매한 상품 조회
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
