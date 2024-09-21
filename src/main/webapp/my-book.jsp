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
<%
String productId = request.getParameter("product_id");
ProductDTO product = null;
    
  	//session 확인 후 login.jsp로 리다이렉트
  	String userId = null;
    Object userObject = session.getAttribute("user");
    if (userObject instanceof String) {
        userId = (String) userObject;
    }
    else{
%>
    	<script>
    	alert("로그인 후 이용하세요.");
    	location.href = "login.jsp";
    </script>
    <%
    }

            //BasketService.isInHistory() 확인 후 없으면 list.jsp로 리다이렉트
            if (!PurchasedProductDAO.isInHistory(userId, productId)){
    %>
    	<script>
    	alert("잘못된 접근입니다.");
    	location.href = "main.jsp";
    </script>
    <%
    }
        //상품 정보 불러오기
        if (productId != null && !productId.isEmpty()) {
            product = ProductDAO.getProduct(productId);
        }
    %>
    <div class="product-details">
    	<% if (product != null) { %>
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
