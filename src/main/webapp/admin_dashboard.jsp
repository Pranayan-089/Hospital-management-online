<%@ page import='java.sql.*' %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responsive Hospital Management Dashboard</title>
    <link rel="stylesheet" href="assets/css/style.css" />
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap");

        :root {
            --maincolor: #2ec8a6;
            --secondcolor: #f8a803;
            --thirdcolor: #f4ab01;
            --textcolor: #4a5764;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            outline: none;
            border: none;
            text-decoration: none;
            text-transform: capitalize;
            transition: all 0.2s linear;
            font-family: "Inter", sans-serif;
        }

        .details {
            padding: 2rem;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .details table {
            width: 100%;
            border-collapse: collapse;
        }
        .details th, .details td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .details th {
            background-color: var(--maincolor);
            color: white;
        }
        .patient-card {
            padding: 1.5rem;
            background-color: var(--maincolor);
            color: white;
            border-radius: 8px;
            margin-bottom: 2rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="navigation">
            <ul>
                <li>
                    <a href="#">
                        <span class="icon">
                            <ion-icon name="medkit-outline"></ion-icon>
                        </span>
                        <span class="title">Hospital Name</span>
                    </a>
                </li>

                <li>
                    <a href="#" onclick="showUsers()">
                        <span class="icon">
                            <ion-icon name="people-outline"></ion-icon>
                        </span>
                        <span class="title">Users</span>
                    </a>
                </li>

                <li>
                    <a href="#" onclick="showPatients()">
                        <span class="icon">
                            <ion-icon name="people-outline"></ion-icon>
                        </span>
                        <span class="title">Patients</span>
                    </a>
                </li>
                <li>
                    <a href="registration.jsp">
                        <span class="icon">
                            <ion-icon name="log-out-outline"></ion-icon>
                        </span>
                        <span class="title">Sign Out</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="main">
            <div class="topbar">
                <div class="toggle">
                    <ion-icon name="menu-outline"></ion-icon>
                </div>
            </div>

            <!-- User Details Section -->
            <div id="users" class="details" style="display: none;">
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>All Patients</h2>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Password</th>
                                <th>Security Question</th>
                                <th>Security Answer</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection con = null;
                                Statement stmt = null;
                                ResultSet rs = null;

                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123");
                                    stmt = con.createStatement();
                                    String query = "SELECT * FROM patient";
                                    rs = stmt.executeQuery(query);

                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("pat_name") %></td>
                                <td><%= rs.getString("pat_email") %></td>
                                <td><%= rs.getString("pat_pass") %></td>
                                <td><%= rs.getString("pat_sq") %></td>
                                <td><%= rs.getString("pat_sa") %></td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println(e);
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                                    if (con != null) try { con.close(); } catch (SQLException e) {}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Patient Details Section -->
            <div id="patients" class="details" style="display: none;">
                <div class="patient-card">
                    <h2>Total Patients</h2>
                    <%
                        Connection conn = null;
                        Statement stmt1 = null;
                        ResultSet rs1 = null;
                        int patientCount = 0;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123");
                            stmt1 = conn.createStatement();
                            String countQuery = "SELECT COUNT(*) AS total FROM patient";
                            rs1 = stmt1.executeQuery(countQuery);

                            if (rs1.next()) {
                                patientCount = rs1.getInt("total");
                            }
                    %>
                    <h1><%= patientCount %></h1>
                    <%
                        } catch (Exception e) {
                            out.println(e);
                        } finally {
                            if (rs1 != null) try { rs1.close(); } catch (SQLException e) {}
                            if (stmt1 != null) try { stmt1.close(); } catch (SQLException e) {}
                            if (conn != null) try { conn.close(); } catch (SQLException e) {}
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showUsers() {
            const usersSection = document.getElementById('users');
            const patientsSection = document.getElementById('patients');
            patientsSection.style.display = "none"; // Hide Patients section
            usersSection.style.display = usersSection.style.display === "none" ? "block" : "none";
        }

        function showPatients() {
            const patientsSection = document.getElementById('patients');
            const usersSection = document.getElementById('users');
            usersSection.style.display = "none"; // Hide Users section
            patientsSection.style.display = patientsSection.style.display === "none" ? "block" : "none";
        }
    </script>

    <script src="assets/js/main.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
</body>
</html>
