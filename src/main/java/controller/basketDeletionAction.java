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
            message = "�α��� ���¸� Ȯ���� �ּ���.";
        } else if (productId == null || productId.isEmpty()) {
            message = "��ȿ�� ��ǰ ID�� �ƴմϴ�.";
        } else {
            boolean result = BasketDAO.deleteBasket(userId, productId);
            if (result) {
                message = "���������� �����Ͽ����ϴ�.";
            } else {
                message = "������ �׸��� ã�� �� �����ϴ�.";
            }
        }

        // �޽����� JSP�� ����
        request.setAttribute("message", message);
        request.getRequestDispatcher("/cart_delete.jsp").forward(request, response);

	}

}
