<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 상세 정보</title>
    <link rel="stylesheet" href="./css/styles.css">
</head>
<body>
<%@include file="top.jsp"%>
<%
	String userId = null;
	Object userObject = session.getAttribute("user");
	if (userObject instanceof String) {
		userId = (String) userObject;
	}
    String productId = request.getParameter("product_id");
    Product product = null;
    if (productId != null && !productId.isEmpty()) {
        product = ProductService.getProduct(productId);
    }
%>
    <div class="product-details">
        <h1>상품 상세 정보</h1>
        <div class="book-info">
            <% if (product != null) { %>
            <img src="./data<%= product.getProduct_image() %>" alt="<%= product.getName() %>">
            <div class="book-details">
                <h2><%= product.getName() %></h2>
                <p class="author"><%= product.getAuthor() %></p>
                <p class="publisher"><%= product.getPublisher() %></p>
                <p class="price"><%= product.getPrice() %></p>
            </div>
            <div class="basket">
            	<% if (userId == null) {%>
                    <button class="add-to-cart-btn" disabled>로그인 후 이용</button>
                	<% } 
                       else if (BasketService.isInHistory(userId, product.getId())) { %>
                           <button disabled>구매 완료</button>
                       <% } else if (BasketService.isInBasket(userId, product.getId())) { %>
                            <img id='basket_icon' src="./src/full_basket.png" alt="Basket Icon">
                       <% } else { %>
                            <img id='basket_icon' src="./src/empty_basket.png" alt="Basket Icon">
                       <% }%>
            </div>
            <% } else { %>
            <p>상품 정보를 불러오지 못했습니다.</p>
            <% } %>
        </div>
        <div class="line-separator">
            <img src="./src/line-1.png">
        </div>
        <% if (product != null) { %>
        <div class="book-description">
            <p><%= product.getDetail() %></p>
        </div>
        <% } %>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 장바구니 아이콘 클릭시, 이미지 토글 및 서버 요청
            const basketIcon = document.getElementById('basket_icon');
            basketIcon.addEventListener('click', async function () {
                const icon1 = "empty_basket.png";
                const icon2 = "full_basket.png";
                const currentIcon = basketIcon.src.split('/').pop();
                const action = currentIcon === icon1 ? 'add' : 'remove';
                
                // 서버 요청
                try {
                    const response = await fetch('updateBasket.jsp', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: new URLSearchParams({
                            userId: '<%= userId %>',
                            productId: productId,
                            action: action,
                        })
                    });

                    const data = await response.json();

                    if (data.success) {
                        // 이미지 토글
                        if (currentIcon === icon1) {
                            basketIcon.src = "./src/" + icon2;
                        } else {
                            basketIcon.src = "./src/" + icon1;
                        }
                        console.log(basketIcon.src);
                    } else {
                        console.error('Error updating cart:', data.message);
                    }
                } catch (error) {
                    console.error('Error:', error);
                }
            });
        });
        </script>
</body>
</html>
