<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>구매</title>
    <link rel="stylesheet" type="text/css" href="./css/reset.css" />
    <link rel="stylesheet" type="text/css" href="./css/global.css" />
    <link rel="stylesheet" type="text/css" href="./css/purchase.css?after" />
</head>
<body>
    <%@include file="top.jsp"%>
<h2 class="purchase-title">구매</h2>
<div class="purchase-container">
    <div class="purchase-list-container">
        <% 
            List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
            long totalPrice = (long) request.getAttribute("totalPrice");

            if (products != null && !products.isEmpty()) {
                for (ProductDTO product : products) {
        %>
                    <div class="purchase-list">
                        <div class="book-img">
                            <img src="<%= request.getContextPath() %>/data<%= product.getProduct_image() %>" alt="책 이미지"/>
                        </div>
                        <div class="book-info">
                            <div class="book-title"><%= product.getName() %></div>
                            <div class="book-price"><%= product.getPrice() %>원</div>
                        </div>
                    </div>
        <% 
                } 
        %>
            <div class="total-price-container">
                <h3 class="total-price-title">총 금액: <span id="total-price"><%= totalPrice %>원</span></h3>
                <div class="go-to-payment">
                    <a href="purchase_process.do?action=purchase">신청</a>
                </div>
            </div>
        <% 
            } else {
                out.println("<p>선택된 항목이 없습니다.</p>");
            }
        %>
    </div>
</div>
</body>
</html>
