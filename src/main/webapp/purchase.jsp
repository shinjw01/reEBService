<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="model.*" %>

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
    <!-- 구매 내역 목록 -->
    <div class="purchase-list-container">
    
<%
    String itemsParam = request.getParameter("products");
    if (itemsParam != null && !itemsParam.isEmpty()) {
    	long totalPrice = 0;
        String[] productIds = itemsParam.split(",");
        for (String productId : productIds) {
            	ProductDTO product = ProductDAO.getProduct(productId);
            	if(product != null){
            		totalPrice += product.getPrice();
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
                } else {
                    out.println("<p>Product ID " + productId + "에 해당하는 상품 정보를 찾을 수 없습니다.</p>");
        		}
    	}
%>
        <!-- 총 금액 및 선택된 항목 목록 -->
        <div class="total-price-container">
            <h3 class="total-price-title">총 금액: <span id="total-price"><%= totalPrice %>원</span></h3>
            <!-- 결제하러 가기 버튼 -->
            <div class="go-to-payment">
                <%
                    // 배열을 문자열로 변환하여 URL 파라미터로 넘기기
                    String productsParam = String.join(",", productIds);
                %>
                <a href="purchase_process.jsp?products=<%= productsParam %>">신청</a>
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

