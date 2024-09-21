<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Purchase Processing</title>
</head>
<body>
<%
    String userId = (String) session.getAttribute("user");
    String itemsParam = request.getParameter("products");

    if (userId == null || itemsParam == null) {
        out.println("유효한 사용자 ID 또는 제품 목록이 없습니다.");
        return;
    }

    String[] productIds = itemsParam.split(",");
    String resultMessage = ProductDAO.purchaseProduct(userId, productIds);
    session.setAttribute("points", UserDAO.getUserPoint(userId));
%>
<script>
    alert('<%= resultMessage%>');
    location.href="purchase_list.jsp";
</script>
</body>
</html>