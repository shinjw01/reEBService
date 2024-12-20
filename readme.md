<div align="center">

# EBS (E-Book Service)

![](webapp/data/src/logo.png)

</div>

<br/>

## 목차

1. [**서비스 소개**](#1)
2. [**주요 기능 소개**](#2)
3. [**상세 기능 소개**](#3)
4. [**실행 방법**](#4)
5. [**개발 팀 소개 및 역할 분담**](#5)
6. [**개발 기간**](#6)
7. [**발표 자료**](#7)

<br/>

<div id="1"></div>

## 🔎 서비스 소개

회원제로 운영되는 전자도서관.

회원가입시 제공되는 포인트로, 원하는 도서를 장바구니에 담고 구매할 수 있는 서비스.

<br/>

<div id="2"></div>

## 💡 주요 기능 소개

![Alt text](/readme_assets/6.png)
![Alt text](/readme_assets/7.png)
![Alt text](/readme_assets/8.png)

<br/>

<div id="3"></div>

## 🌟 상세 기능 소개

![Alt text](/readme_assets/10.png)
![Alt text](/readme_assets/11.png)
![Alt text](/readme_assets/12.png)
![Alt text](/readme_assets/13.png)
![Alt text](/readme_assets/14.png)

<br/>

<div id="4"></div>

## 💻 실행 방법

> 파일 위치 : 프로젝트/src/main/
> (즉, 프로젝트/src/main/java,프로젝트/src/main/webapp,프로젝트/src/main/readme.txt)

1. webapp/sql 파일 내의 모든 뷰(반드시 뷰 먼저), 프로시저와 함수를 sqlplus에서 등록.

2. `product.csv`를 db에 저장.

3.  MySQL id 수정
- java/model/DatabaseUtil 파일

4. `webapp/main.jsp`에서 실행 시작.

### DB에 product.csv 추가하는 방법

1. 아래 내용을 메모장에 붙여 `product_control.ctl`을 저장한다.

```

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
```

2. CMD에서 sqlldr 실행

```
sqlldr userid=MySQLID/MySQLpassword control='product_control.ctl 절대경로'
```

3. sqlplus에서 데이터를 확인한다.

```
select * from product;
```

<br />

<div id="5"></div>

## 👪 개발 팀 소개 및 역할 분담

|                                               이미지                                                |                                           이름                                           | 개발 내용                                                                                        |
| :-------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------- |
| <img src="https://avatars.githubusercontent.com/u/79428775?v=4" alt="김지현 프로필" width="80px"/>  |   <a href="https://github.com/jh-01" target="_blank">김지현<br></a>    | [FE, BE]장바구니 <br> [FE]결제화면                                                               |
| <img src="https://avatars.githubusercontent.com/u/128569095?v=4" alt="류미성 프로필" width="80px"/> | <a href="https://github.com/misung-dev" target="_blank">류미성<br></a> | [FE, BE] 로그인, 로그아웃, 회원가입 <br> [FE] 상단 메뉴바, 나의 서재, 상품 리스트, 상품 상세정보 |
| <img src="https://avatars.githubusercontent.com/u/69078515?v=4" alt="박지영 프로필" width="80px"/>  |      <a href="https://github.com/pjy2163" target="_blank">박지영<br></a>       | [FE, BE] 환불, 구매 내역 조회<br> [BE] 결제화면                                                  |
| <img src="https://avatars.githubusercontent.com/u/65654552?v=4" alt="신지우 프로필" width="80px"/>  |  <a href="https://github.com/shinjw01" target="_blank">신지우<br></a>  | [FE, BE] 책 읽기 화면 <br> [BE] 상품 리스트, 상품 상세정보 화면, 나의 서재                       |

<br />

<br />

<div id="6"></div>

## 📅 개발 기간

2024년 5월 8일 ~ 2024년 6월 9일 (1개월)

## 📅 리팩토링 기간

2024년 8월 8일 ~ 2024년 8월 15일  (Model, View, Controller로 리팩토링)
<br />
2024년 9월 18일 ~ 2024년 9월 22일 (MySQL로 전환, Front Controller로 리팩토링)
<br />

<div id="7"></div>
