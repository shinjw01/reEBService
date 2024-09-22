<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Purchase Processing</title>
</head>
<body>
    <script>
        alert('<%= request.getAttribute("resultMessage") %>');
        location.href="purchase_list.do?action=purchasedList";
    </script>
</body>
</html>
