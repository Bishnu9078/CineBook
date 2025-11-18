<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int bookingId = request.getParameter("booking_id") != null ?
        Integer.parseInt(request.getParameter("booking_id")) :
        (sess.getAttribute("booking_id") != null ? (int) sess.getAttribute("booking_id") : 0);

    if (bookingId == 0) {
        out.println("<h3 style='color:red;text-align:center;'>Invalid or Missing Booking ID</h3>");
        return;
    }

    int userId = 0;
    String theater = "-", seats = "-", bookingDate = "-", showTime = "-";
    double totalPrice = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT user_id, theater_name, seats, booking_date, show_time, total_price FROM booking WHERE booking_id=?")) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("user_id");
                theater = rs.getString("theater_name");
                seats = rs.getString("seats");
                bookingDate = rs.getString("booking_date");
                showTime = rs.getString("show_time");
                totalPrice = rs.getDouble("total_price");
            }
        }
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>🎟 Cinema Ticket</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<style>
body { background-color: #f4f7fa; font-family: 'Poppins', sans-serif; }
.ticket-card { max-width: 500px; margin: 80px auto; background: white; border-radius: 16px; box-shadow: 0 6px 20px rgba(0,0,0,0.1); padding: 40px; text-align: center; }
.ticket-card h3 { color: #e50914; font-weight: 700; }
.btn-custom { border-radius: 8px; font-weight: 600; margin: 5px; }
</style>
</head>

<body>
<div class="ticket-card" id="ticket">
    <h3>🎬 Cinema Ticket</h3>
    <hr>
    <p><strong>User ID:</strong> <%= userId %></p>
    <p><strong>Booking ID:</strong> <%= bookingId %></p>
    <p><strong>Theater:</strong> <%= theater %></p>
    <p><strong>Seats:</strong> <%= seats %></p>
    <p><strong>Date:</strong> <%= bookingDate %></p>
    <p><strong>Show Time:</strong> <%= showTime %></p>
    <p><strong>Total:</strong> ₹<%= totalPrice %></p>
    <hr>
    <p class="text-success fw-bold">✅ Booking Confirmed</p>

    <button class="btn btn-success btn-custom" onclick="downloadTicket()">⬇️ Download Ticket</button>
    <button class="btn btn-primary btn-custom" onclick="window.location.href='userDashboard.jsp'">🏠 Back to Dashboard</button>
</div>

<script>
function downloadTicket() {
    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF('p', 'mm', 'a4');

    pdf.setFillColor(229, 9, 20);
    pdf.rect(0, 0, 210, 30, 'F');
    pdf.setTextColor(255, 255, 255);
    pdf.setFontSize(22);
    pdf.text("🎟 Cinema Ticket", 70, 20);

    pdf.setTextColor(0, 0, 0);
    pdf.setFontSize(12);
    pdf.text("User ID: <%= userId %>", 20, 50);
    pdf.text("Booking ID: <%= bookingId %>", 20, 60);
    pdf.text("Theater: <%= theater %>", 20, 70);
    pdf.text("Seats: <%= seats %>", 20, 80);
    
    pdf.text("Date: <%= bookingDate %>", 20, 90);
    pdf.text("Show Time: <%= showTime %>", 20, 100);
    pdf.text("Total: ₹<%= totalPrice %>", 20, 110);
    pdf.text("✅ Booking Confirmed", 70, 130);

    pdf.save("Cinema_Ticket_<%= bookingId %>.pdf");
}
</script>
</body>
</html>
