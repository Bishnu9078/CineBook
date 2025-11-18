<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // --- Session check (admin only) ---
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    int movieId = 0;
    if (request.getParameter("id") != null) {
        movieId = Integer.parseInt(request.getParameter("id"));
    } else {
        out.println("<h3 style='color:red;text-align:center;'>❌ Invalid Movie ID!</h3>");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");

        ps = conn.prepareStatement("SELECT * FROM movies WHERE id=?");
        ps.setInt(1, movieId);
        rs = ps.executeQuery();

        if (!rs.next()) {
            out.println("<h3 style='color:red;text-align:center;'>Movie not found!</h3>");
            return;
        }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🎬 Edit Movie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: radial-gradient(circle at top left, #141414, #000);
            color: #fff;
            padding: 40px;
        }
        .edit-container {
            max-width: 500px;
            background: #2b2b3c;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(255,60,0,0.3);
            margin: auto;
        }
        h2 {
            text-align: center;
            color: #ff3c00;
            font-weight: 700;
            margin-bottom: 25px;
        }
        input, textarea {
            width: 100%;
            border: none;
            border-radius: 8px;
            padding: 12px;
            margin: 8px 0;
            background-color: #1e1e2f;
            color: #fff;
        }
        input:focus, textarea:focus {
            outline: none;
            box-shadow: 0 0 10px rgba(255,60,0,0.5);
        }
        .btn-update {
            width: 100%;
            background: linear-gradient(135deg, #ff3c00, #ff6600);
            border: none;
            padding: 12px;
            color: white;
            font-weight: 600;
            border-radius: 8px;
            transition: 0.3s;
        }
        .btn-update:hover {
            transform: scale(1.05);
            background: linear-gradient(135deg, #ff6600, #ff3c00);
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #ff3c00;
            font-weight: 600;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .alert {
            max-width: 500px;
            margin: 0 auto 20px auto;
        }
    </style>
</head>

<body>

    <%
        String updated = request.getParameter("updated");
        String error = request.getParameter("error");
        if (updated != null) {
    %>
        <div class="alert alert-success text-center">✅ Movie updated successfully!</div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger text-center">❌ Failed to update movie. Try again.</div>
    <% } %>

    <div class="edit-container">
        <h2>✏️ Edit Movie</h2>

        <form action="UpdateMovieServlet" method="post">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

            <input type="text" name="title" value="<%= rs.getString("title") %>" placeholder="Movie Title" required>
            <input type="text" name="genre" value="<%= rs.getString("genre") %>" placeholder="Genre">
            <input type="text" name="duration" value="<%= rs.getString("duration") %>" placeholder="Duration">
            <input type="text" name="theater" value="<%= rs.getString("theater") %>" placeholder="Theater Name">
            <input type="text" name="show_time" value="<%= rs.getString("show_time") %>" placeholder="Show Times (comma-separated)">
            <input type="number" step="0.01" name="price" value="<%= rs.getDouble("price") %>" placeholder="Price (₹)">
            <input type="date" name="release_date" value="<%= rs.getString("release_date") %>">
            <input type="text" name="image_url" value="<%= rs.getString("image_url") %>" placeholder="Poster Image URL">
            <textarea name="description" placeholder="Description" rows="4"><%= rs.getString("description") %></textarea>

            <button type="submit" class="btn-update">Update Movie</button>
        </form>

        <form action="manageMovies.jsp" method="post" style="margin-top:15px;">
            <button type="submit" class="btn btn-link text-warning fw-bold text-decoration-none w-100">
                ⬅ Back to Manage Movies
            </button>
        </form>
    </div>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
