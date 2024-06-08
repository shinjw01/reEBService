CREATE OR REPLACE VIEW purchased_product AS
SELECT 
    P.product_id, 
    P.product_name, 
    NVL(P.product_image, '/img/No_Image.jpg') AS product_image, 
    P.author, 
    H.created_date,
    H.user_id
FROM 
    PRODUCT P 
JOIN 
    HISTORY H 
ON 
    P.product_id = H.product_id
WHERE 
    H.status_name = '±¸¸Å';