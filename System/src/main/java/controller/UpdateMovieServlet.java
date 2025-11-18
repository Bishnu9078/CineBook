package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateMovieServlet")
public class UpdateMovieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get parameters from editMovie.jsp
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String duration = request.getParameter("duration");
        String theater = request.getParameter("theater");
        String showTime = request.getParameter("show_time");
        double price = Double.parseDouble(request.getParameter("price"));
        String releaseDate = request.getParameter("release_date");
        String imageUrl = request.getParameter("image_url");
        String description = request.getParameter("description");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");

            String sql = "UPDATE movies SET title=?, genre=?, duration=?, theater=?, show_time=?, price=?, release_date=?, image_url=?, description=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, genre);
            ps.setString(3, duration);
            ps.setString(4, theater);
            ps.setString(5, showTime);
            ps.setDouble(6, price);
            ps.setString(7, releaseDate);
            ps.setString(8, imageUrl);
            ps.setString(9, description);
            ps.setInt(10, id);

            int rows = ps.executeUpdate();

            ps.close();
            conn.close();

            if (rows > 0) {
                // ✅ Successfully updated
                response.sendRedirect("manageMovies.jsp?updated=1");
            } else {
                // ❌ Movie not found or update failed
                request.setAttribute("error", "Movie update failed. Try again.");
                RequestDispatcher rd = request.getRequestDispatcher("editMovie.jsp?id=" + id);
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("editMovie.jsp?id=" + id);
            rd.forward(request, response);
        }
    }
}
