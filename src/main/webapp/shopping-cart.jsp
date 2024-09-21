<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import = "model.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>EBS | 장바구니</title>
	<link rel="stylesheet" type="text/css" href="./css/reset.css" />
	<link rel="stylesheet" type="text/css" href="./css/global.css" />
	<link rel="stylesheet" type="text/css" href="./css/shopping-cart.css?after" />
</head>

<body>
<jsp:include page="top.jsp" />
<h2 class="shopping-cart-title">장바구니</h2>
<div class="shopping-cart-container">
    <!-- 구매 내역 목록 -->
    <div class="cart-list-container">
        <% 
            // 세션에서 사용자 ID 가져오기
            String userId = (String)session.getAttribute("user");
            List<ProductDTO> al = BasketDAO.getBasketProducts(userId);
            int itemCount = al.size();
            boolean hasResults = false;

            // 구매 내역 목록 출력
            for (ProductDTO product : al) {
        %>
	        <div class="cart-list">
		        <div class="select-item">
				    <input type="checkbox" 
				           onchange="updateSelectedItems('<%= product.getId() %>', '<%= product.getName() %>', '<%= product.getPrice() %>', this.checked)">
				</div>
	            <div class="book-img">
	                <img
	                    src="./data<%= product.getProduct_image() %>"
	                    alt="책 이미지"
	                />
	            </div>
	            <div class="book-info">
	                <div class="book-title"><%= product.getName() %></div>
	                <div class="book-price"><%= product.getPrice() %>원</div>
	            </div>
	            <div class="delete-item">
                    <form action="<%= request.getContextPath() %>/cart_delete.jsp" method="post">
                            <input type="hidden" name="product_id" value="<%= product.getId() %>">
                            <button type="submit" class="delete-item-btn">항목 삭제</button>
                        </form>
                </div>
	        </div>
	        <% 
		            }
                    
                if (itemCount == 0) {
                    out.println("<p>장바구니가 비었습니다.</p>");
                }
        %>
        <!-- 총 금액 및 선택된 항목 목록 -->
        <div class="total-price-container">
        <h3 class="total-price-title">장바구니 내 상품 개수 : <span id="total-item-count"><%= itemCount %></span></h3>
        </div>
        <div class="total-price-container">
            <h3 class="total-price-title">총 금액: <span id="total-price">0원</span></h3>
            <div class="selected-items-container">
            <br/>
                <h4>[선택된 항목]</h4>
                <ul id="selected-items"></ul>
            </div>
            <!-- 결제하러 가기 버튼 -->
            <div class="go-to-payment">
                <a href="javascript:void(0);" onclick="goToPayment()">결제하러 가기</a>
            </div>
        </div>
    </div>
</div>

<%	//session 확인
if (userId == null){%>
<script type="text/javascript">
    alert("로그인 후 이용하세요.");
    window.location.href = "login.jsp";
</script>
<%} %>
<script>
    let selectedItems = [];
    let totalPrice = 0;

    function updateSelectedItems(productId, productName, productPrice, isChecked) {
        const selectedItemsContainer = document.getElementById('selected-items');
        const totalPriceElement = document.getElementById('total-price');

        if (isChecked) {
        	// alert(productId + ", " + productName + ", " + productPrice + ", " + isChecked);
            selectedItems.push(productId);
            const itemElement = document.createElement('li');
            itemElement.id = 'item-' + productId;
            itemElement.textContent = productName + " - " + productPrice + "원";
            selectedItemsContainer.appendChild(itemElement);
            totalPrice += parseInt(productPrice, 10);
        } else {
            selectedItems = selectedItems.filter(id => id !== productId);
            const itemElement = document.getElementById('item-' + productId);
            if (itemElement) {
                selectedItemsContainer.removeChild(itemElement);
            }
            totalPrice -= parseInt(productPrice, 10);
        }

        totalPriceElement.textContent = totalPrice + "원";
        // AJAX 요청을 통해 총 가격 업데이트
        updateTotalPrice();
    }
    
    function updateTotalPrice() {
        if (selectedItems.length > 0) {
            $.ajax({
                url: '<%= request.getContextPath() %>/getTotalPrice.jsp',
                type: 'GET',
                data: { selectedItems: selectedItems.join(',') }, // 수정된 부분
                success: function(response) {
                    $('#total-price').text(response);
                },
                error: function() {
                    alert('총 가격을 가져오는 데 실패했습니다.');
                }
            });
        } else {
            $('#total-price').text('0원');
        }
    }
    
    function goToPayment() {
        if (selectedItems.length > 0) {
            let url = '<%= request.getContextPath() %>/purchase.jsp?products=' + selectedItems.join(',');
            window.location.href = url;
        } else {
            alert('선택된 항목이 없습니다.');
        }
    }
</script>
</body>
</html>
