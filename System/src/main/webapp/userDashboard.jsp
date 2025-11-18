<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    // Disable browser cache
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Session Validation
    HttpSession sessionObj = request.getSession(false);
    String role = (sessionObj != null) ? (String) sessionObj.getAttribute("role") : null;
    String username = (sessionObj != null) ? (String) sessionObj.getAttribute("username") : null;

    if (role == null || !"user".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle User Actions
    String action = request.getParameter("action");
    if (action != null) {
        if (action.equals("logout")) {
            sessionObj.invalidate();
            response.sendRedirect("login.jsp");
            return;
        } 
        else if (action.equals("home")) {
            response.sendRedirect("userDashboard.jsp");
            return;
        } 
        else if (action.equals("details")) {
            String movieId = request.getParameter("movie_id");
            if (movieId != null && !movieId.trim().isEmpty()) {
                // Redirect to movie-details.jsp with movie ID
                response.sendRedirect("movie-details.jsp?id=" + movieId);
                return;
            } else {
                out.println("<script>alert('Movie ID not found.');</script>");
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - Cinema Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #fff; color: #000; }
        .navbar { background-color: #fff; border-bottom: 2px solid #e5e5e5; padding: 15px 50px; }
        .navbar-brand { font-weight: 800; font-size: 1.6rem; color: red; }
        .search-bar { width: 40%; }
        .nav-link { color: #000 !important; font-weight: 600; margin-left: 15px; }
        .nav-link:hover { color: red !important; }
        .image-gallery { background: #e5e5e5; height: 350px; overflow: hidden; margin: 30px auto; }
        .carousel-item img { height: 350px; object-fit: cover; width: 100%; margin-top: 20px; }
        .carousel-caption { background: rgba(0, 0, 0, 0.6); border-radius: 10px; padding: 10px 20px; }
        .section-title { font-weight: bold; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .movie-card {
            background-color: #fff; border-radius: 10px; overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4); transition: transform 0.3s;
            text-align: center;
        }
        .movie-card:hover { transform: scale(1.03); }
        .movie-card img { width: 100%; height: 250px; object-fit: cover; }
        .movie-info {
            background-color: #000; color: #fff; font-size: 0.8rem;
            padding: 5px 10px; display: flex; justify-content: space-between;
        }
        .movie-title { text-align: center; font-weight: 600; margin: 10px 0; }
        .view-btn {
            display: inline-block; margin: 10px auto; padding: 8px 16px;
            background: linear-gradient(135deg, #e50914, #ff4b2b); color: #fff;
            text-decoration: none; font-weight: bold; border-radius: 8px;
            box-shadow: 0 4px 10px rgba(229, 9, 20, 0.4); transition: all 0.3s; border: none;
        }
        .view-btn:hover {
            background: linear-gradient(135deg, #ff4b2b, #ff6a00);
            box-shadow: 0 0 20px rgba(255, 75, 43, 0.7);
            transform: scale(1.08);
        }
        footer { background-color: #333; color: #ccc; padding: 25px 0; margin-top: 50px; }
        footer .icon-box { text-align: center; }
        footer i { font-size: 1.8rem; color: red; }
        footer p { font-size: 0.9rem; margin-top: 10px; }
    </style>
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar navbar-expand-lg">
    <a class="navbar-brand">CINEMA BOOK</a>
    <form class="d-flex mx-auto search-bar" id="searchForm">
        <input class="form-control me-2" id="searchInput" type="search" placeholder="Search movies...">
        <button class="btn btn-dark" type="submit">Search</button>
    </form>
    <div class="d-flex align-items-center">
        <span class="me-3 fw-bold text-dark">Welcome, <%= username %>!</span>
        <form method="post" class="d-inline">
            <button type="submit" name="action" value="home" class="btn btn-link text-dark fw-bold text-decoration-none">Home</button>
        </form>
        <form method="post" class="d-inline">
            <button type="submit" name="action" value="logout" class="btn btn-link text-dark fw-bold text-decoration-none">Logout</button>
        </form>
    </div>
</nav>

<!-- ===== IMAGE GALLERY ===== -->
<div id="galleryCarousel" class="carousel slide image-gallery" data-bs-ride="carousel">
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://assets-in.bmscdn.com/discovery-catalog/events/et00429289-zpwhxvksvs-landscape.jpg" alt="NARSHIMA">
            <div class="carousel-caption"><h5>NARSHIMA</h5></div>
        </div>
        <div class="carousel-item">
            <img src="https://assets-in.bmscdn.com/iedb/movies/images/mobile/listing/large/coolie-et00395817-1755153511.jpg" alt="Coolie">
            <div class="carousel-caption"><h5>COOLIE</h5></div>
        </div>
        <div class="carousel-item">
            <img src="https://assets-in.bmscdn.com/iedb/movies/images/mobile/listing/xxlarge/kantara-a-legend-chapter-1-et00377351-1760336092.jpg" alt="Kantara">
            <div class="carousel-caption"><h5>KANTARA</h5></div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#galleryCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon bg-dark rounded-circle"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#galleryCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon bg-dark rounded-circle"></span>
    </button>
</div>

<!-- ===== MOVIE LIST ===== -->
<div class="container my-5">
    <div class="section-title">
        <h6 style="font-weight: bold; font-size: 1.2rem;">🎞 NOW SHOWING</h6>
    </div>
    <div class="row row-cols-2 row-cols-md-5 g-3 movie-container">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM movies ORDER BY id DESC");

                boolean hasMovies = false;
                while (rs.next()) {
                    hasMovies = true;
        %>
                    <div class="col movie-card-item">
                        <div class="movie-card">
                            <img src="<%= rs.getString("image_url") %>" alt="<%= rs.getString("title") %>">
                            <div class="movie-info">
                                <span><%= rs.getString("genre") %></span>
                                <span>₹<%= rs.getDouble("price") %></span>
                            </div>
                            <div class="movie-title"><%= rs.getString("title") %></div>

                            <!-- View Details Button -->
                            <form action="userDashboard.jsp" method="post">
                                <input type="hidden" name="action" value="details">
                                <input type="hidden" name="movie_id" value="<%= rs.getInt("id") %>">
                                <button type="submit" class="view-btn">View Details</button>
                            </form>
                        </div>
                    </div>
        <%
                }
                if (!hasMovies) {
        %>
                    <div class="text-center text-muted">No movies available at the moment.</div>
        <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("<pre style='color:red;'>");
                e.printStackTrace(new java.io.PrintWriter(out));
                out.println("</pre>");
            }
        %>
    </div>
</div>

<!-- ===== FOOTER ===== -->
<footer>
    <div class="container">
        <div class="row text-center">
            <div class="col icon-box"><i class="bi bi-headset"></i><p>24/7 Customer Care</p></div>
            <div class="col icon-box"><i class="bi bi-ticket-perforated"></i><p>Resend Booking Confirmation</p></div>
            <div class="col icon-box"><i class="bi bi-envelope"></i><p>Subscribe to Newsletter</p></div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
const searchForm = document.getElementById('searchForm');
const searchInput = document.getElementById('searchInput');
const movieCards = document.querySelectorAll('.movie-card-item');

searchForm.addEventListener('submit', e => {
  e.preventDefault();
  const query = searchInput.value.trim().toLowerCase();
  movieCards.forEach(c => {
    const title = c.querySelector('.movie-title').innerText.toLowerCase();
    c.style.display = title.includes(query) || query === "" ? "block" : "none";
  });
});
</script>
</body>
</html>
