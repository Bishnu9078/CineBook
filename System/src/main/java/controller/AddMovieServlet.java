package controller;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@MultipartConfig(maxFileSize = 1024 * 1024 * 200) // allow up to 200MB uploads
@WebServlet("/AddMovieServlet")
public class AddMovieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ✅ Regular text inputs
        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String duration = request.getParameter("duration");
        String theater = request.getParameter("theater");
        String showTime = request.getParameter("show_time");
        String imageUrl = request.getParameter("image_url");
        String description = request.getParameter("description");
        String releaseDate = request.getParameter("release_date");

        // ✅ Numeric values (with null safety)
        double price = 0.0;
        double rating = 0.0;
        int userReviews = 0, criticsScore = 0, watchlistCount = 0;

        try {
            if (request.getParameter("price") != null && !request.getParameter("price").isEmpty())
                price = Double.parseDouble(request.getParameter("price"));
            if (request.getParameter("rating") != null && !request.getParameter("rating").isEmpty())
                rating = Double.parseDouble(request.getParameter("rating"));
            if (request.getParameter("user_reviews") != null && !request.getParameter("user_reviews").isEmpty())
                userReviews = Integer.parseInt(request.getParameter("user_reviews"));
            if (request.getParameter("critics_score") != null && !request.getParameter("critics_score").isEmpty())
                criticsScore = Integer.parseInt(request.getParameter("critics_score"));
            if (request.getParameter("watchlist_count") != null && !request.getParameter("watchlist_count").isEmpty())
                watchlistCount = Integer.parseInt(request.getParameter("watchlist_count"));
        } catch (NumberFormatException nfe) {
            response.getWriter().println("<h3 style='color:red;'>⚠ Invalid numeric input. Check price, rating, or counts.</h3>");
            nfe.printStackTrace(response.getWriter());
            return;
        }

        String castCrew = request.getParameter("cast_crew");

        // ✅ File input for trailer (MP4)
        Part trailerPart = request.getPart("trailer_link");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");

            String sql = "INSERT INTO movies " +
                         "(title, genre, duration, release_date, image_url, description, theater, show_time, " +
                         "price, rating, user_reviews, critics_score, watchlist_count, cast_crew, trailer_link) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            ps = conn.prepareStatement(sql);

            ps.setString(1, title);
            ps.setString(2, genre);
            ps.setString(3, duration);
            ps.setString(4, releaseDate);
            ps.setString(5, imageUrl);
            ps.setString(6, description);
            ps.setString(7, theater);
            ps.setString(8, showTime);
            ps.setDouble(9, price);
            ps.setDouble(10, rating);
            ps.setInt(11, userReviews);
            ps.setInt(12, criticsScore);
            ps.setInt(13, watchlistCount);
            ps.setString(14, castCrew);

            // ✅ If a file is uploaded, save it as BLOB
            if (trailerPart != null && trailerPart.getSize() > 0) {
                InputStream trailerStream = trailerPart.getInputStream();
                ps.setBlob(15, trailerStream);
            } else {
                ps.setNull(15, java.sql.Types.BLOB);
            }

            ps.executeUpdate();

            // ✅ Redirect back to manage page
            response.sendRedirect("manageMovies.jsp?added=1");

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
