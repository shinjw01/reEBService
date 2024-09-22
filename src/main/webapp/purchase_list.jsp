<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, java.util.*" %>

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
        List<List<PurchasedProductDTO>> history = (List<List<PurchasedProductDTO>>) request.getAttribute("purchaseHistory");
        
        if (history != null && !history.isEmpty()) {
            for (List<PurchasedProductDTO> list : history) {
                StringBuilder productNames = new StringBuilder();
                String statusName = list.get(0).getStatus_name();
                int totalPrice = 0;
                String orderId = list.get(0).getOrder_id();
                for (PurchasedProductDTO product : list) {
                    if (productNames.length() > 0) productNames.append("+");
                    productNames.append(product.getName());
                    totalPrice += product.getPrice();
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
                    <%= "구매".equals(statusName) ? "onclick=\"handleRefund('" + orderId + "');\"" : "disabled" %> 
                    class="div6">
                    <%= "구매".equals(statusName) ? "환불 요청" : "환불 완료" %>
                </button>
            </div>
            <% if ("구매".equals(statusName)) { %>
            <div class="group-item">
                <form method="post" action="my_library.do?action=purchasedProductList">
                    <button class="detailCheck">상세 확인</button>
                </form>
            </div>
            <% } %>
        </div>
    </div>
    <% 
            }
        } else { 
            out.println("<p>구매 내역이 없습니다.</p>");
        }
    %>
</div>
</body>
</html>
