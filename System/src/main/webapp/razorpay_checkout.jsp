<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String orderId = (String) request.getAttribute("order_id");
    String keyId = (String) request.getAttribute("key_id");
    double amount = (double) request.getAttribute("amount");
    int bookingId = (int) request.getAttribute("booking_id");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing Payment | Cinema Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        body {
            background: #111;
            color: #fff;
            font-family: 'Poppins', sans-serif;
            text-align: center;
            padding-top: 80px;
        }
        .loader {
            border: 6px solid #f3f3f3;
            border-top: 6px solid #e50914;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            margin: 20px auto;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { 100% { transform: rotate(360deg); } }
    </style>
</head>

<body onload="startPayment()">
    <h2>Redirecting to secure payment...</h2>
    <div class="loader"></div>
    <p>Please do not refresh or close this window.</p>

    <script>
        function startPayment() {
            const options = {
                "key": "<%= keyId %>",
                "amount": <%= (int)(amount * 100) %>,
                "currency": "INR",
                "name": "Cinema Book",
                "description": "Movie Ticket Payment",
                "order_id": "<%= orderId %>",
                "handler": function (response) {
                    // ✅ After successful payment, notify backend
                    const paymentId = response.razorpay_payment_id;
                    const xhr = new XMLHttpRequest();
                    xhr.open("GET", "PaymentSuccessServlet?razorpay_payment_id=" + paymentId + "&booking_id=<%= bookingId %>", true);
                    xhr.onload = function() {
                        if (xhr.status === 200) {
                            // ✅ Redirect user to ticket page
                            window.location.href = "ticket.jsp?booking_id=<%= bookingId %>";
                        } else {
                            alert("Payment verified, but server failed to update. Contact support.");
                        }
                    };
                    xhr.onerror = function() {
                        alert("Error connecting to server. Please check your network.");
                    };
                    xhr.send();
                },
                "theme": {
                    "color": "#e50914"
                },
                "modal": {
                    "ondismiss": function() {
                        alert("Payment cancelled. You can try again.");
                        window.location.href = "userDashboard.jsp";
                    }
                }
            };

            const rzp = new Razorpay(options);
            rzp.open();
        }
    </script>
</body>
</html>
