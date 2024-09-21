<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,model.*" %>

<%
    String checkId = request.getParameter("check_id");
    String userId = request.getParameter("user_id");
    String userName = request.getParameter("user_name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String birth = request.getParameter("birth");
    String phone = request.getParameter("phone");

    Connection myConn = DatabaseUtil.getConnection();
    
    ResultSet myResultSet = null;
    try {
    	if ("true".equals(checkId)) {
            // 아이디 중복 확인 처리
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            int count = UserDAO.getUserId(userId.trim());
            if (count > 0) {
                out.print("{\"isAvailable\": false, \"message\": \"아이디가 이미 사용 중입니다.\"}");
            } else {
                out.print("{\"isAvailable\": true, \"message\": \"사용 가능한 아이디입니다.\"}");
            }
            return; // 중복 확인 요청 처리 후 종료
        }

        // 회원가입 처리
        UserDTO user = new UserDTO();
        user.setName(userName.trim());
        user.setId(userId.trim());
        user.setEmail(email.trim());
        user.setPhone(phone.trim());
        user.setPassword(password.trim());
        user.setBirth(birth.trim());

        int result = UserDAO.createUser(user);

        if (result > 0) {
            out.println("<script>alert('회원가입이 완료되었습니다.'); location.href = 'login.jsp';</script>");
        } else {
            out.println("<script>alert('회원가입에 실패했습니다. 다시 시도해주세요.'); location.href = 'signup.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('회원가입 처리 중 오류가 발생했습니다.'); location.href = 'signup.jsp';</script>");
    }
%>
