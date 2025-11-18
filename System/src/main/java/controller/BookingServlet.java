package controller;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection conn = null;
        try {
            int userId = (int) session.getAttribute("user_id");
            int movieId = Integer.parseInt(request.getParameter("movie_id"));
            String theater = "Inox Bhubaneswar";
            String showTime = request.getParameter("show_time");
            String seats = request.getParameter("seats");
            double totalPrice = Double.parseDouble(request.getParameter("total_price"));
            String selectedDate = request.getParameter("selected_date");
            String bookingDate = (selectedDate != null && !selectedDate.trim().isEmpty())
                    ? selectedDate
                    : new java.sql.Date(System.currentTimeMillis()).toString();

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cinema_db", "root", "Bishnu@068");
            conn.setAutoCommit(false);

            // ✅ Step 1: Check if any selected seats are already booked
            String[] seatList = seats.split(",");
            StringBuilder bookedSeats = new StringBuilder();

            for (String seat : seatList) {
                PreparedStatement checkSeat = conn.prepareStatement(
                        "SELECT * FROM booking WHERE movie_id=? AND theater_name=? AND booking_date=? AND show_time=? AND FIND_IN_SET(?, seats)");
                checkSeat.setInt(1, movieId);
                checkSeat.setString(2, theater);
                checkSeat.setString(3, bookingDate);
                checkSeat.setString(4, showTime);
                checkSeat.setString(5, seat.trim());
                ResultSet rs = checkSeat.executeQuery();
                if (rs.next()) {
                    if (bookedSeats.length() > 0) bookedSeats.append(", ");
                    bookedSeats.append(seat.trim());
                }
            }

            // ✅ Step 2: If booked seats found → show seaterror.jsp
            if (bookedSeats.length() > 0) {
                conn.rollback();
                request.setAttribute("bookedSeats", bookedSeats.toString());
                request.setAttribute("movieId", movieId);
                request.setAttribute("theaterName", theater);
                RequestDispatcher rd = request.getRequestDispatcher("seatError.jsp");
                rd.forward(request, response);
                return;
            }

            // ✅ Step 3: Otherwise insert new booking
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO booking (user_id, movie_id, theater_name, seats, total_price, booking_date, show_time, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setInt(2, movieId);
            ps.setString(3, theater);
            ps.setString(4, seats);
            ps.setDouble(5, totalPrice);
            ps.setString(6, bookingDate);
            ps.setString(7, showTime);
            ps.executeUpdate();

            ResultSet genKeys = ps.getGeneratedKeys();
            int bookingId = 0;
            if (genKeys.next()) bookingId = genKeys.getInt(1);

            // ✅ Step 4: Save seats into booked_seats table
            for (String seat : seatList) {
                PreparedStatement insertSeat = conn.prepareStatement(
                        "INSERT INTO booked_seats (movie_id, seat_no) VALUES (?, ?)");
                insertSeat.setInt(1, movieId);
                insertSeat.setString(2, seat.trim());
                insertSeat.executeUpdate();
            }

            conn.commit();
            conn.close();

            // ✅ Step 5: Save info in session and go to payment
            session.setAttribute("booking_id", bookingId);
            session.setAttribute("movie_id", movieId);
            session.setAttribute("theater_name", theater);
            session.setAttribute("show_time", showTime);
            session.setAttribute("seats", seats);
            session.setAttribute("total_price", totalPrice);
            session.setAttribute("booking_date", bookingDate);

            response.sendRedirect("payment.jsp");

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            throw new ServletException("Error in BookingServlet", e);
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
