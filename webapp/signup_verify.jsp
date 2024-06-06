<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="util.*" %>
<%
String userID = request.getParameter("user_id");
String password = request.getParameter("password");
String userName = request.getParameter("user_name");
String birth = request.getParameter("birth");
String phone = request.getParameter("phone");
String email = request.getParameter("email");
Connection myConn = DatabaseUtil.getConnection(); PreparedStatement pstmt = null;
out.println("DB 연결 성공<br />");
String mySQL = "INSERT INTO USERS (user_id, password, user_name, birth, phone, email, point, create_date) VALUES (?, ?, ?, ?, ?, ?, 200000, SYSTIMESTAMP)";
// pstmt 생성
pstmt = myConn.prepareStatement(mySQL);
pstmt.setString(1, userID.trim());
pstmt.setString(2, password.trim());
pstmt.setString(3, userName.trim());
pstmt.setString(4, birth.trim());
pstmt.setString(5, phone.trim());
pstmt.setString(6, email.trim()); // sql문 실행
int result = pstmt.executeUpdate();
if (result > 0) {
out.println("회원가입 성공<br />");
session.setAttribute("user", userID);
response.sendRedirect("login.jsp");
} else {
	%><script>
	alert("회원가입 실패.");
	location.href = "login.jsp";
</script>
<%
}