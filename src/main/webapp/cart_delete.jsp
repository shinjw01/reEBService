<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, util.*" %>

<%
    String productId = request.getParameter("product_id");
    String s_id = (String)session.getAttribute("user");

    if (s_id == null || s_id.isEmpty()) {
        out.println("<script>alert('로그인 상태를 확인해 주세요.'); location.href='" + request.getContextPath() + "/login.jsp';</script>");
        return;
    }

    if (productId == null || productId.isEmpty()) {
        out.println("<script>alert('유효한 상품 ID가 아닙니다.'); location.href='" + request.getContextPath() + "/shopping-cart.jsp';</script>");
        return;
    }

    Connection conn = DatabaseUtil.getConnection();
    PreparedStatement pstmt = null;

    try {
        String sql = "DELETE FROM BASKET WHERE user_id = ? AND product_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, s_id);
        pstmt.setString(2, productId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<script>alert('항목이 성공적으로 삭제되었습니다.'); location.href='" + request.getContextPath() + "/shopping-cart.jsp';</script>");
        } else {
            out.println("<script>alert('삭제할 항목을 찾을 수 없습니다.'); location.href='" + request.getContextPath() + "/shopping-cart.jsp';</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>SQL 오류: " + e.getMessage() + "</p>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>