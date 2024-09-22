package controller;

import java.io.IOException;
import java.util.*;
import model.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class purchaseAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        String itemsParam = (String)session.getAttribute("productParams");

        if (userId == null || itemsParam == null) {
            request.setAttribute("resultMessage", "유효한 사용자 ID 또는 제품 목록이 없습니다.");
            request.getRequestDispatcher("/purchase_process.jsp").forward(request, response);
            return;
        }

        String[] productIds = itemsParam.split(",");
        String resultMessage = ProductDAO.purchaseProduct(userId, productIds);

        // 유저의 포인트 업데이트
        session.setAttribute("point", UserDAO.getUserPoint(userId));

        // 결과 메시지를 JSP로 전달
        request.setAttribute("resultMessage", resultMessage);
        request.getRequestDispatcher("/purchase_process.jsp").forward(request, response);
	}

}
