package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.razorpay.*;
import org.json.JSONObject;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Razorpay test credentials
    private static final String RAZORPAY_KEY_ID = "rzp_test_RWSSJLRAe8sSqv";
    private static final String RAZORPAY_KEY_SECRET = "pXhCk5DkLvFZ9ilcQYGpXQSn";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        double totalPrice = Double.parseDouble(request.getParameter("total_price"));

        try {
            RazorpayClient razorpay = new RazorpayClient(RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET);

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", (int)(totalPrice * 100)); // convert rupees to paise
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "txn_" + bookingId);
            orderRequest.put("payment_capture", 1);

            Order order = razorpay.orders.create(orderRequest);

            // Save order_id in DB
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068")) {
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE booking SET razorpay_order_id=?, payment_status='PENDING' WHERE booking_id=?");
                ps.setString(1, order.get("id"));
                ps.setInt(2, bookingId);
                ps.executeUpdate();
            }

            // Send data to checkout page
            request.setAttribute("order_id", order.get("id"));
            request.setAttribute("key_id", RAZORPAY_KEY_ID);
            request.setAttribute("amount", totalPrice);
            request.setAttribute("booking_id", bookingId);

            RequestDispatcher rd = request.getRequestDispatcher("razorpay_checkout.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Razorpay Order creation failed", e);
        }
    }
}
