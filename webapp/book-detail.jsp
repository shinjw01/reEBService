<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EBS | 상품리스트</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/book-detail.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reset.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css" />
</head>
<%@include file="top.jsp"%>
<body>
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

if (product == null) {
%>
<p>상품 정보를 불러오지 못했습니다.</p>
<%
} else {
%>
<div>
    <h2 class="book-detail-container">도서 상세 정보</h2>
    <div class="book-container">
        <div class="book-image">
            <img src="./data<%= product.getProduct_image() %>" alt="<%= product.getName() %>">
        </div>
        <div class="book-info">
            <div class="book-title"><%= product.getName() %></div>
            <div class="book-author"><%= product.getAuthor() %></div>
            <div class="book-publisher"><%= product.getPublisher() %></div>
            <div class="book-price"><%= product.getPrice() %>원</div>
            <div class="add-to-cart">
                <button class="add-to-cart-button" data-product-id="<%= product.getId() %>" data-user-id="<%= userId %>">
                <% if (userId == null) { %>
                    <p>로그인 후 이용</p>
                <% } else if (BasketService.isInHistory(userId, product.getId())) { %>
                    <p>구매 완료</p>
                <% } else if (BasketService.isInBasket(userId, product.getId())) { %>
                    <img
                        src="<%= request.getContextPath() %>/src/full_basket.png"
                        alt="shopping-cart-icon"
                        class="shopping-cart-icon"
                    />
                    <p>장바구니에 이미 담긴 상품입니다.</p>
                <% } else { %>
                    <img
                        src="<%= request.getContextPath() %>/src/empty_basket.png"
                        alt="shopping-cart-icon"
                        class="shopping-cart-icon"
                    />
                    <p>장바구니 담기</p>
                <% } %>
                </button>
            </div>
        </div>
    </div>
    <hr />
    <div class="book-description">
        <p><%= product.getDetail() %></p>
    </div>
</div>
<% } %>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const cartButtons = document.querySelectorAll(".add-to-cart-button");
    cartButtons.forEach(button => {
        button.addEventListener("click", async function () {
            const productId = button.dataset.productId;
            const userId = button.dataset.userId;
            const icon = button.querySelector(".shopping-cart-icon");
            const currentIconSrc = icon.src.split('/').pop();
            
            const url = 'cart_insert.jsp';
            const formData = new URLSearchParams();
            formData.append('product_id', productId);
            formData.append('user_id', userId);

            try {
                const response = await fetch(url, {
                    method: 'POST',
                    body: formData
                });

                const text = await response.text();
                console.log('Response text:', text);

                // 서버에서 반환된 메시지를 기반으로 이미지 업데이트
                if (text.includes("성공적으로")) {
                	icon.src = "<%= request.getContextPath() %>/src/full_basket.png";
                    button.querySelector("p").textContent = "장바구니에 이미 담긴 상품입니다.";
                } else {
                    alert('장바구니에 이미 담긴 상품입니다.');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('장바구니 업데이트 중 오류가 발생했습니다.');
            }
        });
    });
});
</script>

</body>
</html>
