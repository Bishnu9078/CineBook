<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Seat Already Booked</title>

<!-- Bootstrap + Google Fonts -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

<style>
body {
  font-family: 'Poppins', sans-serif;
  background: radial-gradient(circle at top, #1a1a1a 0%, #000 100%);
  color: white;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
}

.card {
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.15);
  border-radius: 20px;
  padding: 40px 60px;
  text-align: center;
  box-shadow: 0 0 25px rgba(255, 0, 0, 0.25);
  animation: fadeIn 1.2s ease;
  position: relative;
}

.warning-icon {
  font-size: 80px;
  color: #ff3838;
  animation: pulse 1.5s infinite;
  margin-bottom: 15px;
}

h1 {
  font-size: 2.2rem;
  font-weight: 700;
  color: #ff5555;
}
p {
  font-size: 1.1rem;
  color: #ddd;
}
strong {
  color: #fff;
  font-weight: 600;
}

#countdown {
  margin-top: 10px;
  color: #aaa;
  font-size: 1rem;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes pulse {
  0% { transform: scale(1); opacity: 0.9; }
  50% { transform: scale(1.1); opacity: 1; }
  100% { transform: scale(1); opacity: 0.9; }
}
</style>

<script>
let seconds = 5;
function countdown() {
  const movieId = "<%= request.getAttribute("movieId") %>"; // dynamically fetch movie id
  document.getElementById("countdown").innerText =
    "Returning to booking page in " + seconds + " seconds...";
  if (seconds > 0) {
    seconds--;
    setTimeout(countdown, 1000);
  } else {
    // ✅ Redirect back to SAME MOVIE booking page
    window.location.href = "booking_admin.jsp?movie_id=" + movieId;
  }
}
window.onload = countdown;
</script>
</head>

<body>
<div class="card">
  <div class="warning-icon">⚠️</div>
  <h1>Seat Already Booked</h1>
  <p>Sorry, the following seat(s) are unavailable:</p>
  <h3><strong><%= request.getAttribute("bookedSeats") %></strong></h3>
  <p class="mt-3">
    Theater: <strong><%= request.getAttribute("theaterName") %></strong><br>
    Movie ID: <strong><%= request.getAttribute("movieId") %></strong>
  </p>
  <p id="countdown"></p>
</div>
</body>
</html>
