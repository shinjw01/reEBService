<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.*" %>

<%
    String checkId = request.getParameter("check_id");
    String userID = request.getParameter("user_id");
    String userName = request.getParameter("user_name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String birth = request.getParameter("birth");
    String phone = request.getParameter("phone");

    Connection myConn = DatabaseUtil.getConnection();
    PreparedStatement pstmt = null;
    ResultSet myResultSet = null;
    try {
    	if ("true".equals(checkId)) {
            // 아이디 중복 확인 처리
            String mySQL = "SELECT COUNT(*) FROM USERS WHERE user_id = ?";
            pstmt = myConn.prepareStatement(mySQL);
            pstmt.setString(1, userID.trim());

            myResultSet = pstmt.executeQuery();
            myResultSet.next();
            int count = myResultSet.getInt(1);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (count > 0) {
                out.print("{\"isAvailable\": false, \"message\": \"아이디가 이미 사용 중입니다.\"}");
            } else {
                out.print("{\"isAvailable\": true, \"message\": \"사용 가능한 아이디입니다.\"}");
            }
            return; // 중복 확인 요청 처리 후 종료
        }

        // 회원가입 처리
        String insertSQL = "INSERT INTO USERS (user_name, user_id, email, password, birth, phone) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = myConn.prepareStatement(insertSQL);
        pstmt.setString(1, userName.trim());
        pstmt.setString(2, userID.trim());
        pstmt.setString(3, email.trim());
        pstmt.setString(4, password.trim());
        pstmt.setString(5, birth.trim());
        pstmt.setString(6, phone.trim());

        int result = pstmt.executeUpdate();

        if (result > 0) {
            out.println("<script>alert('회원가입이 완료되었습니다.'); location.href = 'login.jsp';</script>");
        } else {
            out.println("<script>alert('회원가입에 실패했습니다. 다시 시도해주세요.'); location.href = 'signup.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('회원가입 처리 중 오류가 발생했습니다.'); location.href = 'signup.jsp';</script>");
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
