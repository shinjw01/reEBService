<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="util.*" %>


<!DOCTYPE html>
<html>
<head>
    <title>EBS | 구매내역</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/purchase_list.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400&display=swap" />
</head>
<body>
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
    <div class="header">
        <div class="ebs-ebook-service-container">
            <p class="ebs">EBS</p>
            <p class="ebook-service">EBook Service</p>
        </div>
        <img class="cilbook-icon" alt="" src="cil:book.svg">
    </div>
    <div class="child"></div>
    <div class="div1">구매 내역</div>
    <div class="div2">
        <% 
            // Database connection setup
            Connection conn = DatabaseUtil.getConnection();
            PreparedStatement stmt = null;
            ResultSet rs = null;
            //login_verify.jsp에서 setAttribute된 이름과 같아야함.
            String userId = (String) session.getAttribute("user");   
            System.out.println(userId);

                // SQL Query
                String sql = "SELECT h.order_id, LISTAGG(p.product_name, ' + ') WITHIN GROUP (ORDER BY p.product_name) AS product_names, SUM(p.price) AS total_price, h.status_name FROM HISTORY h JOIN PRODUCT p ON h.product_id = p.product_id WHERE h.user_id = ? GROUP BY h.order_id, h.status_name";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, userId);
                rs = stmt.executeQuery();

                // Displaying each purchase
                while (rs.next()) {
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
                    <form method="post" action="refund.jsp">
                        <input type="hidden" name="userId" value="<%= userId %>">
                        <input type="hidden" name="orderId" value="<%= rs.getInt("order_id") %>">
                        
                        <button id="refund-button-<%= rs.getInt("order_id") %>" onclick="handleRefund(<%= rs.getInt("order_id") %>);" class="div6">환불 요청</button>
                    </form>
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
        %>
    </div>
</div>
</body>
</html>