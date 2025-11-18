<%@ page contentType="text/html;charset=UTF-8"%>
<html><body style="text-align:center;padding:80px;">
<h2 style="color:red;">❌ Payment Failed</h2>
<p><%= request.getAttribute("message") %></p>
<a href="userDashboard.jsp">Try Again</a>
</body></html>
