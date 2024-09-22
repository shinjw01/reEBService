package controller;

import java.io.IOException;
import model.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class productAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		 String productId = request.getParameter("productId");
	        HttpSession session = request.getSession();
	        String userId = (String) session.getAttribute("userId");

	        if (productId != null && !productId.isEmpty()) {
	            ProductDTO product = ProductDAO.getProduct(productId);

	            if (userId != null) {
	                boolean isPurchased = PurchasedProductDAO.isInHistory(userId, productId);
	                boolean isInBasket = BasketDAO.isInBasket(userId, productId);
	                product.setPurchased(isPurchased);
	                product.setInBasket(isInBasket);
	            }

	            request.setAttribute("product", product);
	        }

	        request.getRequestDispatcher("/book_detail.jsp").forward(request, response);
	    }
	}
