<%@ page contentType="text/html; charset=UTF-8" %> <%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.*" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>EBS | 상품리스트</title>
		<link rel="stylesheet" href="<%= request.getContextPath() %>/css/reset.css" />
		<link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css" />
		<link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css" />
		<link rel="stylesheet" href="<%= request.getContextPath() %>/css/book-list.css" />
	</head>
	<body>
		<jsp:include page="top.jsp" />

		<div class="content">
			<!-- 도서 리스트 -->
			<main class="book-list">
				<%
				String userId = null;
		    	Object userObject = session.getAttribute("user");
		    	if (userObject instanceof String) {
		        	userId = (String) userObject;
		    	}
		        	//저장프로시저 : 상품id=>주소, 상품명, 저자명, 이미지 경로=>null처리
		        List<Product> productList = ProductService.getAllProducts();
		        if (productList != null) {
		                for (Product product : productList) { %>
				<a href="#" class="book-container-link">
					<div class="book-container"
					data-product-id="<%= product.getId() %>">
						<div class="book-image">
							<img
								src="<%= request.getContextPath() %>/<%= product.getProduct_image() %>"
								alt="<%= product.getName() %> 이미지"
							/>
						</div>
						<h3 class="title"><%= product.getName() %></h3>
						<p class="author"><%= product.getAuthor() %></p>
						<div class="btn-container">
							<div class="detail-btn">
								<button class="detail-view-link">상세보기</button>
							</div>
							<div class="cart-btn" data-product-id="<%= product.getId() %>">
								<button class="add-to-cart-btn" >
									장바구니 담기
								</button>
							</div>
						</div>
					</div>
				</a>
				<% } }else { %>
				<p>상품이 없습니다.</p>
				<% } %>
			</main>
		</div>

		<!-- 알림창 -->
		<div class="notification" id="notification">장바구니에 담았습니다</div>
		<div class="notification" id="already-in-cart">이미 담긴 제품입니다</div>

		<!-- 자바스크립트  -->
		<script>
			document.addEventListener("DOMContentLoaded", function () {
				// 장바구니담기 버튼 클릭시, 장바구니 상태 확인 및 알림창
				const cartButtons = document.querySelectorAll(".add-to-cart-btn");
				const notification = document.getElementById("notification");
				const alreadyInCartNotification = document.getElementById("already-in-cart");

				cartButtons.forEach((button) => {
					button.addEventListener("click", function () {
						const productId = this.getAttribute("data-product-id");
						fetch("<%= request.getContextPath() %>/CheckBasketServlet", {
							method: "POST",
							headers: {
								"Content-Type": "application/x-www-form-urlencoded",
							},
							body: `userId=<%= (String) session.getAttribute("user_id") %>&productId=${productId}`,
						})
							.then((response) => response.json())
							.then((data) => {
								if (data.exists) {
									alreadyInCartNotification.style.display = "block";
									setTimeout(() => {
										alreadyInCartNotification.style.display = "none";
									}, 2000);
								} else {
									notification.style.display = "block";
									setTimeout(() => {
										notification.style.display = "none";
									}, 1000);
								}
							})
							.catch((error) => console.error("Error:", error));
					});
				});

				// 상세보기 버튼 클릭시, 해당 페이지로 이동
				const detailViewButtons = document.querySelectorAll(".detail-view-link");

				detailViewButtons.forEach((button) => {
		            button.addEventListener("click", function () {
		                const bookContainer = button.closest('.book-container');
		                const productId = bookContainer.dataset.productId;
		                window.location.href = './book-detail.jsp?product_id=' + productId;
		            });
		        });
			});
		</script>
	</body>
</html>
