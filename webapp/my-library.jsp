<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.PurchasedProduct" %>
<%@ page import="util.ProductService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EBS | 나의 서재</title>
    <link rel="stylesheet" href="./css/my-library.css" />
    <link rel="stylesheet" href="./css/reset.css" />
    <link rel="stylesheet" href="./css/main.css" />
    <style></style>
</head>
<body>
<%@include file="top.jsp"%>
<%	//session 확인
String userId = (String) session.getAttribute("user");

if (userId == null){%>
<script type="text/javascript">
    alert("로그인 후 이용하세요.");
    window.location.href = "login.jsp";
</script>
<%} %>
    <h2 class="my-library-title">나의 서재</h2>
    <p class="my-library-description">구매한 도서 목록을 확인해보세요</p>

    <!-- 도서 리스트 (추후 리팩터링) -->
    <main class="book-list">
    <%//저장프로시저 : 상품id=>주소, 상품명, 저자명, 이미지 경로=>null처리
    	List<PurchasedProduct> productList = ProductService.getUserProducts(userId);
        if (productList != null) {
        	for (PurchasedProduct product : productList) {
        %>
            <div class="book-container"
            data-product-id="<%= product.getId() %>">
                <div class="purchase-date">
                    <p><%= product.getPurchased_date() %></p>
                </div>
                <div class="book-image">
                    <img src="./data<%=product.getProduct_image()%>" alt="책 이미지" />
                </div>
                <h3 class="title"><%= product.getName() %></h3>
                <p class="author"><%= product.getAuthor() %></p>
                <div class="cart-btn">
                    <button class="add-to-cart-btn">내용 보기</button>
                </div>
            </div>
    <% 		}
        }
            else {%>
            		<div> 구매한 책이 없습니다. </div>
                <%}
                %>
    </main>
        <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 내용보기 버튼 클릭시, 해당 페이지로 이동
            const detailViewButtons = document.querySelectorAll(".add-to-cart-btn");

            detailViewButtons.forEach((button) => {
                button.addEventListener("click", function () { 
                	const bookContainer = button.closest('.book-container');
                    const productId = bookContainer.dataset.productId;
                    window.location.href = './my-book.jsp?product_id='+productId;                
                });
            });
        });
    </script>
</body>
</html>
