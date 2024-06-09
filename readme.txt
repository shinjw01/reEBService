1.webapp/sql 파일 내의 모든 뷰(반드시 뷰 먼저), 프로시저와 함수를 sqlplus에서 등록.
2.product.csv를 db에 저장.
3. oracle id를 바꾼다.
java/util/DatabaseUtil 파일
webapp/cart_delete.jsp, cart_insert.jsp,login_verify.jsp,purchase_list.jsp,purchase_process.jsp, refund.jsp

4.webapp/main.jsp에서 실행 시작.

product.csv를 db에 넣는 법
1. 아래 내용을 메모장에 붙여 product_control.ctl을 저장한다.
LOAD DATA
INFILE 'EBService\data\product.csv의 절대경로'
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

2. CMD에서 sqlldr 실행한다.
sqlldr userid=오라클ID/오라클password control='product_control.ctl 절대경로'

3. sqlplus에서 데이터를 확인한다.
select * from product;