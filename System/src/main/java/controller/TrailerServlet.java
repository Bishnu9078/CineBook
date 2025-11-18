package controller;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TrailerServlet")
public class TrailerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieId = request.getParameter("id");
        if (movieId == null || movieId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing movie ID");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        InputStream inputStream = null;
        OutputStream outputStream = null;

        try {
            // ✅ Connect to DB
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");

            // ✅ Fetch trailer blob
            ps = conn.prepareStatement("SELECT trailer_link FROM movies WHERE id = ?");
            ps.setInt(1, Integer.parseInt(movieId));
            rs = ps.executeQuery();

            if (rs.next()) {
                Blob videoBlob = rs.getBlob("trailer_link");

                if (videoBlob != null) {
                    inputStream = videoBlob.getBinaryStream();

                    response.setContentType("video/mp4");
                    response.setHeader("Accept-Ranges", "bytes");

                    outputStream = response.getOutputStream();
                    byte[] buffer = new byte[8192];
                    int bytesRead;

                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    outputStream.flush(); // ✅ ensure data is fully sent
                } else {
                    if (!response.isCommitted()) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trailer not available for this movie");
                    }
                }
            } else {
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid movie ID");
                }
            }

        } catch (IOException clientAbort) {
            // ⚠ User closed browser or navigated away — not a real error
            System.err.println("⚠ Client aborted video stream: " + clientAbort.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error streaming trailer");
            }
        } finally {
            // ✅ Safe cleanup
            try { if (inputStream != null) inputStream.close(); } catch (IOException ignored) {}
            try { if (outputStream != null) outputStream.close(); } catch (IOException ignored) {}
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
