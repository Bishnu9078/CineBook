package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/HomeRedirectServlet")
public class HomeRedirectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String redirectPage = request.getParameter("redirectPage");

        if (redirectPage == null || redirectPage.trim().isEmpty()) {
            redirectPage = "userDashboard.jsp"; // fallback
        }

        response.sendRedirect(redirectPage);
    }
}
