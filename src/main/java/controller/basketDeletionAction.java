package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.BasketDAO;

public class basketDeletionAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        String productId = request.getParameter("productId");

        String message;
        if (userId == null || userId.isEmpty()) {
            message = "로그인 상태를 확인해 주세요.";
        } else if (productId == null || productId.isEmpty()) {
            message = "유효한 상품 ID가 아닙니다.";
        } else {
            boolean result = BasketDAO.deleteBasket(userId, productId);
            if (result) {
                message = "성공적으로 삭제하였습니다.";
            } else {
                message = "삭제할 항목을 찾을 수 없습니다.";
            }
        }

        // 메시지를 JSP로 전달
        request.setAttribute("message", message);
        request.getRequestDispatcher("/cart_delete.jsp").forward(request, response);

	}

}
