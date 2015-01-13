<!-- <!doctype html> --!>

<html lang="en">
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%
	String hash_id = request.getParameter("hid");
	String key = request.getParameter("key");
	
	int followers = 0;
	int tweets = 0;
	int following = 0;
	String fullname = "";
	
	String tweeterhandle="";
	String tweetername="";
	ArrayList<String> tweeterid = new ArrayList<String>();
	ArrayList<String> tweet = new ArrayList<String>();
	ArrayList<String> tweetTimes = new ArrayList<String>();
	String tweettext="";
	
	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/twitter_db";   //location and name of database
        String userid = "gordie";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database
		
		java.sql.Statement stmt = conn.createStatement();	
		
		/*get number of followers*/
		java.sql.PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS followers FROM follow_t WHERE target=?");
		
		ps.setString (1, key);
		java.sql.ResultSet rs = ps.executeQuery();
	
		while(rs.next())
        {
        	followers = rs.getInt("followers");
        }
        
        /*get number of tweets*/
        java.sql.PreparedStatement ps5 = conn.prepareStatement("SELECT COUNT(*) as tweets FROM tweets_t WHERE user_id=?");
		
		ps5.setString (1, key);
		java.sql.ResultSet rs5 = ps5.executeQuery();
	
		while(rs5.next())
        {
        	tweets = rs5.getInt("tweets");
        }  
        
        /*get number of people im following*/
        java.sql.PreparedStatement ps6 = conn.prepareStatement("SELECT COUNT(*) AS following FROM follow_t WHERE stalkers=?");
		
		ps6.setString (1, key);
		java.sql.ResultSet rs6 = ps6.executeQuery();
	
		while(rs6.next())
        {
        	following = rs6.getInt("following");
        }  
        
        /*get full name*/
        java.sql.PreparedStatement ps7 = conn.prepareStatement("SELECT fullname FROM users_t WHERE user_id=?");
		
		ps7.setString (1, key);
		java.sql.ResultSet rs7 = ps7.executeQuery();
	
		while(rs7.next())
        {
        	fullname = rs7.getString(1);
        } 
        
        /*get tweets*/
        java.sql.PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM tweets_t WHERE tweet_id IN (SELECT tweet_id FROM hash_tweet_rel_t WHERE hash_id=?)");
		
		ps1.setString (1, hash_id);
		java.sql.ResultSet rs1 = ps1.executeQuery();
		
		/*get timestamp*/
		
		String currentTime = "";
        java.sql.PreparedStatement psCurTime = conn.prepareStatement("SELECT CURRENT_TIMESTAMP()");
		
		java.sql.ResultSet rsCurTime = psCurTime.executeQuery();
		
		while(rsCurTime.next())
        {
        	currentTime = rsCurTime.getString(1);
		}
		
		String[] curTimeSplit = currentTime.split("[\\W]");

%>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <meta name="description" content="">
    <meta name="author" content="">
    <style type="text/css">
    	body {
    		padding-top: 60px;
    		padding-bottom: 40px;
    	}
    	.sidebar-nav {
    		padding: 9px 0;
    	}
    </style>    
    <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
</head>
<body class="user-style-theme1">
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
                <i class="nav-home"></i> <a href="#" class="brand">!Twitter</a>
				<div class="nav-collapse collapse">
					<p class="navbar-text pull-right">Logged in as <a href="#" class="navbar-link"><%=fullname%></a>
					</p>
					<ul class="nav">
						<li class="active"><a href="index.html">Home</a></li>
						<li><a href="queries.html">Test Queries</a></li>
						<li><a href="twitter-signin.html">Main sign-in</a></li>
					</ul>
				</div><!--/ .nav-collapse -->
			</div>
		</div>
	</div>

    <div class="container wrap">
        <div class="row">
			<%
				String linkProf = "<a href=\"twitter-following.jsp?key=" + key + "\">";
				String linkHome = "<a href=\"twitter-home.jsp?key=" + key + "\">";
			%>
            <!-- left column -->
            <div class="span4" id="secondary">
                <div class="module mini-profile">
                    <div class="content">
                        <div class="account-group">
                            <a href="#">
                                <img class="avatar size32" src="images/pirate_normal.jpg" alt="Gordy">
                                <b class="fullname"><%=linkHome%><%=fullname%></b></a>
                                <small class="metadata"><%=linkProf%>View my profile page</small></a>
                            </a>
                        </div>
                    </div>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><a href="#"><strong><%=tweets%></strong>Tweets</a></li>
                            <li><a href="twitter-following.html"><strong><%=following%></strong>Following</a></li>
                            <li><a href="#"><strong><%=followers%></strong>Followers</a></li>
                        </ul>
                    </div>
                    <form action = "compose_tweet.jsp" action = "get">
                        <textarea name="tweetText" class = "tweet-box" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile"></textarea>
                    	<input type = "submit" value = "Tweet">
                    	<input type = "hidden" name = "key" value = <%=key%> >                 
                    	</form>
                </div>

                <div class="module other-side-content">
                    <div class="content"
                        <p>It is currently <%=currentTime.substring(11, 16)%></p>
                    </div>
                </div>
            </div>

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    
                    <div class="content-header">
                        <div class="header-inner">
                            <%=linkHome%><h2 class="js-timeline-title">Back to All Tweets</h2></a>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>

                    <!-- all tweets -->
                    <div class="stream home-stream">
					<%
					while(rs1.next())
        			{
        				tweeterid.add(rs1.getString("user_id"));
        				tweet.add(rs1.getString("tweet"));
        				tweetTimes.add(rs1.getString("time"));
					}
						for (int i = tweeterid.size()-1; i >=0; i--) {//for open
							java.sql.PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM users_t WHERE user_id=?");
							ps2.setString (1, tweeterid.get(i));
							java.sql.ResultSet rs2 = ps2.executeQuery();
	
							while(rs2.next()) {//while open
        						tweetername = rs2.getString("fullname");
        						tweeterhandle = rs2.getString("username");
        					}
        					
        					//get timestamp (not yet created)
        					String timestamp;
        					String[] tweetTimeSplit = tweetTimes.get(i).split("[\\W]");
        					int[] diff = new int[5];
        					for (int c = 0; c < 5; c++) {
        						diff[c] = Integer.parseInt(curTimeSplit[c]) - Integer.parseInt(tweetTimeSplit[c]);
        					}
        					int days = (diff[0]*365) + (diff[1]*30) + (diff[2]);      					
        					if (days > 0) {
        						timestamp = Integer.toString(days)+"d";
        					} else {
        						timestamp = Integer.toString((diff[3]*60) + diff[4]) + "m";
        					}
        					
        					//set-up hashtag link
        					String tweetFull = tweet.get(i);
        					
        					String[] tweetSeg = tweetFull.split(" ");
	
							for (int h = 0 ; h < tweetSeg.length ; h++) {
								if (tweetSeg[h].startsWith("#")) {
									java.sql.Statement stmtH = conn.createStatement();
        							java.sql.PreparedStatement psH = conn.prepareStatement("SELECT hash_id FROM hashtags_t WHERE hashtag_text = ?");
        
        							psH.setString (1, tweetSeg[h].substring(1));
        
        							java.sql.ResultSet rsH = psH.executeQuery();
        	
        							int hashtagIdVal=0;
        							while(rsH.next()) {
        								hashtagIdVal = rsH.getInt(1);
        							}    
        	
									tweetSeg[h] = "<a href=\"hashtag-search.jsp?hid=" + hashtagIdVal + "&key=" + key + "\">" + tweetSeg[h] + "</a>";
								}//close if
							}//close h for
							String outputHtml = tweetSeg[0];
							for (int w = 1; w < tweetSeg.length; w++){
								outputHtml = outputHtml + " " + tweetSeg[w];
							}
					%>
                        <!-- start tweet -->
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="timestamp">
                                                <span class="_timestamp"><%=timestamp%></span>
                                            </a>
                                        </small>
                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"><%=tweetername%></strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <b>@<%=tweeterhandle%></b>
                                            </span>
                                        </a>
                                    </div>
                                    <p class="js-tweet-text">
                                        "<%=outputHtml%>"
                                        <a href="http://t.co/xOqdhPgH" class="twitter-timeline-link" target="_blank" title="http://OFA.BO/xRSG9n" dir="ltr">
                                            <!--<span class="invisible">http://</span>
                                            <span class="js-display-url">OFA.BO/xRSG9n</span>-->
                                            <span class="invisible"></span>
                                            <span class="tco-ellipsis">
                                                <span class="invisible">&nbsp;</span>
                                            </span>
                                        </a>
                                    </p>
                                </div>
                            </a>
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div>
                        </div><!-- end tweet -->
						<%
							}//for close
						%>
						
                    <div class="stream-footer"></div>
                    <div class="hidden-replies-container"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div>
        </div>
    </div>
     <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>