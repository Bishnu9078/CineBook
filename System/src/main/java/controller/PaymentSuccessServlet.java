package controller;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PaymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paymentId = request.getParameter("razorpay_payment_id");
        String bookingIdParam = request.getParameter("booking_id");

        if (paymentId == null || bookingIdParam == null) {
            response.getWriter().println("<h3 style='color:red;text-align:center;'>Invalid payment data received!</h3>");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3 style='color:red;text-align:center;'>Invalid Booking ID Format!</h3>");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068")) {

                // ✅ Update payment info
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE booking SET payment_status = 'SUCCESS', transaction_id = ? WHERE booking_id = ?");
                ps.setString(1, paymentId);
                ps.setInt(2, bookingId);
                int updated = ps.executeUpdate();

                if (updated > 0) {
                    // ✅ Fetch all booking details for session sync
                    PreparedStatement ps2 = conn.prepareStatement(
                        "SELECT user_id, theater_name, seats, booking_date, show_time, total_price FROM booking WHERE booking_id = ?");
                    ps2.setInt(1, bookingId);
                    ResultSet rs = ps2.executeQuery();

                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("booking_id", bookingId);
                        session.setAttribute("user_id", rs.getInt("user_id"));
                        session.setAttribute("theater_name", rs.getString("theater_name"));
                        session.setAttribute("seats", rs.getString("seats"));
                        session.setAttribute("booking_date", rs.getString("booking_date"));
                        session.setAttribute("show_time", rs.getString("show_time"));
                        session.setAttribute("total_price", rs.getDouble("total_price"));
                    }

                    // ✅ Redirect to ticket page
                    response.sendRedirect("ticket.jsp?booking_id=" + bookingId);
                } else {
                    response.getWriter().println("<h3 style='color:red;text-align:center;'>Booking not found or already updated!</h3>");
                }
            }
        } catch (Exception e) {
            throw new ServletException("❌ Error updating payment in database", e);
        }
    }
}
