<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="model.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EBS | 상품리스트</title>
    <link rel="stylesheet" href="./css/reset.css" />
    <link rel="stylesheet" href="./css/global.css" />
	<link rel="stylesheet" href="./css/mainPage.css" />
</head>
<body>
    <%@include file="top.jsp"%>

    <main class="book-list">
    <%
        List<ProductDTO> productList = (List<ProductDTO>) request.getAttribute("productList");
        String userId = (String) session.getAttribute("userId");

        if (productList != null) {
            for (ProductDTO product : productList) {
    %>
        <div class="book-container" data-product-id="<%= product.getId() %>">
            <div class="click-to-link">
                <div class="book-image">
                    <img src="./data<%= product.getProduct_image() %>" alt="책 이미지" />
                </div>
                <h3 class="title"><%= product.getName() %></h3>
                <p class="author"><%= product.getAuthor() %></p>
                <div class="btn-container">
                    <div class="detail-btn">
                        <button class="detail-view-link">상세보기</button>
                    </div>
                    <div class="cart-btn">
                        <% if (userId == null) { %>
                            <button class="cart-btn" disabled>로그인 후 이용</button>
                        <% } else if (product.isPurchased()) { %>
                            <button class="cart-btn" disabled>구매 완료</button>
                        <% } else if (product.isInBasket()) { %>
                            <button class="cart-btn" disabled>장바구니에 있음</button>
                        <% } else { %>
                            <button class="cart-btn add-to-cart-btn" data-action="add">장바구니 담기</button>
                        <% } %>
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
    <div class="notification" id="notification-success">장바구니에 담았습니다</div>
	<div class="notification" id="notification-failed">장바구니에 이미 있습니다</div>
    <!-- 자바스크립트  -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    const disabledButtons = document.querySelectorAll("button:disabled");
    disabledButtons.forEach((button) => {
        button.style.backgroundColor = '#ccc';
        button.style.color = '#666';
        button.style.cursor = 'not-allowed';
    });
});
document.addEventListener("DOMContentLoaded", function () {
    const cartButtons = document.querySelectorAll(".add-to-cart-btn");
    const notification_success = document.getElementById("notification-success");
    const notification_failed = document.getElementById("notification-failed");

    cartButtons.forEach((button) => {
        button.addEventListener("click", async function () {
            const bookContainer = button.closest('.book-container');
            const productId = bookContainer.dataset.productId;
            const action = button.dataset.action;

            const url = 'cart_insert.do?action=basketInsertion';
            const formData = new URLSearchParams();
            formData.append('userId', '<%= userId %>');
            formData.append('productId', productId);

            try {
                const response = await fetch(url, {
                    method: 'POST',
                    body: formData
                });

                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }

                const text = await response.text();
                console.log('Response text:', text);

                if (text.includes("성공적으로")) {
                   	button.textContent = "장바구니에 있음";

                    notification_success.style.display = "block";
                    setTimeout(() => {
                    	notification_success.style.display = "none";
                    }, 1000);
                }
                else{
                	notification_failed.style.display = "block";
                    setTimeout(() => {
                    	notification_failed.style.display = "none";
                    }, 1000);
                }
            } catch (error) {
                console.error('Fetch error:', error);
            }
        });
    });

    const detailViewButtons = document.querySelectorAll(".detail-view-link");

    detailViewButtons.forEach((button) => {
        button.addEventListener("click", function () {
            const bookContainer = button.closest('.book-container');
            const productId = bookContainer.dataset.productId;
            window.location.href = './book_detail.do?action=product&productId=' + productId;
        });
    });
});
</script>


</body>
</html>