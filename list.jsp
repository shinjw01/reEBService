<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EBS | 상품리스트</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/book-list.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reset.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css" />
    <style></style>
</head>
<body>
    <!-- 헤더 -->
    <div class="page-header" id="bookContainer">
        <img src="<%= request.getContextPath() %>/src/logo.png" alt="로고" />
    </div>

    <!-- 헤더 내 유저 정보 & 로그인 버튼 (추가 수정 예정) -->
    <div class="user-container">
        <div class="user-info">
            <p class="user-name"><strong>심준호</strong>님, 환영합니다!</p>
            <p class="user-point">보유포인트 30,000</p>
        </div>
        <button class="login-btn">로그아웃</button>
    </div>

    <!-- 도서 리스트 (추후 리팩터링) -->
    <main class="book-list">
        <div class="book-container">
            <div class="click-to-link">
                <div class="book-image">
                    <img src="./img/Python.jpg" alt="책 이미지" />
                </div>
                <h3 class="title">김형석, 백 년의 지혜</h3>
                <p class="author">김형석</p>
                <div class="btn-container">
                    <div class="detail-btn">
                        <button class="detail-view-link">상세보기</button>
                    </div>
                    <div class="cart-btn">
                        <button class="add-to-cart-btn">장바구니 담기</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="book-container">
            <div class="click-to-link">
                <a href="<%= request.getContextPath() %>/book-detail.jsp" class="book-container-link">
                    <div class="book-image">
                        <img src="<%= request.getContextPath() %>/img/Clean Code in Python.jpg" alt="책 이미지" />
                    </div>
                    <h3 class="title">김형석, 백 년의 지혜</h3>
                    <p class="author">김형석</p>
                </a>

                <div class="btn-container">
                    <div class="detail-btn">
                        <button class="detail-view-link">상세보기</button>
                    </div>
                    <div class="cart-btn">
                        <button class="disabled">소장 중인 도서</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="book-container">
            <div class="click-to-link">
                <div class="book-image">
                    <img src="<%= request.getContextPath() %>/img/Clean Code in Python.jpg" alt="책 이미지" />
                </div>
                <h3 class="title">김형석, 백 년의 지혜</h3>
                <p class="author">김형석</p>
                <div class="btn-container">
                    <div class="detail-btn">
                        <button class="detail-view-link">상세보기</button>
                    </div>
                    <div class="cart-btn">
                        <button class="add-to-cart-btn">장바구니 담기</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="book-container">
            <div class="click-to-link">
                <div class="book-image">
                    <img src="<%= request.getContextPath() %>/img/Clean Code in Python.jpg" alt="책 이미지" />
                </div>
                <h3 class="title">김형석, 백 년의 지혜</h3>
                <p class="author">김형석</p>
                <div class="btn-container">
                    <div class="detail-btn">
                        <button class="detail-view-link">상세보기</button>
                    </div>
                    <div class="cart-btn">
                        <button class="add-to-cart-btn">장바구니 담기</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="book-container">
            <div class="click-to-link">
                <div class="book-image">
                    <img src="<%= request.getContextPath() %>/img/Clean Code in Python.jpg" alt="책 이미지" />
                </div>
                <h3 class="title">김형석, 백 년의 지혜</h3>
                <p class="author">김형석</p>
                <div class="btn-container">
                    <div class="detail-btn">
                        <button class="detail-view-link">상세보기</button>
                    </div>
                    <div class="cart-btn">
                        <button class="add-to-cart-btn">장바구니 담기</button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- 알림창 -->
    <div class="notification" id="notification">장바구니에 담았습니다</div>

    <!-- 자바스크립트  -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 장바구니담기 버튼 클릭시, 화면 하단에 알림창
            const cartButtons = document.querySelectorAll(".add-to-cart-btn");
            const notification = document.getElementById("notification");

            cartButtons.forEach((button) => {
                button.addEventListener("click", function () {
                    notification.style.display = "block";
                    setTimeout(() => {
                        notification.style.display = "none";
                    }, 1000);
                });
            });

            // 상세보기 버튼 클릭시, 해당 페이지로 이동
            const detailViewButtons = document.querySelectorAll(".detail-view-link");

            detailViewButtons.forEach((button) => {
                button.addEventListener("click", function () {
                    window.location.href = "<%= request.getContextPath() %>/book-detail.jsp"; 
                });
            });
        });
    </script>
</body>
</html>
