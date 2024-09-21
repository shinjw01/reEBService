<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,model.*, java.util.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>EBS | 구매내역</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" type="text/css" href="./css/reset.css" />
    <link rel="stylesheet" type="text/css" href="./css/purchase_list.css?after" />
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
    <div class="div1">구매 내역</div>
    <div class="div2">
        <% 
            String userId = (String) session.getAttribute("user");
            if (userId == null) {
                out.println("<p>로그인이 필요합니다.</p>");
                return;
            }
                List<List<PurchasedProductDTO>> history = PurchasedProductDAO.getHistoryByOrderId(userId);
                for (List<PurchasedProductDTO> list : history){
                	StringBuilder productNames = new StringBuilder();
                	String statusName = list.get(0).getStatus_name();
                	int totalPrice = 0;
                	String orderId = list.get(0).getOrder_id();
                	for(PurchasedProductDTO product : list){
                		//정보 받아오기
                		ProductDTO tmp = ProductDAO.getProduct(product.getId());
                		if(!productNames.isEmpty()) productNames.append("+");
                		productNames.append(tmp.getName());
                		totalPrice += tmp.getPrice();
                	}
                	
        %>
        <div class="component-1">
            <div class="div3">
                <p class="ebs"><%= productNames %></p>
            </div>
            <div class="div4">총 가격: <%= totalPrice %>원</div>
            <div class="div5">상태: <%= statusName %></div>
            <div class="rectangle-parent">
                <div class="group-child">
						<button 
    						id="refund-button-<%= orderId %>" 
    						<%= "구매".equals(statusName) ? "onclick=\"handleRefund(" + orderId + ");\"" : "disabled" %> class="div6">
    						<%= "구매".equals(statusName) ? "환불 요청" : "환불 완료" %>
						</button>
                </div>
                <% if ("구매".equals(statusName)) {%>
                <div class="group-item">
                    <form method="post" action="my-library.jsp">
                        <button class="detailCheck">상세 확인</button>
                    </form>
                </div>
                <%} %>
            </div>
        </div>
        <% 
                }
        %>
   
</div>
</body>
</html>