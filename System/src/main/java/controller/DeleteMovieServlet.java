package controller;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteMovieServlet")
public class DeleteMovieServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.getWriter().println("❌ No ID provided");
            return;
        }

        int movieId = Integer.parseInt(idParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");

            PreparedStatement ps = conn.prepareStatement("DELETE FROM movies WHERE id=?");
            ps.setInt(1, movieId);
            int rows = ps.executeUpdate();

            conn.close();

            if (rows > 0)
                response.sendRedirect("manageMovies.jsp?deleted=1");
            else
                response.getWriter().println("❌ Movie ID not found");

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}
