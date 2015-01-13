<html>
<body>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.Integer" %>
<%@ page import="java.lang.String" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

		<h1> compose_tweet.jsp </h1>

<%
	String tweetFull = request.getParameter("tweetText");
	String key = request.getParameter("key");
	String redirectURL = "twitter-home.jsp?key=" + key;
	String tweet_id = "";
	int hash_id = 0;
	int status = 0;
	
	if (tweetFull.equals("")) {
		response.sendRedirect(redirectURL);
	} else {

	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/twitter_db";   //location and name of database
        String userid = "gordie";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		String time = sdf.format(cal.getTime());
		
		String[] tweetSeg = tweetFull.split(" ");
		ArrayList <String> hashtags = new ArrayList<String>();
		
		for (int i = 0; i < tweetSeg.length; i++) {
			if (tweetSeg[i].startsWith("#") ) {
				hashtags.add(tweetSeg[i].substring(1));
			}
		}
		
		java.sql.Statement stmt = conn.createStatement();	

        java.sql.PreparedStatement ps = conn.prepareStatement("INSERT INTO tweets_t (user_id, tweet, time) VALUES (?,?,?)");

        ps.setString (1, key);
        ps.setString (2, tweetFull);
        ps.setString (3, time);
        status = ps.executeUpdate();
        
        
        java.sql.ResultSet rs = stmt.executeQuery("select max(tweet_id) from tweets_t");
         
        while(rs.next())
        {
        	tweet_id = rs.getString(1);
        }
        
        //  need to insert into hashtags_t table 
        //  if hashtag doesn't exist, create it; 
        //  if exists, get hash_id; then after each
        //	time getting new hash_id, insert into hash-tweet-rel_t with the hash_id and tweet_id
        
        int hash_id_final = 0;
        int g = 0;
        for (int j = 0; j < hashtags.size(); j++) { // loop through all of the hashtags (ie nyc)
                
        	java.sql.Statement stmtH1 = conn.createStatement();
        	java.sql.PreparedStatement psH1 = conn.prepareStatement("SELECT hash_id FROM hashtags_t WHERE hashtag_text = ?");
        
        	psH1.setString (1, hashtags.get(j) );
        
        	java.sql.ResultSet rsH1 = psH1.executeQuery();
        	
        	while(rsH1.next())
        	{
        		hash_id_final = rsH1.getInt(1);
        	}    
        	
        	if (hash_id_final == 0) { // if the hashtag doesn't exist yet
        		 g = 7;
        		java.sql.Statement stmtH2 = conn.createStatement();
        		java.sql.PreparedStatement psH2 = conn.prepareStatement("INSERT INTO hashtags_t (hashtag_text) VALUES (?)");
        		
        		psH2.setString (1, hashtags.get(j) );
        		int status2 = psH2.executeUpdate();
        		
        		java.sql.ResultSet rsH2 = stmtH2.executeQuery("select max(hash_id) from hashtags_t");
         
        		while(rsH2.next()) {
        			hash_id = rsH2.getInt(1);
        		}
        		hash_id_final = hash_id;
        	}
        	
        	java.sql.Statement stmtH3 = conn.createStatement();
        	java.sql.PreparedStatement psH3 = conn.prepareStatement("INSERT INTO hash_tweet_rel_t VALUES (?, ?)");
        	
        	psH3.setInt (1, hash_id_final);
        	psH3.setString (2, tweet_id);
        	
        	psH3.executeUpdate();
        	
        	hash_id_final = 0;
        }// end of looping through the hashtags
       

		if(status > 0)
		{ 
			response.sendRedirect(redirectURL);
		}
		else
		{
			redirectURL = "twitter-signin?msg=Fail"; 
			response.sendRedirect(redirectURL);
		}
		}
%>
</html>