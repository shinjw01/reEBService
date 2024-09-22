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
            request.setAttribute("errorMessage", "�α����� �ʿ��մϴ�.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // ����� ID�� ���� ���� ��������
        List<List<PurchasedProductDTO>> history = PurchasedProductDAO.getHistoryByOrderId(userId);

        // JSP�� ���� ���� ����
        request.setAttribute("purchaseHistory", history);
        request.getRequestDispatcher("/purchase_list.jsp").forward(request, response);

	}

}
