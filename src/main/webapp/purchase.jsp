<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매</title>
<link rel="stylesheet" type="text/css" href="./css/reset.css" />
<link rel="stylesheet" type="text/css" href="./css/global.css" />
<link rel="stylesheet" type="text/css" href="./css/purchase.css?after" />
</head>
<body>
    <%@include file="top.jsp"%>
<h2 class="purchase-title">구매</h2>
<div class="purchase-container">
    <!-- 구매 내역 목록 -->
    <div class="purchase-list-container">
    
<%
    String itemsParam = request.getParameter("products");
    if (itemsParam != null && !itemsParam.isEmpty()) {
    	long totalPrice = 0;
        String[] productIdsStr = itemsParam.split(",");
        int[] productIds = new int[productIdsStr.length];
        for (int i = 0; i < productIdsStr.length; i++) {
            productIds[i] = Integer.parseInt(productIdsStr[i]);
        }

        
        // 데이터베이스 연결 정보

        Connection conn = DatabaseUtil.getConnection();
        Statement stmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;

            // 각 항목에 대해 PRODUCT 테이블에서 정보 가져오기
            for (int productId : productIds) {
                String productSql = "SELECT product_name, price, product_image FROM PRODUCT WHERE product_id = ?";
                pstmt = conn.prepareStatement(productSql);
                pstmt.setInt(1, productId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                	totalPrice += rs.getDouble("price");
%>
                    <div class="purchase-list">
                        <div class="book-img">
                            <img src="<%= request.getContextPath() %>/data<%= rs.getString("product_image") %>" alt="책 이미지"/>
                        </div>
                        <div class="book-info">
                            <div class="book-title"><%= rs.getString("product_name") %></div>
                            <div class="book-price"><%= rs.getString("price") %>원</div>
                        </div>
                    </div>
<%
                } else {
                    out.println("<p>Product ID " + productId + "에 해당하는 상품 정보를 찾을 수 없습니다.</p>");
                }
                rs.close();
                pstmt.close();
            }

%>
        <!-- 총 금액 및 선택된 항목 목록 -->
        <div class="total-price-container">
            <h3 class="total-price-title">총 금액: <span id="total-price"><%= totalPrice %>원</span></h3>
            <!-- 결제하러 가기 버튼 -->
            <div class="go-to-payment">
                <%
                    // 배열을 문자열로 변환하여 URL 파라미터로 넘기기
                    String productsParam = String.join(",", productIdsStr);
                %>
                <a href="purchase_process.jsp?products=<%= productsParam %>">신청</a>
            </div>
        </div>
<%
    } else {
        out.println("<p>선택된 항목이 없습니다.</p>");
    }
%>
    </div>
</div>
</body>
</html>

