<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,model.*" %>
<%
    String userId = request.getParameter("userId").trim();
    String password = request.getParameter("password").trim();
    UserDTO user = UserDAO.getUserDTO(userId, password);
    if (user != null) {
        out.println("로그인 성공<br />");
        session.setAttribute("userId", user.getId());
        session.setAttribute("isLoggedIn", true);
        session.setAttribute("userName", user.getName());
        session.setAttribute("point", user.getPoint());
        response.sendRedirect("main.do?action=productList");
    } else {
            out.println("일치하는 회원정보가 없습니다.<br />");
            out.println("<script>alert('일치하는 회원정보가 없습니다.'); location.href = 'login.jsp';</script>");
        }

%>
