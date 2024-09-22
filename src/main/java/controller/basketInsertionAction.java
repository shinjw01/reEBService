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
            message = "�߸��� ��û�Դϴ�.";
        } else {
            int result = BasketDAO.insertBasket(userId, productId);
            switch (result) {
                case 1:
                    message = "��ٱ��Ͽ� ���������� �߰��߽��ϴ�";
                    break;
                case 2:
                    message = "��ٱ��Ͽ� �̹� ��� ��ǰ�Դϴ�";
                    break;
                case 3:
                    message = "�̹� ������ ��ǰ�Դϴ�";
                    break;
                default:
                    message = "������ �߻��߽��ϴ�.";
                    break;
            }
        }

        // �޽����� JSP�� ����
        request.setAttribute("message", message);
        request.getRequestDispatcher("/cart_insert.jsp").forward(request, response);

	}

}
