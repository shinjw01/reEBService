<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
    alert('${message}');
    location.href='<%= request.getContextPath() %>/shopping_cart.do?action=basket';
</script>
