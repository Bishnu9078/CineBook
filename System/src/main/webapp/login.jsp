<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Prevent browser from caching login page
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Check if user has been redirected after logout
    String logoutMsg = request.getParameter("logout");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login | Cinema Ticket Booking</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #1e1e2f, #2e2e3e);
            color: #fff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .logout-message {
            background-color: rgba(0, 255, 100, 0.15);
            border: 1px solid #00ff66;
            color: #00ff88;
            padding: 10px 15px;
            border-radius: 8px;
            text-align: center;
            width: 350px;
            margin-bottom: 15px;
            font-weight: bold;
            animation: fadeOut 1s ease-in-out 4s forwards;
        }

        @keyframes fadeOut {
            to { opacity: 0; visibility: hidden; transform: translateY(-10px); }
        }

        .login-container {
            background: #2b2b3c;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(255, 60, 0, 0.3);
            text-align: center;
            width: 350px;
        }

        .login-container h1 {
            margin-bottom: 25px;
            color: #ff3c00;
            font-size: 28px;
        }

        input {
            width: 100%;
            padding: 12px;
            margin: 12px 0;
            border-radius: 8px;
            border: 1px solid #444;
            background: #1e1e2f;
            color: #fff;
            font-size: 15px;
        }

        input:focus {
            border-color: #ff3c00;
            outline: none;
        }

        .forgot-password {
            display: block;
            text-align: right;
            margin-top: -10px;
            margin-bottom: 15px;
            font-size: 13px;
        }

        .forgot-password a {
            color: #ff3c00;
            text-decoration: none;
            font-weight: bold;
        }

        .forgot-password a:hover {
            text-decoration: underline;
        }

        button {
            padding: 12px 20px;
            background: #ff3c00;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s ease;
            width: 100%;
        }

        button:hover {
            background: #ff5722;
        }

        .login-container p {
            margin-top: 15px;
            font-size: 14px;
        }

        .login-container a {
            color: #ff3c00;
            text-decoration: none;
            font-weight: bold;
        }

        .login-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <% if ("success".equals(logoutMsg)) { %>
        <div class="logout-message">✅ You have been logged out successfully.</div>
    <% } %>

    <div class="login-container">
        <h1>🎬 Login</h1>
        <form action="LoginServlet" method="post">
            <input type="email" name="email" placeholder="Enter your email" required>
            <input type="password" name="password" placeholder="Enter your password" required>

            <div class="forgot-password">
                <a href="resetPassword.jsp">Forgot Password?</a>
            </div>

            <button type="submit">Login</button>
        </form>

        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>

</body>
</html>
