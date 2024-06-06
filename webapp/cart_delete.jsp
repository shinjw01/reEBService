<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    // 요청 파라미터로부터 product_id와 user_id 가져오기
    String productId = request.getParameter("product_id");
    String s_id = request.getParameter("user_id");

    // 데이터베이스 연결 정보
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String user = "db1912339";
    String password = "oracle";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // 데이터베이스 연결
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, user, password);

        // SQL 쿼리 실행 (항목 삭제)
        String sql = "DELETE FROM BASKET WHERE user_id = ? AND product_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, s_id);
        pstmt.setString(2, productId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<p>항목이 성공적으로 삭제되었습니다.</p>");
        } else {
            out.println("<p>삭제할 항목을 찾을 수 없습니다.</p>");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>SQL 오류: " + e.getMessage() + "</p>");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<p>클래스 오류: " + e.getMessage() + "</p>");
    } finally {
        // 리소스 해제
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 메인 페이지로 리디렉션
    response.sendRedirect(request.getContextPath() + "/shopping-cart.jsp");
%>
