<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SignIn Processing</title>
</head>
<body>

<%
	String role = request.getParameter("role");
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	if (role == null || email == null || password == null) {
	    out.println("Error: Missing required fields.");
	    return;
	}

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/HMS", "root", "Pranayan@123");
		Statement stmt = con.createStatement();
		String query = "";

		// Building query based on role
		if ("doctor".equals(role)) 
		{
			session.setAttribute("email", email);
			query = "select * from doctor where doc_email='" + email + "' and doc_pass='" + password + "'";
		} 
		else if ("admin".equals(role)) 
		{
			session.setAttribute("email", email);
			query = "select * from admin where admin_email='" + email + "' and admin_pass='" + password + "'";
		} 
		else if ("patient".equals(role)) 
		{
			session.setAttribute("email", email);
			query = "select * from patient where pat_email='" + email + "' and pat_pass='" + password + "'";
		} 
		else if ("emergency".equals(role)) 
		{
			session.setAttribute("email", email);
			query = "select * from emergency_service where emer_email='" + email + "' and emer_pass='" + password + "'";
		}

		// Execute query
		ResultSet rs = stmt.executeQuery(query);
		if (rs.next())
		{
			if("admin".equals(role))
			{
				%>
			    <jsp:forward page="admin_dashboard.jsp"></jsp:forward>
				<%
			}
			else if("doctor".equals(role))
			{
				%>
			    <jsp:forward page="doctor_dashboard.jsp"></jsp:forward>
				<%
			}
			else if("patient".equals(role))
			{
				%>
			    <jsp:forward page="patient_dashboard.jsp"></jsp:forward>
				<%
			}
			else if("emergency".equals(role))
			{
				%>
			    <jsp:forward page="emer_dashboard.jsp"></jsp:forward>
				<%
			}
		} 
		else 
		{
%>
		    <jsp:forward page="failure.jsp"></jsp:forward>
<%
		}
		con.close();
	} 
	catch(Exception e) 
	{
		out.println("Error: " + e.getMessage());
	}
%>

</body>
</html>
