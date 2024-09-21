<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,model.*" %>
<%
    String userID = request.getParameter("user_id");
    String userPassword = request.getParameter("password");
    Connection myConn = DatabaseUtil.getConnection();
    PreparedStatement pstmt = null;
    ResultSet myResultSet = null;
    try {
    	// SQL 쿼리 준비
        String mySQL = "SELECT user_id, user_name, point FROM USERS WHERE user_id = ? AND password = ?";
        pstmt = myConn.prepareStatement(mySQL);
        pstmt.setString(1, userID.trim());
        pstmt.setString(2, userPassword.trim());

        // 쿼리 실행
        myResultSet = pstmt.executeQuery();
        out.println("쿼리 실행 성공<br />");

        // 결과 처리
        if (myResultSet.next()) {
            out.println("로그인 성공<br />");
            session.setAttribute("user", myResultSet.getString("user_id"));
            session.setAttribute("isLoggedIn", true);
            session.setAttribute("userName", myResultSet.getString("user_name"));
            session.setAttribute("points", myResultSet.getInt("point"));
            response.sendRedirect("main.jsp");
        } else {
            out.println("일치하는 회원정보가 없습니다.<br />");
            out.println("<script>alert('일치하는 회원정보가 없습니다.'); location.href = 'login.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류: " + e.getMessage() + "<br />");
        out.println("<script>alert('로그인 처리 중 오류가 발생했습니다.'); location.href = 'login.jsp';</script>");
    } finally {
        // 리소스 해제
        try {
            if (myResultSet != null) myResultSet.close();
            if (pstmt != null) pstmt.close();
            if (myConn != null) myConn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>
