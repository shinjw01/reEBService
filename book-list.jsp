<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="productUtil.Product" %>
<%@ page import="productUtil.ProductService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EBS | 상품리스트</title>
    <link rel="stylesheet" href="./css/book-list.css" />
    <link rel="stylesheet" href="./css/reset.css" />
    <link rel="stylesheet" href="./css/main.css" />
    <style></style>
</head>
<body>
    <!-- 헤더 -->
    <div class="page-header" id="bookContainer">
        <img src="<%= request.getContextPath() %>/src/logo.png" alt="로고" />
    </div>

    <!-- 헤더 내 유저 정보 & 로그인 버튼 (추가 수정 예정) -->
    <div class="user-container">
        <div class="user-info">
            <p class="user-name"><strong>심준호</strong>님, 환영합니다!</p>
            <p class="user-point">보유포인트 30,000</p>
        </div>
        <button class="login-btn">로그아웃</button>
    </div>

    <!-- 도서 리스트 (추후 리팩터링) -->
    <main class="book-list">
    <%
        	//저장프로시저 : 상품id=>주소, 상품명, 저자명, 이미지 경로=>null처리
            List<Product> productList = ProductService.getAllProducts();
            if (productList != null) {
                for (Product product : productList) {
        %>
        <div class="book-container"
        data-product-id="<%= product.getId() %>">
            <div class="click-to-link">
                <div class="book-image">
                    <img src="./data<%=product.getProduct_image()%>" alt="책 이미지" />
                </div>
                <h3 class="title"><%= product.getName() %></h3>
                <p class="author"><%= product.getAuthor() %></p>
                <div class="btn-container">
                    <div class="detail-btn">
                        <button class="detail-view-link" >상세보기</button>
                    </div>
                    <div class="cart-btn">
                        <button class="add-to-cart-btn">장바구니 담기</button>
                    </div>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
                <div>No products available</div>
        <%
            }
        %>
    </main>

    <!-- 알림창 -->
    <div class="notification" id="notification">장바구니에 담았습니다</div>

    <!-- 자바스크립트  -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 장바구니담기 버튼 클릭시, 화면 하단에 알림창
            const cartButtons = document.querySelectorAll(".add-to-cart-btn");
            const notification = document.getElementById("notification");

            cartButtons.forEach((button) => {
                button.addEventListener("click", function () {
                    notification.style.display = "block";
                    setTimeout(() => {
                        notification.style.display = "none";
                    }, 1000);
                });
            });

            // 상세보기 버튼 클릭시, 해당 페이지로 이동
            const detailViewButtons = document.querySelectorAll(".detail-view-link");

            detailViewButtons.forEach((button) => {
                button.addEventListener("click", function () { 
                	const bookContainer = button.closest('.book-container');
                    const productId = bookContainer.dataset.productId;
                    window.location.href = './book-detail.jsp?product_id='+productId;                
                });
            });
        });
    </script>
</body>
</html>