<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="util.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Refund Processing</title>
</head>
<body>
<%
    String userId = request.getParameter("userId");
    String[] productIds = request.getParameterValues("productIds");
    Connection conn = null;
    CallableStatement stmt = null;

        conn = DatabaseUtil.getConnection();

        String sql = "{call refund_products(?, ?)}";
        stmt = conn.prepareCall(sql);
        stmt.setString(1, userId);

        // ODCINUMBERLIST 생성
        Array productArray = conn.createArrayOf("NUMBER", productIds);
        stmt.setArray(2, productArray);

        stmt.execute();

        out.println("환불이 성공적으로 처리되었습니다.");
    
%>
<script>
    alert("환불 처리 되었습니다.");
    location.href="purchase_list.jsp";
</script>
</body>
</html>
<% session.invalidate(); %>
