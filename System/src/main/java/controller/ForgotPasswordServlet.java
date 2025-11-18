package controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Forward user to reset password page using RequestDispatcher
        RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp");
        rd.forward(request, response);
    }
}
