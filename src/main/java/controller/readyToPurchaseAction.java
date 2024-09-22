package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.ProductDAO;
import model.ProductDTO;

public class readyToPurchaseAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		String itemsParam = request.getParameter("products");
        List<ProductDTO> products = new ArrayList<>();
        long totalPrice = 0;

        if (itemsParam != null && !itemsParam.isEmpty()) {
            String[] productIds = itemsParam.split(",");
            for (String productId : productIds) {
                ProductDTO product = ProductDAO.getProduct(productId);
                if (product != null) {
                    products.add(product);
                    totalPrice += product.getPrice();
                } else {
                    request.setAttribute("errorMessage", "��ǰ ������ ã�� �� �����ϴ�. (��ǰ ID: " + productId + ")");
                }
            }
        }

        // �迭�� ���ڿ��� ��ȯ�Ͽ� JSP�� �ѱ� �Ķ���ͷ� ����
        String productParams = String.join(",", itemsParam.split(","));
        request.setAttribute("products", products);
        request.setAttribute("totalPrice", totalPrice);
        session.setAttribute("productParams", productParams);

        request.getRequestDispatcher("/purchase.jsp").forward(request, response);
	}

}
