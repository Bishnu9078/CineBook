package controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");

            String sql = "UPDATE users SET password=? WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, email);

            int rowsUpdated = ps.executeUpdate();

            ps.close();
            conn.close();

            if (rowsUpdated > 0) {
                // ✅ Success: redirect back to login page
                response.sendRedirect("login.jsp?reset=success");
            } else {
                // ❌ No matching email found
                request.setAttribute("errorMessage", "Email not found. Try again.");
                RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred.");
            RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp");
            rd.forward(request, response);
        }
    }
}
