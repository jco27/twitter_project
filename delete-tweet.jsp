<html>

<body>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

		<h1> go-between page / delete-tweet.jsp </h1>

<%
	String key = request.getParameter("key");
	String tweetId = request.getParameter("tweetid");
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

		java.sql.PreparedStatement psB = conn.prepareStatement("DELETE FROM hash_tweet_rel_t WHERE tweet_id =?");
		psB.setString (1, tweetId);
		statusB = psB.executeUpdate();

        java.sql.PreparedStatement ps = conn.prepareStatement("DELETE FROM tweets_t WHERE tweet_id =?");
        ps.setString (1, tweetId);
        status = ps.executeUpdate();

		
		redirectURL = "twitter-profile.jsp?key=" + key + "&user=" + key; 
		response.sendRedirect(redirectURL);
		
%>
</html>