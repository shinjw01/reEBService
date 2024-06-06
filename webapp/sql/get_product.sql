--%ROWTYPE
CREATE OR REPLACE PROCEDURE get_product (
    p_id IN NUMBER,
    p_product_id OUT product.product_id%TYPE,
    p_product_name OUT product.product_name%TYPE,
    p_price OUT product.price%TYPE,
    p_detail OUT product.detail%TYPE,
    p_published_date OUT product.published_date%TYPE,
    p_publisher OUT product.publisher%TYPE,
    p_product_image OUT product.product_image%TYPE,
    p_author OUT product.author%TYPE
) IS
    v_product product%ROWTYPE;
BEGIN
    SELECT product_id, product_name, price, detail, published_date, publisher, 
           NVL(product_image, '/img/No_Image.jpg'), author
    INTO v_product
    FROM product
    WHERE product_id = p_id;

    p_product_id := v_product.product_id;
    p_product_name := v_product.product_name;
    p_price := v_product.price;
    p_detail := v_product.detail;
    p_published_date := v_product.published_date;
    p_publisher := v_product.publisher;
    p_product_image := v_product.product_image;
    p_author := v_product.author;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_product_id := NULL;
        p_product_name := NULL;
        p_price := NULL;
        p_detail := NULL;
        p_published_date := NULL;
        p_publisher := NULL;
        p_product_image := NULL;
        p_author := NULL;
END;
/
