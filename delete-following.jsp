<html>

<body>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

		<h1> go-between page / delete-following.jsp </h1>

<%
	String key = request.getParameter("key");
	String target = request.getParameter("target");
	String redirectURL = "";

	int status = 0;
	int statusB = 0;

	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/twitter_db";   //location and name of database
        String userid = "gordie";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database

		java.sql.Statement stmt = conn.createStatement();	

		java.sql.PreparedStatement psB = conn.prepareStatement("DELETE FROM follow_t WHERE stalkers =? AND target=?");
		psB.setString (1, key);
		psB.setString (2, target);
		statusB = psB.executeUpdate();

		
		redirectURL = "twitter-following.jsp?key=" + key; 
		response.sendRedirect(redirectURL);
		
%>
</html>