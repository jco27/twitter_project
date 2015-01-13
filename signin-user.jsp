<html>
	<body>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

		<h1> go-between page / signin-user.jsp </h1>

<%
	String useremail = request.getParameter("username-email");
	String pwd = request.getParameter("password");
	String redirectURL = "";
	String user_id = "";

	int status = 0;


	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/twitter_db";   //location and name of database
        String userid = "gordie";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database

		java.sql.Statement stmt = conn.createStatement();	

       	java.sql.PreparedStatement ps = conn.prepareStatement("SELECT * FROM users_t WHERE (username=? OR email=?) AND password=?");
		
        ps.setString (1, useremail);
        ps.setString (2, useremail);
        ps.setString (3, pwd);
        
        //status = ps.executeUpdate();

		java.sql.ResultSet rs = ps.executeQuery();
         
        while(rs.next())
        {
        	user_id = rs.getString("user_id");
        }
        

	if(user_id != "")
	{
		redirectURL = "twitter-home.jsp?key=" + user_id;
		response.sendRedirect(redirectURL);
	
	}
	else
	{
		//redirectURL = "twitter-signin?msg=Fail"; 
		redirectURL = "twitter-signin.jsp"; 
		response.sendRedirect(redirectURL);
	}
%>
