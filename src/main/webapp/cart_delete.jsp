<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*,model.*" %>

<%
    String productId = request.getParameter("product_id");
    String userId = (String)session.getAttribute("user");

    if (userId == null || userId.isEmpty()) {
        out.println("<script>alert('로그인 상태를 확인해 주세요.'); location.href='" + request.getContextPath() + "/login.jsp';</script>");
        return;
    }

    if (productId == null || productId.isEmpty()) {
        out.println("<script>alert('유효한 상품 ID가 아닙니다.'); location.href='" + request.getContextPath() + "/shopping-cart.jsp';</script>");
        return;
    }
    
    boolean result = BasketDAO.deleteBasket(userId, productId);
    String message = "";
    if (result)
    	message = "성공적으로 삭제하였습니다.";
    else
    	message = "삭제할 항목을 찾을 수 없습니다.";
%>
<script>
	alert('<%=message%>');
	location.href='<%=request.getContextPath()%>/shopping-cart.jsp';
</script>