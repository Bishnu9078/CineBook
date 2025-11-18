<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register | Cinema Ticket Booking</title>
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
            justify-content: center;
            align-items: center;
        }

        .register-container {
            background: #2b2b3c;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(255, 60, 0, 0.3);
            text-align: center;
            width: 370px;
        }

        .register-container h1 {
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
            margin-top: 10px;
        }

        button:hover {
            background: #ff5722;
        }

        .register-container p {
            margin-top: 15px;
            font-size: 14px;
        }

        .register-container a {
            color: #ff3c00;
            text-decoration: none;
            font-weight: bold;
        }

        .register-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1>📝 Create Account</h1>
        <form action="RegisterServlet" method="post">
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            
            <!-- Hidden role field -->
            <input type="hidden" name="role" value="user">

            <button type="submit">Register</button>
        </form>
        <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </div>
</body>
</html>
