<html>

<body>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

		<h1> go-between page / follow_user.jsp </h1>

<%
	String passedInfo = request.getParameter("passedInfo");
	String idToFollow = passedInfo.substring(0,1);
	String key = passedInfo.substring(2,3);
	String redirectURL = "";

	int status = 0;


	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/twitter_db";   //location and name of database
        String userid = "gordie";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database

		java.sql.Statement stmt = conn.createStatement();	

        java.sql.PreparedStatement ps = conn.prepareStatement("INSERT INTO follow_t VALUES (?,?)");

        ps.setString (1, idToFollow);
        ps.setString (2, key);
        status = ps.executeUpdate();

		if(status > 0)
		{
			redirectURL = "twitter-home.jsp?key=" + key; 
			response.sendRedirect(redirectURL);
		}
		else
		{
			redirectURL = "twitter-signin?msg=Fail"; 
			response.sendRedirect(redirectURL);
		}
%>
</html>