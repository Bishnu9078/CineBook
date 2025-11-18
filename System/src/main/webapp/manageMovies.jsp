<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // ✅ Access control for admin
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Handle button-based navigation (sendRedirect)
    String action = request.getParameter("action");
    String id = request.getParameter("id");

    if ("add".equals(action)) {
        response.sendRedirect("addMovie.jsp");
        return;
    } else if ("back".equals(action)) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    } else if ("edit".equals(action) && id != null) {
        response.sendRedirect("editMovie.jsp?id=" + id);
        return;
    } else if ("delete".equals(action) && id != null) {
        response.sendRedirect("DeleteMovieServlet?id=" + id);
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Movies | Admin Panel</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #1e1e2f;
            color: #fff;
            padding: 30px;
        }
        h2 {
            color: #ff3c00;
            text-align: center;
            margin-bottom: 25px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: #2b2b3c;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.4);
        }
        th, td {
            padding: 10px 12px;
            text-align: center;
            vertical-align: middle;
        }
        th {
            background: #ff3c00;
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #333344;
        }
        tr:hover {
            background-color: #3e3e5c;
        }
        img.movie-thumb {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 6px;
        }
        .truncate {
            max-width: 180px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        button {
            background: #ff3c00;
            color: #fff;
            border: none;
            padding: 8px 14px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }
        button:hover {
            background: #ff5722;
        }
        .top-actions {
            text-align: center;
            margin-bottom: 20px;
        }
        .rating-box {
            color: #ffc107;
            font-weight: bold;
        }
    </style>
</head>

<body>

<h2>🎬 Manage Movies</h2>

<!-- ✅ Top buttons with sendRedirect -->
<div class="top-actions">
    <form method="post" style="display:inline;">
        <button type="submit" name="action" value="add">➕ Add New Movie</button>
    </form>
    <form method="post" style="display:inline;">
        <button type="submit" name="action" value="back">⬅ Back to Dashboard</button>
    </form>
</div>

<div class="table-responsive">
<table class="table table-dark table-striped align-middle">
    <thead>
        <tr>
            <th>ID</th>
            <th>Poster</th>
            <th>Title</th>
            <th>Genre</th>
            <th>Duration</th>
            <th>Theater</th>
            <th>Show Time</th>
            <th>Price (₹)</th>
            <th>Release Date</th>
            <th>Rating ⭐</th>
            <th>Reviews 💬</th>
            <th>Critics 🎯</th>
            <th>Watchlist 👀</th>
            <th>Cast & Crew</th>
            <th>Trailer</th>
            <th>Actions</th>
        </tr>
    </thead>

    <tbody>
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM movies ORDER BY id DESC");

            boolean hasMovies = false;
            while (rs.next()) {
                hasMovies = true;
    %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td>
                <img src="<%= rs.getString("image_url") != null && !rs.getString("image_url").isEmpty() ? rs.getString("image_url") : "https://via.placeholder.com/80x100?text=No+Image" %>" class="movie-thumb">
            </td>
            <td class="truncate"><%= rs.getString("title") %></td>
            <td><%= rs.getString("genre") %></td>
            <td><%= rs.getString("duration") %></td>
            <td><%= rs.getString("theater") %></td>
            <td><%= rs.getString("show_time") %></td>
            <td>₹<%= rs.getDouble("price") %></td>
            <td><%= rs.getDate("release_date") != null ? rs.getDate("release_date") : "N/A" %></td>
            <td class="rating-box"><%= rs.getDouble("rating") %></td>
            <td><%= rs.getInt("user_reviews") %></td>
            <td><%= rs.getInt("critics_score") %>%</td>
            <td><%= rs.getInt("watchlist_count") %></td>
            <td class="truncate"><%= rs.getString("cast_crew") != null ? rs.getString("cast_crew") : "—" %></td>
            <td><%= (rs.getString("trailer_link") != null && !rs.getString("trailer_link").isEmpty()) ? "Available" : "—" %></td>

            <td>
                <form method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <button type="submit" name="action" value="edit">✏️ Edit</button>
                </form>
                <form method="post" style="display:inline;" onsubmit="return confirm('Delete this movie?');">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <button type="submit" name="action" value="delete">🗑 Delete</button>
                </form>
            </td>
        </tr>
    <%
            }
            if (!hasMovies) {
    %>
        <tr><td colspan="16" class="text-center text-muted py-4">No movies found.</td></tr>
    <%
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<tr><td colspan='16'><pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre></td></tr>");
        }
    %>
    </tbody>
</table>
</div>

</body>
</html>
