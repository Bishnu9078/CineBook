<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ---- Fetch from session first ----
    String theater = (String) sessionObj.getAttribute("theater_name");
    String showTime = (String) sessionObj.getAttribute("show_time");
    String seats = (String) sessionObj.getAttribute("seats");
    String bookingDate = (String) sessionObj.getAttribute("booking_date");
    Double total = sessionObj.getAttribute("total_price") != null
            ? Double.parseDouble(sessionObj.getAttribute("total_price").toString())
            : 0.0;
    Integer bookingId = sessionObj.getAttribute("booking_id") != null
            ? Integer.parseInt(sessionObj.getAttribute("booking_id").toString())
            : 0;

    // ---- Fallback: if theater or showTime missing, pull fresh from DB ----
    if ((theater == null || theater.trim().isEmpty()) && bookingId > 0) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068")) {
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT theater_name, show_time, seats, booking_date, total_price FROM booking WHERE booking_id=?");
                ps.setInt(1, bookingId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    theater = rs.getString("theater_name");
                    showTime = rs.getString("show_time");
                    seats = rs.getString("seats");
                    bookingDate = rs.getString("booking_date");
                    total = rs.getDouble("total_price");

                    // ✅ Sync back into session for future use
                    sessionObj.setAttribute("theater_name", theater);
                    sessionObj.setAttribute("show_time", showTime);
                    sessionObj.setAttribute("seats", seats);
                    sessionObj.setAttribute("booking_date", bookingDate);
                    sessionObj.setAttribute("total_price", total);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(new java.io.PrintWriter(out));
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Confirm Payment - Cinema Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f7fa;
            font-family: 'Poppins', sans-serif;
        }
        .payment-container {
            max-width: 550px;
            margin: 100px auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            padding: 40px;
        }
        h3 {
            text-align: center;
            color: #e50914;
            font-weight: 700;
            margin-bottom: 30px;
        }
        .details p {
            margin: 10px 0;
            font-size: 16px;
            color: #333;
        }
        .details strong {
            color: #000;
        }
        .btn-pay {
            background-color: #e50914;
            border: none;
            color: white;
            font-weight: 600;
            padding: 14px 20px;
            border-radius: 10px;
            width: 100%;
            margin-top: 20px;
            transition: 0.3s;
        }
        .btn-pay:hover {
            background-color: #b00610;
        }
    </style>
</head>

<body>
    <div class="payment-container">
        <h3>Confirm Your Payment</h3>

        <div class="details">
            <p><strong>Theater:</strong> <%= (theater != null ? theater : "N/A") %></p>
            <p><strong>Show Time:</strong> <%= (showTime != null ? showTime : "N/A") %></p>
            <p><strong>Seats:</strong> <%= (seats != null ? seats : "N/A") %></p>
            
            <p><strong>Date:</strong> <%= (bookingDate != null ? bookingDate : "N/A") %></p>
            <hr>
            <p><strong>Total Amount:</strong> ₹<%= total %></p>
        </div>

        <form action="PaymentServlet" method="post">
            <input type="hidden" name="booking_id" value="<%= bookingId %>">
            <input type="hidden" name="total_price" value="<%= total %>">
            <button type="submit" class="btn-pay">Proceed to Pay</button>
        </form>
    </div>
</body>
</html>
