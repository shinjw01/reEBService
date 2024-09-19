LOAD DATA
INFILE 'D:\1Java\2024\EBService\src\main\webapp\data\product.csv'
INTO TABLE PRODUCT
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
product_id          INTEGER EXTERNAL,
product_name        CHAR,
price               INTEGER EXTERNAL,
detail              CHAR,
published_date      DATE "YYYY-MM-DD",
publisher           CHAR,
product_image       CHAR,
author              CHAR
)