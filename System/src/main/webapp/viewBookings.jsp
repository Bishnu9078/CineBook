<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>

<%
    // ✅ Role check (admin only)
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Back button and filter handling
    String action = request.getParameter("action");
    if ("dashboard".equals(action)) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }

    // ✅ Filter params
    String timeFilter = request.getParameter("timeFilter");
    if (timeFilter == null) timeFilter = "all";

    String paymentFilter = request.getParameter("paymentFilter");
    if (paymentFilter == null) paymentFilter = "all";

    // ✅ Database setup
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");

    // ✅ Dynamic SQL builder
    StringBuilder query = new StringBuilder("SELECT * FROM booking WHERE 1=1");

    // 🕒 Time filter conditions
    if ("weekly".equals(timeFilter)) {
        query.append(" AND created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK)");
    } else if ("monthly".equals(timeFilter)) {
        query.append(" AND created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)");
    }

    // 💳 Payment status conditions
    if ("success".equalsIgnoreCase(paymentFilter)) {
        query.append(" AND payment_status = 'SUCCESS'");
    } else if ("pending".equalsIgnoreCase(paymentFilter)) {
        query.append(" AND payment_status = 'PENDING'");
    } else if ("failure".equalsIgnoreCase(paymentFilter)) {
        query.append(" AND payment_status = 'FAILURE'");
    }

    query.append(" ORDER BY booking_id DESC");

    PreparedStatement ps = conn.prepareStatement(query.toString());
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🎟 All Bookings | Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #1e1e2f;
            color: #fff;
            font-family: 'Poppins', sans-serif;
            padding: 25px;
        }

        h2 {
            text-align: center;
            color: #ff3c00;
            font-weight: 700;
            margin-bottom: 30px;
        }

        .filter-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #2b2b3c;
            padding: 12px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .filter-bar label {
            font-weight: 600;
            color: #ffa07a;
        }

        select {
            background-color: #222;
            color: white;
            border: 1px solid #ff3c00;
            border-radius: 6px;
            padding: 5px 10px;
            font-weight: 500;
        }

        select:hover {
            box-shadow: 0 0 15px rgba(255, 100, 0, 0.6);
        }

        .btn-back {
            background: #ff3c00;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 8px 15px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-back:hover {
            background: #ff5722;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #2b2b3c;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
        }

        th {
            background: #ff3c00;
            color: white;
            text-align: center;
            padding: 12px;
        }

        td {
            text-align: center;
            padding: 10px;
            color: #ddd;
        }

        tr:nth-child(even) {
            background-color: #333344;
        }

        tr:hover {
            background-color: #3e3e5c;
        }

        .status-success {
            color: lightgreen;
            font-weight: bold;
        }

        .status-pending {
            color: #ffcc00;
            font-weight: bold;
        }

        .status-failure {
            color: #ff4444;
            font-weight: bold;
        }

        .filter-status {
            text-align: center;
            color: #ffa07a;
            margin-bottom: 20px;
            font-weight: 600;
        }
    </style>
</head>

<body>

    <h2><i class="bi bi-ticket-detailed"></i> All Bookings</h2>

    <!-- 🔹 Filter Bar -->
    <div class="filter-bar">
        <form method="post" class="d-inline">
            <button type="submit" name="action" value="dashboard" class="btn-back">
                ⬅ Back to Dashboard
            </button>
        </form>

        <form method="get" class="d-flex align-items-center">
            <label class="me-2">Time Filter:</label>
            <select name="timeFilter" onchange="this.form.submit()" class="me-3">
                <option value="all" <%= "all".equals(timeFilter) ? "selected" : "" %>>All</option>
                <option value="weekly" <%= "weekly".equals(timeFilter) ? "selected" : "" %>>This Week</option>
                <option value="monthly" <%= "monthly".equals(timeFilter) ? "selected" : "" %>>This Month</option>
            </select>

            <label class="me-2">Payment:</label>
            <select name="paymentFilter" onchange="this.form.submit()">
                <option value="all" <%= "all".equals(paymentFilter) ? "selected" : "" %>>All</option>
                <option value="success" <%= "success".equals(paymentFilter) ? "selected" : "" %>>Success</option>
                <option value="pending" <%= "pending".equals(paymentFilter) ? "selected" : "" %>>Pending</option>
                <option value="failure" <%= "failure".equals(paymentFilter) ? "selected" : "" %>>Failure</option>
            </select>
        </form>
    </div>

    <!-- 🔹 Filter Status -->
    <div class="filter-status">
        Showing:
        <%= 
            (timeFilter.equals("weekly") ? "This Week’s " :
            timeFilter.equals("monthly") ? "This Month’s " : "All ") 
            + (paymentFilter.equals("all") ? "Bookings" :
            paymentFilter.substring(0, 1).toUpperCase() + paymentFilter.substring(1).toLowerCase() + " Bookings") 
        %>
    </div>

    <!-- 🔹 Table -->
    <table>
        <tr>
            <th>Booking ID</th>
            <th>User ID</th>
            <th>Movie ID</th>
            <th>Theater</th>
            <th>Seats</th>
            <th>Total Price (₹)</th>
            <th>Booking Date</th>
            <th>Show Time</th>
            <th>Payment Status</th>
            <th>Created At</th>
        </tr>

        <%
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            boolean hasData = false;

            while (rs.next()) {
                hasData = true;
                String paymentStatus = rs.getString("payment_status");
                String statusClass = "status-pending";
                if ("SUCCESS".equalsIgnoreCase(paymentStatus)) statusClass = "status-success";
                else if ("FAILURE".equalsIgnoreCase(paymentStatus)) statusClass = "status-failure";
        %>
            <tr>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getInt("movie_id") %></td>
                <td><%= rs.getString("theater_name") != null ? rs.getString("theater_name") : "—" %></td>
                <td><%= rs.getString("seats") != null ? rs.getString("seats") : "—" %></td>
                <td><%= rs.getDouble("total_price") %></td>
                <td><%= rs.getString("booking_date") != null ? rs.getString("booking_date") : "—" %></td>
                <td><%= rs.getString("show_time") != null ? rs.getString("show_time") : "—" %></td>
                <td class="<%= statusClass %>"><%= paymentStatus %></td>
                <td><%= rs.getTimestamp("created_at") != null ? sdf.format(rs.getTimestamp("created_at")) : "—" %></td>
            </tr>
        <%
            }

            if (!hasData) {
        %>
            <tr>
                <td colspan="10" style="text-align:center; color:#aaa;">No bookings found for this filter.</td>
            </tr>
        <%
            }

            rs.close();
            ps.close();
            conn.close();
        %>
    </table>

</body>
</html>
