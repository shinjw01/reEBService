<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Refund Processing</title>
</head>
<body>
<%
    String userId = (String) session.getAttribute("userId");
    String orderId = request.getParameter("orderId");
    out.println(PurchasedProductDAO.updateStatusRefund(userId, orderId));
    session.setAttribute("point", UserDAO.getUserPoint(userId));
%>
<script>
    location.href="purchase_list.do?action=purchasedList";
</script>
</body>
</html>
