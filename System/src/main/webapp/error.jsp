<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
        }
        .error-container {
            max-width: 600px;
            margin: 150px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            animation: fadeIn 0.6s ease-in-out;
        }
        .error-container h2 {
            color: #dc3545;
            font-weight: 700;
            margin-bottom: 20px;
        }
        .error-container p {
            color: #333;
            margin: 8px 0;
            font-size: 17px;
            font-weight: 500;
        }
        .text-muted {
            font-size: 15px;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>

    <script>
        // ✅ Auto redirect to booking_admin.jsp after 5 seconds
        setTimeout(function() {
            const movieId = "<%= request.getAttribute("movie_id") != null ? request.getAttribute("movie_id") : "" %>";
            window.location.href = "booking_admin.jsp" + (movieId ? "?movie_id=" + movieId : "");
        }, 5000);
    </script>
</head>
<body>
    <div class="error-container">
        <h2>⚠ Booking Failed</h2>
        <p><strong><%= request.getAttribute("errorMessage") != null 
                ? request.getAttribute("errorMessage") 
                : "Seat A1 is already booked for this movie!" %></strong></p>
        <p>Please choose a different seat.</p>
        <p class="text-muted mt-3">(Redirecting you back in 5 seconds...)</p>
    </div>
</body>
</html>
