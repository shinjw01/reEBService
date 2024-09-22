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

        // �α��� ���� Ȯ��
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ���� ���� Ȯ��
        if (!PurchasedProductDAO.isInHistory(userId, productId)) {
            request.setAttribute("errorMessage", "�߸��� �����Դϴ�.");
            request.getRequestDispatcher("main.do?action=productList").forward(request, response);
            return;
        }

        // ��ǰ ���� ��������
        ProductDTO product = null;
        if (productId != null && !productId.isEmpty()) {
            product = ProductDAO.getProduct(productId);
        }

        // ��ǰ ������ ������ ���� ó��
        if (product == null) {
            request.setAttribute("errorMessage", "å ������ �ҷ����� ���߽��ϴ�.");
        }

        // JSP�� ������ ����
        request.setAttribute("product", product);
        request.getRequestDispatcher("/my_book.jsp").forward(request, response);

	}

}
