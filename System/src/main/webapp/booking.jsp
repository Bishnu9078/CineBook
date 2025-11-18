<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Show seat conflict message if exists
    String seatError = (String) sess.getAttribute("seat_error");
    if (seatError != null) {
%>
    <div class="alert alert-danger text-center fw-semibold" id="seatAlert" role="alert">
        <%= seatError %>
    </div>
<%
        sess.removeAttribute("seat_error");
    }
%>

<%
    String movieIdParam = request.getParameter("movie_id");
    int movieId = 0;
    if (movieIdParam != null && !movieIdParam.trim().isEmpty()) {
        movieId = Integer.parseInt(movieIdParam);
    } else {
        response.sendRedirect("userDashboard.jsp");
        return;
    }

    String title = "Unknown Movie", showTime = "N/A";
    double price = 0.0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
             PreparedStatement ps = conn.prepareStatement(
                "SELECT title, show_time, price FROM movies WHERE id=?")) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                title = rs.getString("title");
                showTime = rs.getString("show_time");
                price = rs.getDouble("price");
            }
        }
    } catch (Exception e) { e.printStackTrace(new java.io.PrintWriter(out)); }

    java.util.Set<String> bookedSeats = new java.util.HashSet<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
             PreparedStatement ps = conn.prepareStatement(
                "SELECT seats FROM booking WHERE movie_id=? AND payment_status='SUCCESS'")) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String seatStr = rs.getString("seats");
                if (seatStr != null && !seatStr.trim().isEmpty()) {
                    for (String s : seatStr.split(",")) {
                        bookedSeats.add(s.trim().toUpperCase());
                    }
                }
            }
        }
    } catch (Exception e) { e.printStackTrace(new java.io.PrintWriter(out)); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%= title %> | Seat Booking</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #f8f9fa; font-family: 'Poppins', sans-serif; }
    .seat { width: 42px; height: 42px; margin: 6px; border-radius: 8px; border: none; cursor: pointer; font-weight: 600; transition: transform 0.2s; }
    .available { background-color: #dee2e6; color: #000; } /* Gray for available */
    .selected { background-color: #28a745; color: #fff; transform: scale(1.1); } /* Green for selected */
    .sold { background-color: #dc3545; color: #fff; cursor: not-allowed; } /* Red for booked */
    .legend { margin-top: 25px; display: flex; justify-content: center; gap: 25px; }
    .legend div { display: flex; align-items: center; gap: 8px; }
    .legend-box { width: 20px; height: 20px; border-radius: 4px; }
    .available-box { background: #dee2e6; }
    .selected-box { background: #28a745; }
    .sold-box { background: #dc3545; }
</style>
</head>

<body>
<div class="container mt-5">
    <div class="text-center mb-4">
        <h3><%= title %></h3>
        <h6 class="text-muted">🎭 Inox Bhubaneswar | 🕒 <%= showTime %></h6>
        <div class="alert alert-info w-75 mx-auto">
            🎟 <strong>Ticket Price:</strong> ₹<%= price %> per seat
        </div>
    </div>

    <div class="row">
        <div class="col-md-8 text-center">
            <h5 class="fw-semibold">Select Your Seats</h5>
            <div class="screen mb-3 fw-bold">🖥 SCREEN</div>

            <div class="d-flex flex-wrap justify-content-center">
                <% 
                    for (char row = 'A'; row <= 'E'; row++) {
                        for (int i = 1; i <= 8; i++) {
                            String seat = (row + String.valueOf(i)).toUpperCase();
                            boolean booked = bookedSeats.contains(seat);
                %>
                    <button 
                        class="seat <%= booked ? "sold" : "available" %>"
                        <%= booked ? "disabled" : "" %>
                        onclick="toggleSeat(this)">
                        <%= seat %>
                    </button>
                <% }
                   out.print("<div style='width:100%;height:10px;'></div>");
                 } %>
            </div>

            <div class="legend mt-4">
                <div><div class="legend-box available-box"></div> Available</div>
                <div><div class="legend-box selected-box"></div> Selected</div>
                <div><div class="legend-box sold-box"></div> Booked</div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="bg-white p-3 rounded shadow">
                <h5 class="fw-bold">Booking Summary</h5>
                <hr>
                <p><strong>Movie:</strong> <%= title %></p>
                <p><strong>Theater:</strong> Inox Bhubaneswar</p>
                <p><strong>Showtime:</strong> <%= showTime %></p>
                <p><strong>Price per Seat:</strong> ₹<%= price %></p>
                <p><strong>Selected:</strong> <span id="summarySeats">None</span></p>
                <p><strong>Total:</strong> <span id="summaryTotal">₹0.00</span></p>

                <form action="BookingServlet" method="post">
                    <input type="hidden" name="movie_id" value="<%= movieId %>">
                    <input type="hidden" name="theater_name" value="Inox Bhubaneswar">
                    <input type="hidden" name="show_time" value="<%= showTime %>">
                    <input type="hidden" name="seats" id="seatList">
                    <input type="hidden" name="total_price" id="totalPrice">
                    <button type="submit" class="btn btn-danger w-100 mt-3" id="proceedBtn" disabled>
                        Proceed to Pay
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
const pricePerSeat = <%= price %>;

function toggleSeat(seat) {
    if (seat.classList.contains("sold")) return;
    seat.classList.toggle("selected");
    updateSummary();
}

function updateSummary() {
    const selected = document.querySelectorAll(".seat.selected");
    const seatLabels = Array.from(selected).map(s => s.innerText);
    const total = seatLabels.length * pricePerSeat;
    document.getElementById("seatList").value = seatLabels.join(",");
    document.getElementById("totalPrice").value = total.toFixed(2);
    document.getElementById("summarySeats").innerText = seatLabels.length ? seatLabels.join(", ") : "None";
    document.getElementById("summaryTotal").innerText = "₹" + total.toFixed(2);
    document.getElementById("proceedBtn").disabled = seatLabels.length === 0;
}

// Auto-hide alert banner after 4 seconds
const alertBox = document.getElementById('seatAlert');
if (alertBox) {
    setTimeout(() => alertBox.style.display = 'none', 4000);
}
</script>
</body>
</html>
