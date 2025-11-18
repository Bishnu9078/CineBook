<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.net.URLEncoder" %>

<%
    // --- Get movie ID safely ---
    String movieIdParam = request.getParameter("id");
    int movieId = 0;

    // Declare variables
    String title = "Unknown Movie", genre = "N/A", duration = "N/A", theater = "N/A", showTime = "N/A";
    String imageUrl = "https://via.placeholder.com/400x500?text=No+Image";
    String description = "No description available.", castCrew = "Cast & Crew information not available.";
    double price = 0.0, rating = 0.0;
    int userReviews = 0, criticsScore = 0, watchlistCount = 0;
    java.sql.Date releaseDate = null;
    boolean hasTrailer = false;

    if (movieIdParam != null && movieIdParam.matches("\\d+")) {
        movieId = Integer.parseInt(movieIdParam);

        try (Connection conn = DriverManager.getConnection(
                 "jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM movies WHERE id = ?")) {

            Class.forName("com.mysql.cj.jdbc.Driver");
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                title = rs.getString("title");
                genre = rs.getString("genre");
                duration = rs.getString("duration");
                theater = rs.getString("theater");
                showTime = rs.getString("show_time");
                imageUrl = rs.getString("image_url");
                description = rs.getString("description");
                price = rs.getDouble("price");
                releaseDate = rs.getDate("release_date");
                rating = rs.getDouble("rating");
                userReviews = rs.getInt("user_reviews");
                criticsScore = rs.getInt("critics_score");
                watchlistCount = rs.getInt("watchlist_count");
                castCrew = rs.getString("cast_crew");
                hasTrailer = (rs.getBlob("trailer_link") != null);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- Handle Redirect Actions ---
    String action = request.getParameter("action");
    if ("book".equals(action)) {
        response.sendRedirect("booking_admin.jsp?movie_id=" + movieId +
            "&title=" + URLEncoder.encode(title, "UTF-8") +
            "&price=" + price);
        return;
    } else if ("back".equals(action)) {
        RequestDispatcher rd = request.getRequestDispatcher("userDashboard.jsp");
        rd.forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= title %> | Movie Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: radial-gradient(circle at top left, #141414, #000);
            color: #f5f5f5;
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
        }
        .movie-card {
            background: linear-gradient(145deg, #1b1b1b, #202020);
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(255, 60, 0, 0.25);
            padding: 30px;
            margin-top: 40px;
        }
        .movie-poster {
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);
            transition: transform 0.3s;
        }
        .movie-poster:hover {
            transform: scale(1.03);
        }
        h2 {
            color: #ff3c00;
            font-weight: 700;
        }
        .price {
            font-size: 1.3rem;
            color: #ff6b00;
            font-weight: 600;
        }
        .stats-box {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 20px;
        }
        .stat {
            background-color: #242424;
            border-radius: 10px;
            padding: 12px;
            text-align: center;
            flex: 1 1 150px;
            box-shadow: 0 0 10px rgba(255, 60, 0, 0.15);
        }
        .stat h4 {
            color: #ff3c00;
            margin: 0;
        }
        .cast-section {
            background-color: #181818;
            border-left: 4px solid #ff3c00;
            padding: 20px;
            border-radius: 10px;
            margin-top: 25px;
        }
        .btn-main {
            background: linear-gradient(135deg, #ff3c00, #ff6600);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 10px 25px;
            font-weight: 600;
            margin: 10px 10px 0 0;
            transition: all 0.3s ease;
        }
        .btn-main:hover {
            transform: scale(1.05);
            background: linear-gradient(135deg, #ff6600, #ff3c00);
        }
        video {
            border-radius: 10px;
            width: 100%;
            height: 400px;
            margin-top: 20px;
        }
        .meta {
            color: #bbb;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="container movie-card">
    <div class="row align-items-center">
        <div class="col-md-4 text-center">
            <img src="<%= imageUrl %>" alt="<%= title %>" class="movie-poster img-fluid">
        </div>

        <div class="col-md-8">
            <h2><%= title %></h2>
            <p class="meta"><strong>Genre:</strong> <%= genre %> | 
               <strong>Duration:</strong> <%= duration %> | 
               <strong>Release:</strong> <%= (releaseDate != null ? releaseDate : "N/A") %></p>

            <p><strong>Theater:</strong> <%= theater %> &nbsp; • &nbsp;
               <strong>Showtime:</strong> <%= showTime %></p>

            <p class="mt-3"><%= description %></p>
            <p class="price">🎟 ₹<%= String.format("%.2f", price) %></p>

            <!-- 🎬 Stats Section -->
            <div class="stats-box">
                <div class="stat"><h4><%= String.format("%.1f", rating) %></h4><p>⭐ Rating</p></div>
                <div class="stat"><h4><%= userReviews %></h4><p>💬 Reviews</p></div>
                <div class="stat"><h4><%= criticsScore %>%</h4><p>🎯 Critics</p></div>
                <div class="stat"><h4><%= watchlistCount %></h4><p>👀 Watchlist</p></div>
            </div>

            <!-- 🎥 Trailer Section -->
            <% if (hasTrailer) { %>
                <div class="mt-4">
                    <h4>🎥 Watch Trailer</h4>
                    <video controls>
                        <source src="TrailerServlet?id=<%= movieId %>" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                </div>
            <% } else { %>
                <p class="text-muted mt-3">🎞 Trailer not available</p>
            <% } %>

            <!-- 🎭 Cast Section -->
            <div class="cast-section mt-3">
                <h5 class="text-warning">🎭 Cast & Crew</h5>
                <p><%= castCrew %></p>
            </div>

            <!-- Redirect Buttons -->
            <form method="post" class="mt-4">
                <button type="submit" name="action" value="book" class="btn-main">🎟 Book Now</button>
                <button type="submit" name="action" value="back" class="btn-main">⬅ Back</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
