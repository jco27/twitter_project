<html>

<body>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

		<h1> go-between page / insert_user.jsp </h1>

<%
	String fullname = request.getParameter("fullname");
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	String pwd = request.getParameter("password");
	String redirectURL = "";
	String user_id = "";

	int status = 0;
	int statusb=0;


	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/twitter_db";   //location and name of database
        String userid = "gordie";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database

		java.sql.Statement stmt = conn.createStatement();	

        java.sql.PreparedStatement ps = conn.prepareStatement("INSERT INTO users_t (fullname, username, email, password) VALUES (?,?,?,?)");

        ps.setString (1, fullname);
        ps.setString (2, username);
        ps.setString (3, email);
        ps.setString (4, pwd);
        status = ps.executeUpdate();
        
        
        java.sql.ResultSet rs = stmt.executeQuery("select max(user_id) from users_t");
         
        while(rs.next())
        {
        	user_id = rs.getString(1);
        }
        
        java.sql.PreparedStatement inkey = conn.prepareStatement("INSERT INTO follow_t VALUES (?,?)");
        inkey.setString (1, user_id);
        inkey.setString (2, user_id);
        
        statusb = inkey.executeUpdate();

		if(status > 0)
		{
			redirectURL = "twitter-home.jsp?key=" + user_id; 
			response.sendRedirect(redirectURL);
	
		}
		else
		{
			redirectURL = "twitter-signin?msg=Fail"; 
			response.sendRedirect(redirectURL);
		}
%>
</html>