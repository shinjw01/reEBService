<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, java.util.List" %>
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
    <div class="cart-list-container">
        <%
            List<ProductDTO> basketProducts = (List<ProductDTO>) request.getAttribute("basketProducts");
            int itemCount = basketProducts.size();
            if (itemCount == 0) { %>
            <p>장바구니가 비었습니다.</p>
        <% } else { %>
            <% for (ProductDTO product : basketProducts) { %>
                <div class="cart-list">
                    <div class="select-item">
                        <input type="checkbox" 
                            onchange="updateSelectedItems('<%= product.getId() %>', '<%= product.getName() %>', '<%= product.getPrice() %>', this.checked)">
                    </div>
                    <div class="book-img">
                        <img src="./data<%= product.getProduct_image() %>" alt="책 이미지" />
                    </div>
                    <div class="book-info">
                        <div class="book-title"><%= product.getName() %></div>
                        <div class="book-price"><%= product.getPrice() %>원</div>
                    </div>
                    <div class="delete-item">
                        <form action="<%= request.getContextPath() %>/cart_delete.do?action=basketDeletion" method="post">
                            <input type="hidden" name="productId" value="<%= product.getId() %>">
                            <button type="submit" class="delete-item-btn">항목 삭제</button>
                        </form>
                    </div>
                </div>
            <% } %>
        <% } %>

        <div class="total-price-container">
            <h3 class="total-price-title">장바구니 내 상품 개수: <span id="total-item-count"><%= itemCount %></span></h3>
        </div>
        <div class="total-price-container">
            <h3 class="total-price-title">총 금액: <span id="total-price">0원</span></h3>
            <div class="selected-items-container">
                <h4>[선택된 항목]</h4>
                <ul id="selected-items"></ul>
            </div>
            <div class="go-to-payment">
                <a href="javascript:void(0);" onclick="goToPayment()">결제하러 가기</a>
            </div>
        </div>
    </div>
</div>

<script>
    let selectedItems = [];
    let totalPrice = 0;

    function updateSelectedItems(productId, productName, productPrice, isChecked) {
        const selectedItemsContainer = document.getElementById('selected-items');
        const totalPriceElement = document.getElementById('total-price');

        if (isChecked) {
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
    }

    function goToPayment() {
        if (selectedItems.length > 0) {
            let url = '<%= request.getContextPath() %>/purchase.do?action=readyToPurchase&products=' + selectedItems.join(',');
            window.location.href = url;
        } else {
            alert('선택된 항목이 없습니다.');
        }
    }
</script>
</body>
</html>
