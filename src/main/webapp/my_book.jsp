<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ebook 읽기</title>
    <link rel="stylesheet" href="./css/my-book.css">
</head>
<%@include file="top.jsp"%>

<body>
    <div class="product-details">
        <% ProductDTO product = (ProductDTO) request.getAttribute("product");
           if (product != null) { %>
            <h1><%= product.getName() %></h1>
            <div class="book-info">   
                <img src="./data<%= product.getProduct_image() %>" alt="<%= product.getName() %>">
                <div class="book-details">
                    <h2><%= product.getName() %></h2>
                    <p class="author"><%= product.getAuthor() %></p>
                    <p class="publisher"><%= product.getPublisher() %></p>
                </div>
            </div>
            <div class="line-separator">
                <img src="./src/line-1.png">
            </div>
            <div class="book-description">
                <p><%= product.getDetail() %></p>
            </div>
        <% } else { %>
            <p>책 내용을 불러오지 못했습니다.</p>
        <% } %>
    </div>
</body>
</html>
