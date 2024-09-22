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

        // action�� ���� ��� ���ǿ��� ������
        if (action == null || action.isEmpty()) {
            action = (String) session.getAttribute("lastAction");
        } else {
            // ���ο� action ���� ���� �� ���ǿ� ����
            session.setAttribute("lastAction", action);
        }

        // action�� ������ null�� ��� �⺻ action ����
        if (action == null || action.isEmpty()) {
            action = "productList";
        }
        ActionFactory af = ActionFactory.getInstance();
        Action actionObject = af.getAction(action);
        if (actionObject != null) {
            actionObject.execute(request, response);
        } else {
            System.out.println(action+"�������� �ʴ� action�Դϴ�.");
            response.sendRedirect("main.jsp");
        }
    }
}
