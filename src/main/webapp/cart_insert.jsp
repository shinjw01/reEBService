<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,model.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>장바구니 추가</title>
</head>
<body>
    <%
        String userId = (String)request.getParameter("user_id");
        String productId = (String)request.getParameter("product_id");

        // 유효성 검사
        if (userId == null || userId.equals("")) {
            out.println("잘못된 요청입니다.");
        } else {
        	int result = BasketDAO.insertBasket(userId, productId);
        	String message = "";
        	switch (result){
        		case 1: message = "장바구니에 성공적으로 추가했습니다"; break;
        		case 2: message = "장바구니에 이미 담긴 상품입니다"; break;
        		case 3: message = "이미 구매한 상품입니다"; break;
        		default : message = "오류가 발생했습니다."; break;
        	}
            out.println("<script>alert('" + message + "'); history.back();</script>");
        }
    %>
</body>
</html>
