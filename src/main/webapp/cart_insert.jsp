<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>장바구니 추가</title>
</head>
<body>
    <%
        String s_id = (String)request.getParameter("user_id");
        String product = (String)request.getParameter("product_id");
        
        int p_id = Integer.parseInt(product);
        
        // 데이터베이스 연결 정보
        String url = "jdbc:oracle:thin:@localhost:1521:XE";
        String user = "db1912339";
        String password = "oracle";

        // 유효성 검사
        if (s_id == null || s_id.equals("")) {
            out.println("잘못된 요청입니다.");
        } else {
            Connection conn = null;
            CallableStatement cstmt = null;

            try {
                // 데이터베이스 연결
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection(url, user, password);

                
                // PL/SQL 프로시저 호출 준비
                String plsql = "{CALL insert_into_cart(?, ?, ?)}";
                cstmt = conn.prepareCall(plsql);

                // 파라미터 설정
                cstmt.setInt(1, p_id);
                cstmt.setString(2, s_id);
                cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);

                // 프로시저 실행
                cstmt.execute();

                // 결과 메시지 가져오기
                String message = cstmt.getString(3);
                out.println(message);

                // 메시지에 따른 리디렉션 처리 (선택 사항)
                out.println("<script>alert('" + message + "'); history.back();</script>");
            } catch (Exception e) {
                out.println("오류가 발생했습니다: " + e.getMessage());
            } finally {
                // 리소스 해제
                if (cstmt != null) {
                    try {
                        cstmt.close();
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
        }
    %>
</body>
</html>
