<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, java.util.List" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EBS | 나의 서재</title>
    <link rel="stylesheet" href="./css/my-library.css" />
    <link rel="stylesheet" href="./css/reset.css" />
    <link rel="stylesheet" href="./css/main.css" />
</head>
<body>
<%@include file="top.jsp"%>

<h2 class="my-library-title">나의 서재</h2>
<p class="my-library-description">구매한 도서 목록을 확인해보세요</p>

<main class="book-list">
    <%
    List<PurchasedProductDTO> productList = (List<PurchasedProductDTO>) request.getAttribute("productList");
    if (productList != null && !productList.isEmpty()) {
        for (PurchasedProductDTO product : productList) {
    %>
        <div class="book-container" data-product-id="<%= product.getId() %>">
            <div class="purchase-date">
                <p><%= product.getPurchased_date() %></p>
            </div>
            <div class="book-image">
                <img src="./data<%= product.getProduct_image() %>" alt="책 이미지" />
            </div>
            <h3 class="title"><%= product.getName() %></h3>
            <p class="author"><%= product.getAuthor() %></p>
            <div class="cart-btn">
                <button class="add-to-cart-btn">내용 보기</button>
            </div>
        </div>
    <%
        }
    } else {
    %>
        <div>구매한 책이 없습니다.</div>
    <%
    }
    %>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const detailViewButtons = document.querySelectorAll(".add-to-cart-btn");

        detailViewButtons.forEach((button) => {
            button.addEventListener("click", function () {
                const bookContainer = button.closest('.book-container');
                const productId = bookContainer.dataset.productId;
                window.location.href = './my_book.do?action=purchasedProduct&productId=' + productId;
            });
        });
    });
</script>
</body>
</html>
