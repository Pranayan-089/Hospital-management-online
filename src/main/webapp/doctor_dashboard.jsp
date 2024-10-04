<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Responsive Hospital Management Dashboard</title>
    <link rel="stylesheet" href="assets/css/style.css" />
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
                    <a href="doctor_dashboard.jsp">
                        <span class="icon">
                            <ion-icon name="home-outline"></ion-icon>
                        </span>
                        <span class="title">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="doctor_dashboard.jsp?section=editProfile">
                        <span class="icon">
                            <ion-icon name="person-circle-outline"></ion-icon>
                        </span>
                        <span class="title">Edit Profile</span>
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

            <div class="details">
                <%
                    String doctorEmail = (String) session.getAttribute("email");
                    if (doctorEmail == null) {
                        response.sendRedirect("signin.jsp");
                        return;
                    }

                    // Handle appointment removal
                    if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("remove_id") != null) {
                        int appointmentId = Integer.parseInt(request.getParameter("remove_id"));
                        Connection conn = null;
                        PreparedStatement pstmt = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123");

                            String deleteQuery = "DELETE FROM appointment WHERE appointment_id = ?";
                            pstmt = conn.prepareStatement(deleteQuery);
                            pstmt.setInt(1, appointmentId);
                            pstmt.executeUpdate();

                            request.setAttribute("statusMessage", "removed");
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.setAttribute("statusMessage", "error");
                        } finally {
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                    }

                    String section = request.getParameter("section");
                    if ("editProfile".equals(section)) {
                        // Fetch current doctor details from the database
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        String docName = "", docPass = "", docExp = "", docNum = "";

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123@123");

                            String query = "SELECT doc_name, doc_pass, doc_exp, doc_num FROM doctor WHERE doc_email = ?";
                            pstmt = conn.prepareStatement(query);
                            pstmt.setString(1, doctorEmail);
                            rs = pstmt.executeQuery();

                            if (rs.next()) {
                                docName = rs.getString("doc_name");
                                docPass = rs.getString("doc_pass");
                                docExp = rs.getString("doc_exp");
                                docNum = rs.getString("doc_num");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                %>
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>Edit Profile</h2>
                    </div>
                    <form action="updateDoctorProfile.jsp" method="post">
                        <div class="formGroup">
                            <label for="old_pass">Old Password</label>
                            <input type="password" id="old_pass" name="old_pass" placeholder="Enter Old Password" required />
                        </div>
                        <div class="formGroup">
                            <label for="new_pass">New Password</label>
                            <input type="password" id="new_pass" name="new_pass" placeholder="Enter New Password" required />
                        </div>
                        <div class="formGroup">
                            <label for="doc_exp">Experience (Years)</label>
                            <input type="number" id="doc_exp" name="doc_exp" value="<%= docExp %>" placeholder="Enter Experience" required />
                        </div>
                        <div class="formGroup">
                            <label for="doc_num">Contact Number</label>
                            <input type="text" id="doc_num" name="doc_num" value="<%= docNum %>" placeholder="Enter Contact Number" required />
                        </div>
                        <div class="formGroup">
                            <button type="submit" class="btn-update">Update Profile</button>
                        </div>
                    </form>
                </div>
                <%
                    } else {
                %>
                <div class="cardBox">
                    <div class="card">
                        <div>
                            <div class="numbers">
                                <%
                                    // JDBC connection setup for Total Appointments
                                    Connection conn = null;
                                    PreparedStatement pstmt = null;
                                    ResultSet rs = null;
                                    session = request.getSession();
                                    String doctor_email = (String) session.getAttribute("email");

                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123");

                                        String totalAppointmentsQuery = "SELECT COUNT(*) AS total FROM appointment WHERE doctor_email = ?";
                                        pstmt = conn.prepareStatement(totalAppointmentsQuery);
                                        pstmt.setString(1, doctor_email);
                                        rs = pstmt.executeQuery();

                                        if (rs.next()) {
                                            int totalAppointments = rs.getInt("total");
                                            out.println(totalAppointments);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rs != null) rs.close();
                                        if (pstmt != null) pstmt.close();
                                        if (conn != null) conn.close();
                                    }
                                %>
                            </div>
                            <div class="cardName">Total Appointments</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="people-outline"></ion-icon>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers">
                                <%
                                    // JDBC connection setup for Today's Appointments
                                    conn = null;
                                    pstmt = null;
                                    rs = null;

                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123");

                                        String todayAppointmentsQuery = "SELECT COUNT(*) AS today FROM appointment WHERE doctor_email = ? AND appointment_date = CURDATE()";
                                        pstmt = conn.prepareStatement(todayAppointmentsQuery);
                                        pstmt.setString(1, doctor_email);
                                        rs = pstmt.executeQuery();

                                        if (rs.next()) {
                                            int todayAppointments = rs.getInt("today");
                                            out.println(todayAppointments);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rs != null) rs.close();
                                        if (pstmt != null) pstmt.close();
                                        if (conn != null) conn.close();
                                    }
                                %>
                            </div>
                            <div class="cardName">Today Appointments</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="people-outline"></ion-icon>
                        </div>
                    </div>
                </div>

                <div class="details">
                    <div class="recentOrders">
                        <div class="cardHeader">
                            <h2>Recent Appointments</h2>
                        </div>

                        <div class="search">
                            <label>
                                <ion-icon name="search-outline" class="search-icon"></ion-icon>
                                <input type="text" id="searchInput" placeholder="Search by patient name" />
                            </label>
                        </div>

                        <table id="appointmentsTable">
                            <thead>
                                <tr>
                                    <td>Patient Name</td>
                                    <td>Phone Number</td>
                                    <td>Email</td>
                                    <td>Gender</td>
                                    <td>Age</td>
                                    <td>Date</td>
                                    <td>Time</td>
                                    <td>Status</td>
                                    <td>Action</td> <!-- Updated Action header -->
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    conn = null;
                                    pstmt = null;
                                    rs = null;
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123");

                                        String query = "SELECT appointment_id, pat_name, pat_number, pat_email, pat_gender, pat_age, appointment_date, appointment_time, pat_status " +
                                                       "FROM appointment WHERE doctor_email = ? ORDER BY (pat_status = 'confirmed') DESC, appointment_date DESC";
                                        pstmt = conn.prepareStatement(query);
                                        pstmt.setString(1, doctor_email);
                                        rs = pstmt.executeQuery();

                                        while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("pat_name") %></td>
                                    <td><%= rs.getLong("pat_number") %></td>
                                    <td><%= rs.getString("pat_email") %></td>
                                    <td><%= rs.getString("pat_gender") %></td>
                                    <td><%= rs.getInt("pat_age") %></td>
                                    <td><%= rs.getDate("appointment_date") %></td>
                                    <td><%= rs.getTime("appointment_time") %></td>
                                    <td><%= rs.getString("pat_status") %></td>
                                    <td>
                                        <form action="" method="post" class="status-form">
                                            <input type="hidden" name="appointment_id" value="<%= rs.getInt("appointment_id") %>">
                                            <input type="hidden" name="current_status" value="<%= rs.getString("pat_status") %>">
                                            <input type="hidden" name="status" value="confirmed">
                                            <button type="submit" class="btn-appointment approve-btn" style="padding: 10px 15px; margin: 5px;" onclick="return confirm('Are you sure you want to approve this appointment?');">Approve</button>
                                        </form>
                                        <form action="" method="post" class="remove-form">
                                            <input type="hidden" name="remove_id" value="<%= rs.getInt("appointment_id") %>">
                                            <button type="submit" class="btn-appointment remove-btn" style="padding: 10px 15px; margin: 5px;" onclick="return confirm('Are you sure you want to remove this appointment?');">Remove</button>
                                        </form>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <script src="assets/js/main.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

    <script>
        const searchInput = document.getElementById('searchInput');
        const table = document.getElementById('appointmentsTable');
        const rows = table.getElementsByTagName('tr');

        searchInput.addEventListener('keyup', function() {
            const filter = searchInput.value.toLowerCase();

            for (let i = 1; i < rows.length; i++) {
                const patientName = rows[i].getElementsByTagName('td')[0].textContent || rows[i].getElementsByTagName('td')[0].innerText;
                if (patientName.toLowerCase().indexOf(filter) > -1) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        });

        document.querySelectorAll('.status-form').forEach(form => {
            form.addEventListener('submit', function(event) {
                event.preventDefault();
                const currentStatus = this.querySelector('input[name="current_status"]').value;
                if (currentStatus === 'confirmed') {
                    alert('Already confirmed');
                } else {
                    this.submit();
                }
            });
        });
    </script>

    <%
        String statusMessage = (String) request.getAttribute("statusMessage");
        if (statusMessage != null) {
    %>
    <script>
        const statusMessage = "<%= statusMessage %>";
        if (statusMessage === "confirmed") {
            alert("Status confirmed");
        } else if (statusMessage === "removed") {
            alert("Appointment removed successfully");
        } else if (statusMessage === "error") {
            alert("Failed to update status");
        }
    </script>
    <%
        }
    %>
</body>
</html>
