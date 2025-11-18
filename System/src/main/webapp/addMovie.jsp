<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Role-based access restriction ---
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Movie | Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #1e1e2f, #2e2e3e);
            color: #fff;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .form-container {
            background: #2b2b3c;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(255, 60, 0, 0.3);
            width: 480px;
        }
        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #ff3c00;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border-radius: 8px;
            border: 1px solid #444;
            background: #1e1e2f;
            color: #fff;
            font-size: 15px;
        }
        input:focus, textarea:focus {
            border-color: #ff3c00;
            outline: none;
        }
        button {
            width: 100%;
            background: #ff3c00;
            color: #fff;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-top: 10px;
            transition: 0.3s;
        }
        button:hover {
            background: #ff5722;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #ff3c00;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        label {
            font-weight: 600;
            margin-top: 5px;
            color: #ffa07a;
        }
        hr {
            border-color: #ff3c00;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>🎬 Add New Movie</h2>

    <!-- ✅ Enable File Upload -->
    <form action="AddMovieServlet" method="post" enctype="multipart/form-data">

        <label>Movie Title</label>
        <input type="text" name="title" placeholder="Movie Title" required>

        <label>Genre</label>
        <input type="text" name="genre" placeholder="Genre">

        <label>Duration</label>
        <input type="text" name="duration" placeholder="Duration (e.g. 2h 30mins)">

        <label>Theater Name</label>
        <input type="text" name="theater" placeholder="Theater Name">

        <label>Show Time</label>
        <input type="text" name="show_time" placeholder="Show Time (e.g. 6:30 PM)">

        <label>Ticket Price (₹)</label>
        <input type="number" name="price" step="0.01" placeholder="Ticket Price (₹)">

        <label>Release Date</label>
        <input type="date" name="release_date">

        <label>Image URL</label>
        <input type="text" name="image_url" placeholder="Image URL">

        <label>Description</label>
        <textarea name="description" placeholder="Description"></textarea>

        <hr>

        <label>Rating (Out of 10)</label>
        <input type="number" step="0.1" name="rating" min="0" max="10" placeholder="e.g. 8.6">

        <label>User Reviews (Count)</label>
        <input type="number" name="user_reviews" min="0" placeholder="e.g. 200000">

        <label>Critics Score (Out of 100)</label>
        <input type="number" name="critics_score" min="0" max="100" placeholder="e.g. 85">

        <label>Watchlist Count</label>
        <input type="number" name="watchlist_count" min="0" placeholder="e.g. 1500000">

        <label>Cast & Crew</label>
        <textarea name="cast_crew" placeholder="e.g. Lead: Shah Rukh Khan, Director: Rajkumar Hirani"></textarea>

      
        <label>Trailer Video (MP4)</label>
        <input type="file" name="trailer_link" accept="video/mp4">

        <button type="submit">Add Movie</button>
    </form>

    <a href="manageMovies.jsp" class="back-link">⬅ Back to Manage Movies</a>
</div>

</body>
</html>
