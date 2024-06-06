<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*, util.BasketService" %>
<%@ page import="util.BasketService" %>
<%
//요청 파라미터 받기
String userId = request.getParameter("userId");
String productId = request.getParameter("productId");
String action = request.getParameter("action");

// 응답 데이터 초기화
boolean success = false;

// 장바구니 업데이트 로직
if ("add".equals(action)) {
    success = BasketService.updateBasket(userId, productId, false);
} else if ("remove".equals(action)) {
    success = BasketService.updateBasket(userId, productId, true);
}

// JSON 응답 문자열 생성
String jsonResponse = "{\"success\":" + success + "}";

// 응답 설정 및 전송
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
//PrintWriter out = response.getWriter();
out.print(jsonResponse);
out.flush();
%>
