<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Refund Processing</title>
</head>
<body>
<%
    String userId = (String) session.getAttribute("user");
    String orderId = request.getParameter("orderId");
    Connection conn = null;
    CallableStatement stmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver"); // Oracle JDBC 드라이버 로드
        String dbURL = "jdbc:oracle:thin:@localhost:1521:xe"; // DB URL, 포트, 서비스명 수정 필요
        String dbUser = "db1912339";
        String dbPassword = "oracle";

        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "{call refund_products(?, ?)}";
        stmt = conn.prepareCall(sql);
        stmt.setString(1, userId);
        stmt.setInt(2, Integer.parseInt(orderId));
        
        if (stmt.executeUpdate()>0){
    		System.out.println("막자사발");
        	out.println("환불이 성공적으로 처리되었습니다.");
        }
        else{
        	out.println("환불이 실패하였습니다.");
        	System.out.println("환불이 실패하였습니다.");
        }
        String query = "SELECT point FROM USERS WHERE user_id = ?";
    	PreparedStatement pstmt = conn.prepareStatement(query);
    	pstmt.setString(1, (String)session.getAttribute("user"));
    	ResultSet rs = pstmt.executeQuery();
    	if (rs.next()){
    		session.setAttribute("points", rs.getString("point"));
    	}
    
    } catch (SQLException se) {
        out.println("SQL 오류: " + se.getMessage());
    } catch (Exception e) {
        out.println("오류: " + e.getMessage());
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            out.println("SQL 오류: " + se.getMessage());
        }
    }
%>
<script>
    location.href="purchase_list.jsp";
</script>
</body>
</html>
