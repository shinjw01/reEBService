package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.*;

public class purchasedListAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            request.setAttribute("errorMessage", "로그인이 필요합니다.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // 사용자 ID로 구매 내역 가져오기
        List<List<PurchasedProductDTO>> history = PurchasedProductDAO.getHistoryByOrderId(userId);

        // JSP에 구매 내역 전달
        request.setAttribute("purchaseHistory", history);
        request.getRequestDispatcher("/purchase_list.jsp").forward(request, response);

	}

}
