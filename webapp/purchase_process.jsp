<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,oracle.sql.*, oracle.jdbc.*" %>
<%@ page import="util.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Purchase Processing</title>
</head>
<body>
<%
    String userId = request.getParameter("userId");
    String itemsParam = request.getParameter("products");

    if (userId == null || itemsParam == null) {
        out.println("유효한 사용자 ID 또는 제품 목록이 없습니다.");
        return;
    }

    String[] productIdsStr = itemsParam.split(",");
    int[] productIds = new int[productIdsStr.length];
    for (int i = 0; i < productIdsStr.length; i++) {
        productIds[i] = Integer.parseInt(productIdsStr[i]);
    }

    Connection conn = null;
    CallableStatement stmt = null;
   // PreparedStatement historyStmt = null;

        conn = DatabaseUtil.getConnection();
        
     // ODCINUMBERLIST 생성
        ArrayDescriptor descriptor = ArrayDescriptor.createDescriptor("SYS.ODCINUMBERLIST", conn);
        ARRAY productArray = new ARRAY(descriptor, conn, productIds);

        String sql = "{call purchase_products(?, ?)}";
        stmt = conn.prepareCall(sql);
        stmt.registerOutParameter(1, Types.VARCHAR); // 반환 값
        stmt.setString(2, userId);
        stmt.setArray(3, productArray);

        

        stmt.execute();

        String resultMessage = stmt.getString(1);
        out.println(resultMessage);
        
  
%>
<script>
    alert("구매완료 되었습니다.");
    location.href="purchase_list.jsp";
</script>
</body>
</html>
<% session.invalidate(); %>