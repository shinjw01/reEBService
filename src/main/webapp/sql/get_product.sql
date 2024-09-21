DELIMITER $$

CREATE PROCEDURE get_product (
    IN p_id INT,
    OUT p_product_id INT,
    OUT p_product_name VARCHAR(300),
    OUT p_price DECIMAL(11, 2),
    OUT p_detail VARCHAR(600),
    OUT p_published_date DATE,
    OUT p_publisher VARCHAR(90),
    OUT p_product_image VARCHAR(1000),
    OUT p_author VARCHAR(90)
)
BEGIN
    DECLARE no_data_found BOOLEAN DEFAULT FALSE;

    -- 예외 처리를 위해 HANDLER 설정
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET no_data_found = TRUE;

    -- 데이터 조회
    SELECT product_id, product_name, price, detail, published_date, publisher,
           IFNULL(product_image, '/img/No_Image.jpg'), author
    INTO p_product_id, p_product_name, p_price, p_detail, p_published_date, 
         p_publisher, p_product_image, p_author
    FROM product
    WHERE product_id = p_id;

    -- 예외 발생 시 처리
    IF no_data_found THEN
        SET p_product_id = 0;
        SET p_product_name = NULL;
        SET p_price = NULL;
        SET p_detail = NULL;
        SET p_published_date = NULL;
        SET p_publisher = NULL;
        SET p_product_image = NULL;
        SET p_author = NULL;
    END IF;
END $$

DELIMITER ;
