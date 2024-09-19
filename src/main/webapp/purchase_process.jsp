<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,oracle.sql.*, oracle.jdbc.*" %>
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

    String[] productIdsStr = itemsParam.split(",");
    int[] productIds = new int[productIdsStr.length];
    for (int i = 0; i < productIdsStr.length; i++) {
        productIds[i] = Integer.parseInt(productIdsStr[i]);
    }

    Connection conn = null;
    CallableStatement stmt = null;
   // PreparedStatement historyStmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver"); // Oracle JDBC 드라이버 로드
        String dbURL = "jdbc:oracle:thin:@localhost:1521:xe"; // DB URL, 포트, 서비스명 수정 필요
        String dbUser = "db1912339";
        String dbPassword = "oracle";

        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
     // ODCINUMBERLIST 생성
        ArrayDescriptor descriptor = ArrayDescriptor.createDescriptor("SYS.ODCINUMBERLIST", conn);
        ARRAY productArray = new ARRAY(descriptor, conn, productIds);

        String sql = "{? = call purchase_products(?, ?)}";
        stmt = conn.prepareCall(sql);
        stmt.registerOutParameter(1, Types.VARCHAR); // 반환 값
        stmt.setString(2, userId);
        stmt.setArray(3, productArray);

        

        stmt.execute();

        String resultMessage = stmt.getString(1);
        System.out.println(resultMessage);
        
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
        	//if (historyStmt != null) historyStmt.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            out.println("SQL 오류: " + se.getMessage());
        }
    }
%>
<script>
    alert("구매완료되었습니다.");
    location.href="purchase_list.jsp";
</script>
</body>
</html>