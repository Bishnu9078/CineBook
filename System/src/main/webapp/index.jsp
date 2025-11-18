<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Home | Cinema Ticket Booking</title>
    <style>
        body { font-family: Arial; background: #202020; color: white; text-align: center; padding: 50px; }
        a { color: #ff3c00; text-decoration: none; }
    </style>
</head>
<body>
    <h1>Welcome, <%= user.getName() %> 👋</h1>
    <p>You are successfully logged in!</p>
    <a href="movies.jsp">View Movies</a> | <a href="LogoutServlet">Logout</a>
</body>
</html>
