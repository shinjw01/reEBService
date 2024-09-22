package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.*;

public class purchasedProductAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        String productId = request.getParameter("productId");

        // 로그인 여부 확인
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 구매 내역 확인
        if (!PurchasedProductDAO.isInHistory(userId, productId)) {
            request.setAttribute("errorMessage", "잘못된 접근입니다.");
            request.getRequestDispatcher("main.do?action=productList").forward(request, response);
            return;
        }

        // 상품 정보 가져오기
        ProductDTO product = null;
        if (productId != null && !productId.isEmpty()) {
            product = ProductDAO.getProduct(productId);
        }

        // 상품 정보가 없으면 에러 처리
        if (product == null) {
            request.setAttribute("errorMessage", "책 내용을 불러오지 못했습니다.");
        }

        // JSP로 데이터 전달
        request.setAttribute("product", product);
        request.getRequestDispatcher("/my_book.jsp").forward(request, response);

	}

}
