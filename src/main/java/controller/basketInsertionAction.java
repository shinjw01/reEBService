package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.BasketDAO;

public class basketInsertionAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("userId");
        String productId = request.getParameter("productId");

        String message = "";
        if (userId == null || userId.equals("")) {
            message = "잘못된 요청입니다.";
        } else {
            int result = BasketDAO.insertBasket(userId, productId);
            switch (result) {
                case 1:
                    message = "장바구니에 성공적으로 추가했습니다";
                    break;
                case 2:
                    message = "장바구니에 이미 담긴 상품입니다";
                    break;
                case 3:
                    message = "이미 구매한 상품입니다";
                    break;
                default:
                    message = "오류가 발생했습니다.";
                    break;
            }
        }

        // 메시지를 JSP로 전달
        request.setAttribute("message", message);
        request.getRequestDispatcher("/cart_insert.jsp").forward(request, response);

	}

}
