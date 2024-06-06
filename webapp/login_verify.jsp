<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>

<% String userID = request.getParameter("user_id");
String userPassword = request.getParameter("password");
Connection myConn = DatabaseUtil.getConnection();
ResultSet myResultSet = null;
PreparedStatement pstmt = null;
String mySQL = "SELECT user_id, user_name, point FROM USERS WHERE user_id = ? AND password = ?";
pstmt = myConn.prepareStatement(mySQL); pstmt.setString(1,userID.trim());
pstmt.setString(2, userPassword.trim()); myResultSet = pstmt.executeQuery();
out.println("쿼리 실행 성공<br />");
if (myResultSet.next()) { out.println("로그인 성공<br />");
session.setAttribute("user", myResultSet.getString("user_id"));
session.setAttribute("isLoggedIn", true);
session.setAttribute("userName", myResultSet.getString("user_name"));
session.setAttribute("points", myResultSet.getInt("point"));
response.sendRedirect("main.jsp");
}
else {
	out.println("일치하는 회원정보가 없습니다.<br />");
	%>
	<script>
	alert("일치하는 회원정보가 없습니다.");
	location.href = "login.jsp";
	</script>
<%
}
%>