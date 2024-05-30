<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="productUtil.Product" %>
<%@ page import="productUtil.ProductService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 상세 정보</title>
    <link rel="stylesheet" href="./css/styles.css">
</head>
<body>
<%
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
                <img id='basket_icon' src="./src/empty_basket.png" alt="Basket Icon" onclick="toggleBasketIcon()">
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
        function toggleBasketIcon() {
            const basket = document.getElementById('basket_icon');
            const icon1 = "./src/empty_basket.png";
            const icon2 = "./src/full_basket.png";
            if (basket.src==icon1) {
                basket.src = icon2;
            } else {
                basket.src = icon1;
            }
        }
    </script>
</body>
</html>
