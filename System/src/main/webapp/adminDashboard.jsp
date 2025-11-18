<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Prevent browser from caching this page ---
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // --- Validate Admin Session ---
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");

    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | Cinema Booking</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #1e1e2f, #2e2e3e);
            color: #fff;
            text-align: center;
            padding: 50px;
        }
        h1 {
            color: #ff3c00;
            margin-bottom: 40px;
        }
        a {
            display: inline-block;
            margin: 10px;
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            background: #ff3c00;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        a:hover {
            background: #ff5722;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <h1>🎬 Welcome Admin, <%= username %>!</h1>

    <a href="manageMovies.jsp" class="btn">Manage Movies</a>
    <a href="viewBookings.jsp" class="btn">View All Bookings</a>
    <a href="logout.jsp" class="btn">Logout</a>
</body>
</html>
