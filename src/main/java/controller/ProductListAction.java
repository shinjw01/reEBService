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
        // 세션에서 사용자 ID 확인
        String userId = null;
        Object userObject = request.getSession().getAttribute("userId");
        if (userObject instanceof String) {
            userId = (String) userObject;
        }

        // 상품 리스트 가져오기
        List<ProductDTO> productList = ProductDAO.getAllProducts();
        
        // 각 상품에 대한 장바구니 상태와 구매 상태를 설정
        if (productList != null && userId != null) {
            for (ProductDTO product : productList) {
                product.setPurchased(PurchasedProductDAO.isInHistory(userId, product.getId()));
                product.setInBasket(BasketDAO.isInBasket(userId, product.getId()));
            }
        }

        // JSP로 데이터 전달
        request.setAttribute("productList", productList);
        request.setAttribute("userId", userId);

        // JSP로 포워딩
        request.getRequestDispatcher("main.jsp").forward(request, response);
    }
}
