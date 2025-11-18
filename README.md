🎬 Cinema Ticket Booking System

A Full-Stack Java Web Application for Seamless Movie Ticket Reservations

🧩 Overview

The Cinema Ticket Booking System simplifies the movie ticket reservation process by digitizing every step — from movie selection to ticket generation.
It replicates real-world platforms like BookMyShow, developed completely using JSP, Servlets, and MySQL.

This project includes:

Backend workflow using Java Servlets + JDBC

Dynamic UI rendering through JSP

Secure online payments with Razorpay API

Database-driven session and booking management

💡 Motivation

Traditional movie booking systems are manual, time-consuming, or partially automated.
This system was built to:

Demonstrate practical Java EE & MVC architecture

Build a modular, scalable backend

Integrate third-party APIs like Razorpay

Strengthen MySQL relational database design

The result is a clean, maintainable, and production-style system.

⚙️ Key Features
🎟 User Module

MySQL-based Login / Registration

Dynamic movie & showtime listing

Interactive seat selection interface

Built-in date picker for booking

Auto-calculated ticket price

Razorpay payment integration

Downloadable PDF Ticket

🧑‍💼 Admin Module

Add / Update / Delete movies & showtimes

Manage ticket pricing & theaters

View all bookings + payments

Monitor real-time seat status

💰 Payment Integration

Integrated with Razorpay API (Test Mode)

Generates unique order_id

Validates payment success

Ensures secure transaction flow

📅 Calendar Booking

Users can select desired show dates directly from booking_admin.jsp

The selected date flows through payment → confirmation → ticket

Stored in database under booking_date column

🚀 How It Works

User Login / Registration

Movie Selection from database

Seat Selection (JSP-generated grid)

Date Selection using calendar widget

Payment initiated via Razorpay

Booking Confirmation stored in DB

Ticket Generated (PDF)

💾 Data Flow Diagram
User Workflow

Login → Movie Selection → Seat Selection → Payment → Ticket PDF

Admin Workflow

Dashboard → Movie/Showtime Management → Booking Overview

🧠 Learning Outcomes

This project helped master:

Servlet lifecycle (init, doGet, doPost)

Session management & request forwarding

JSP scripting, JSTL & MVC

MySQL JDBC prepared statements

Third-party API integration (Razorpay)

Exception handling & redirects

Real-time seat state management

🧰 Technologies Used
Frontend

HTML5

CSS3

Bootstrap 5

JavaScript

JSP

Backend

Java Servlets

JSP

JDBC

Razorpay Java SDK

Database

MySQL

Tables: users, movies, booking, booked_seats

Tools

Eclipse / STS

Apache Tomcat 9

MySQL Workbench

Git & GitHub

📈 Future Enhancements

JWT Authentication

QR-coded tickets

Email ticket delivery (SMTP)

Admin analytics dashboard

Migration to Spring Boot + REST API

UI enhancement using React / Angular

🏁 Conclusion

The Cinema Ticket Booking System is a complete, production-style web application integrating frontend, backend, payment gateway, and database technology.
It automates the end-to-end ticket booking lifecycle, ensuring reliability, scalability, and a seamless user experience.
