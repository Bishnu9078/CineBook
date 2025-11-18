<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Get movie ID
    String movieIdParam = request.getParameter("movie_id");
    int movieId = 0;
    if (movieIdParam != null && !movieIdParam.trim().isEmpty()) {
        movieId = Integer.parseInt(movieIdParam);
    } else {
        response.sendRedirect("userDashboard.jsp");
        return;
    }

    // Fetch movie details
    String title = "Unknown Movie", theater = "Inox Bhubaneswar";
    double price = 0.0;
    String showTimesRaw = "";
    String[] showTimes = {};

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
        PreparedStatement ps = conn.prepareStatement("SELECT title, theater, price, show_time FROM movies WHERE id=?");
        ps.setInt(1, movieId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            theater = rs.getString("theater");
            price = rs.getDouble("price");
            showTimesRaw = rs.getString("show_time");
            if (showTimesRaw != null && !showTimesRaw.trim().isEmpty()) {
                showTimes = showTimesRaw.split(",");
            }
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%= title %> | Seat Booking</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background-color: #f8f9fa; font-family: 'Poppins', sans-serif; }
.seat { width: 40px; height: 40px; margin: 5px; border-radius: 8px; border: none; cursor: pointer; }
.available { background-color: #dee2e6; }
.selected { background-color: #28a745; color: white; }
.screen { text-align: center; margin: 20px 0; font-weight: 600; }
.summary-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
.btn-danger { background-color: #e50914; border: none; }
.time-btn { border: 1px solid #ccc; border-radius: 8px; padding: 10px 20px; cursor: pointer; background: #fff; transition: 0.3s; }
.time-btn.active { background: #e50914; color: #fff; border-color: #e50914; }
</style>
</head>

<body>
<div class="container mt-5">
    <div class="text-center mb-4">
        <h3 class="fw-bold"><%= title %></h3>
        <h6 class="text-muted">🎭 <%= theater %></h6>
        <div class="alert alert-info w-75 mx-auto">
            🎟 <strong>Ticket Price:</strong> ₹<%= price %> per seat
        </div>

        <div class="mt-3">
            <h6 class="fw-semibold mb-2">Select Showtime:</h6>
            <div class="d-flex justify-content-center gap-3 flex-wrap">
                <% if (showTimes.length > 0) {
                       for (String time : showTimes) { %>
                    <div class="time-btn" onclick="selectTime(this)"><%= time.trim() %></div>
                <% } } else { %>
                    <p class="text-muted">No showtimes available for this movie.</p>
                <% } %>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8 text-center">
            <h5 class="fw-semibold">Select Your Seats</h5>
            <div class="screen">🖥 SCREEN</div>
            <div class="d-flex flex-wrap justify-content-center">
                <% for(char row='A'; row<='E'; row++) {
                       for(int i=1; i<=8; i++) { %>
                    <button type="button" class="seat available" onclick="toggleSeat(this)">
                        <%= row %><%= i %>
                    </button>
                <% }} %>
            </div>
        </div>

        <div class="col-md-4">
            <div class="summary-card">
                <h5 class="fw-bold">Booking Summary</h5>
                <hr>
                <p><strong>Movie:</strong> <%= title %></p>
                <p><strong>Theater:</strong> <%= theater %></p>
                <p><strong>Showtime:</strong> <span id="summaryTime">Not Selected</span></p>
                <p><strong>Price per Seat:</strong> ₹<%= price %></p>
                <p><strong>Selected Seats:</strong> <span id="summarySeats">None</span></p>
                <p><strong>Total:</strong> <span id="summaryTotal">₹0.00</span></p>

                <!-- 📅 Date Picker -->
                <div class="mt-3">
                    <label for="bookingDate" class="fw-semibold">📅 Select Date:</label>
                    <input type="date" id="bookingDate" class="form-control" required
                           min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>

                <form action="BookingServlet" method="post" onsubmit="return validateBookingForm();">
                    <input type="hidden" name="movie_id" value="<%= movieId %>">
                    <input type="hidden" name="show_time" id="showTimeValue">
                    <input type="hidden" name="seats" id="seatList">
                    <input type="hidden" name="total_price" id="totalPrice">
                    <input type="hidden" id="selectedDate" name="selected_date">
                    <button type="submit" class="btn btn-danger w-100 mt-3">Proceed To Pay</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
const pricePerSeat = <%= price %>;

function selectTime(elem) {
    document.querySelectorAll('.time-btn').forEach(btn => btn.classList.remove('active'));
    elem.classList.add('active');
    document.getElementById("summaryTime").innerText = elem.innerText;
    document.getElementById("showTimeValue").value = elem.innerText;
}

function toggleSeat(seat) {
    seat.classList.toggle("selected");
    updateSummary();
}

function updateSummary() {
    let selected = document.querySelectorAll(".selected");
    let seatList = Array.from(selected).map(s => s.innerText);
    let total = seatList.length * pricePerSeat;
    document.getElementById("seatList").value = seatList.join(",");
    document.getElementById("totalPrice").value = total.toFixed(2);
    document.getElementById("summarySeats").innerText = seatList.join(", ") || "None";
    document.getElementById("summaryTotal").innerText = "₹" + total.toFixed(2);
}

function validateBookingForm() {
    const dateInput = document.getElementById("bookingDate").value;
    if (!dateInput) {
        alert("Please select a booking date!");
        return false;
    }
    document.getElementById("selectedDate").value = dateInput;
    return true;
}
</script>
</body>
</html>
