<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password | CinemaBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: radial-gradient(circle at center, #1b1b2f, #000);
            font-family: 'Poppins', sans-serif;
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .reset-box {
            background: #2c2c3c;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(255,60,0,0.4);
            width: 400px;
        }
        h3 {
            text-align: center;
            color: #ff3c00;
            margin-bottom: 25px;
        }
        label {
            font-weight: 600;
        }
        input {
            border-radius: 8px;
            border: none;
            padding: 10px;
            width: 100%;
            margin-bottom: 15px;
        }
        .btn-reset {
            background-color: #ff3c00;
            color: white;
            border: none;
            border-radius: 8px;
            width: 100%;
            padding: 10px;
            font-weight: bold;
        }
        .btn-reset:hover {
            background-color: #ff5722;
        }
    </style>
</head>

<body>
    <div class="reset-box">
        <h3>Reset Password</h3>
        <form action="UpdatePasswordServlet" method="post">
            <label>Email ID</label>
            <input type="email" name="email" placeholder="Enter your registered email" required>

            <label>New Password</label>
            <input type="password" name="new_password" placeholder="Enter new password" required>

            <label>Confirm Password</label>
            <input type="password" name="confirm_password" placeholder="Re-enter new password" required>

            <button type="submit" class="btn-reset">Update Password</button>
        </form>
    </div>
</body>
</html>
