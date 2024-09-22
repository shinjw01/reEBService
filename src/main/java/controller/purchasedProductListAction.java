package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.*;

public class purchasedProductListAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 사용자 ID로 구매한 도서 목록 가져오기
        List<PurchasedProductDTO> productList = PurchasedProductDAO.getUserProducts(userId);

        // JSP로 구매한 도서 목록 전달
        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/my_library.jsp").forward(request, response);

	}

}
