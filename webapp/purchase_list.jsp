<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>EBS | 구매내역</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" type="text/css" href="./css/reset.css" />
    <link rel="stylesheet" type="text/css" href="./css/purchase_list.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400&display=swap" />
</head>
<body>
<jsp:include page="top.jsp" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
function handleRefund(orderId) {
    $.ajax({
        type: "POST",
        url: "refund.jsp",
        data: { orderId: orderId },
        success: function(response) {
            alert("환불 처리 되었습니다.");
            $("#refund-button-" + orderId).prop('disabled', true).text('환불 완료').css('background-color', 'grey');
            location.href="purchase_list.jsp";
        },
        error: function() {
            alert("환불 처리에 실패했습니다.");
        }
    });
}
</script>
<div class="div">
   
      
    </div>
    <div class="child"></div>
    <div class="div1">구매 내역</div>
    <div class="div2">
        <% 
            // Database connection setup
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            String userId = (String) session.getAttribute("user");
            //String userId = "JH1234"; // This should be set from session or another method
            if (userId == null) {
                out.println("<p>로그인이 필요합니다.</p>");
                return;
            }

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                String dbURL = "jdbc:oracle:thin:@localhost:1521:xe";
                String dbUser = "db1912339";
                String dbPassword = "oracle";
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // SQL Query
                String sql = "SELECT h.order_id, LISTAGG(p.product_name, ' + ') WITHIN GROUP (ORDER BY p.product_name) AS product_names, SUM(p.price) AS total_price, h.status_name FROM HISTORY h JOIN PRODUCT p ON h.product_id = p.product_id WHERE h.user_id = ? GROUP BY h.order_id, h.status_name";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, userId);
                rs = stmt.executeQuery();

                // Displaying each purchase
                while (rs.next()) {
                	int orderId = rs.getInt("order_id");
                    String productNames = rs.getString("product_names");
                    int totalPrice = rs.getInt("total_price");
                    String statusName = rs.getString("status_name");
        %>
        <div class="component-1">
            <div class="component-1-child"></div>
            <div class="div3">
                <p class="ebs"><%= productNames %></p>
            </div>
            <div class="div4">총 가격: <%= totalPrice %>원</div>
            <div class="div5">상태: <%= statusName %></div>
            <div class="rectangle-parent">
                <div class="group-child">
						<button 
    						id="refund-button-<%= orderId %>" 
    						<%= "구매".equals(statusName) ? "onclick=\"handleRefund(" + orderId + ");\"" : "disabled" %>class="div6">
    						<%= "구매".equals(statusName) ? "환불 요청" : "환불 완료" %>
						</button>
                </div>
                <div class="group-item">
                    <form method="post" action="my-library.jsp">
                        <button class="detailCheck">상세 확인</button>
                    </form>
                </div>
            </div>
        </div>
        <% 
                }
            } catch (SQLException se) {
                out.println("SQL 오류: " + se.getMessage());
            } catch (Exception e) {
                out.println("오류: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
   
</div>
</body>
</html>