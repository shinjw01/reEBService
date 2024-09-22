package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("*.do")
public class FrontController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
        String action = request.getParameter("action");

        // action이 없을 경우 세션에서 가져옴
        if (action == null || action.isEmpty()) {
            action = (String) session.getAttribute("lastAction");
        } else {
            // 새로운 action 값이 있을 때 세션에 저장
            session.setAttribute("lastAction", action);
        }

        // action이 여전히 null인 경우 기본 action 설정
        if (action == null || action.isEmpty()) {
            action = "productList";
        }
        ActionFactory af = ActionFactory.getInstance();
        Action actionObject = af.getAction(action);
        if (actionObject != null) {
            actionObject.execute(request, response);
        } else {
            System.out.println(action+"존재하지 않는 action입니다.");
            response.sendRedirect("main.jsp");
        }
    }
}
