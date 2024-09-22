package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ProductDAO;
import model.ProductDTO;
import model.PurchasedProductDAO;
import model.BasketDAO;

public class ProductListAction implements Action {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // ���ǿ��� ����� ID Ȯ��
        String userId = null;
        Object userObject = request.getSession().getAttribute("userId");
        if (userObject instanceof String) {
            userId = (String) userObject;
        }

        // ��ǰ ����Ʈ ��������
        List<ProductDTO> productList = ProductDAO.getAllProducts();
        
        // �� ��ǰ�� ���� ��ٱ��� ���¿� ���� ���¸� ����
        if (productList != null && userId != null) {
            for (ProductDTO product : productList) {
                product.setPurchased(PurchasedProductDAO.isInHistory(userId, product.getId()));
                product.setInBasket(BasketDAO.isInBasket(userId, product.getId()));
            }
        }

        // JSP�� ������ ����
        request.setAttribute("productList", productList);
        request.setAttribute("userId", userId);

        // JSP�� ������
        request.getRequestDispatcher("main.jsp").forward(request, response);
    }
}
