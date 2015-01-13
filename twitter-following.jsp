<!-- <!doctype html> --!>

<html lang="en">
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%
	String key = request.getParameter("key");
	
	int followers = 0;
	int tweets = 0;
	int following = 0;
	String fullname = "";
	
	String tweeterhandle="";
	String tweetername="";
	ArrayList<String> tweeterid = new ArrayList<String>();
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
        
        /*get full name and username*/
        java.sql.PreparedStatement ps7 = conn.prepareStatement("SELECT * FROM users_t WHERE user_id=?");
		
		ps7.setString (1, key);
		java.sql.ResultSet rs7 = ps7.executeQuery();
	
		while(rs7.next())
        {
        	fullname = rs7.getString("fullname");
        	tweeterhandle = rs7.getString("username");
        } 
        
        /*get my tweets*/
        java.sql.PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM users_t WHERE user_id IN (SELECT target FROM follow_t WHERE stalkers=? AND target !=?)");
		
		ps1.setString (1, key);
		ps1.setString (2, key);
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

		/*get users im not following*/
        java.sql.PreparedStatement psNotFollowing = conn.prepareStatement("SELECT * FROM users_t WHERE user_id IN (select distinct target from follow_t where stalkers !=? AND target NOT IN (select target from follow_t where stalkers=?))");
		psNotFollowing.setString (1, key);
		psNotFollowing.setString (2, key);
		
		java.sql.ResultSet rsNF = psNotFollowing.executeQuery();
		
		ArrayList<String> idNF = new ArrayList<String>();
		ArrayList<String> nameNF = new ArrayList<String>();
		ArrayList<String> handleNF = new ArrayList<String>();
		while(rsNF.next())
        {
        	if (!rsNF.getString("user_id").equals(key)){ 
        		idNF.add(rsNF.getString("user_id"));
        		nameNF.add(rsNF.getString("fullname"));
        		handleNF.add(rsNF.getString("username"));
        	}
		}
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
				String linkProf = "<a href=\"twitter-profile.jsp?key=" + key + "&user=" + key + "\">";
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
                    <%
                    	String followersURL = "<a href=\"twitter-followers.jsp?key=" + key + "\">";
                    %>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><%=linkProf%><strong><%=tweets%></strong>Tweets</a></li>
                            <li><a href="#"><strong><%=following%></strong>Following</a></li>
                            <li><%=followersURL%><strong><%=followers%></strong>Followers</a></li>
                        </ul>
                    </div>
                    <form>
                        <textarea class="tweet-box" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile"></textarea>
                    </form>
                </div>

                <div class="module other-side-content">
                    <!-- display 7 users im not following -->
                    <div class="content">
                    <%
                    	for (int g = 0; g < idNF.size(); g++) {
                    		String disp = nameNF.get(g) + " @" + handleNF.get(g);
                    %>
                        
                        <form action="follow_user.jsp" method="get">
                        	<%=disp%>     <button name="passedInfo" type="submit" value="<%=idNF.get(g)%>&<%=key%>">Follow</button>
                        </form>
                        <p>
                    <% }// close for %>
                    </div>
                </div>
            </div>

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content">
                        <div class="profile-header-inner" data-background-image="url('images/grey-header-web.png')">
                            <a href="#" class="profile-picture media-thumbnail">
                                <img src="images/profileThumb.jpeg" alt="Barack Obama" class="avatar size73">
                            </a>
                            <div class="profile-card-inner">
                                <h1 class="fullname"><%=fullname%></h1>
                                <h2 class="username">@<%=tweeterhandle%></h2>
                                <div class="bio-container">
                                    <p class="bio profile-field">This account is run by Organizing for Action staff. Tweets from the President are signed -bo.
Washington, DC · http://www.barackobama.com</p>
                                </div>
                            </div>
                        </div>
                        <div class="flex-module profile-banner-footer clearfix">
                            <div class="default-footer">
                                <ul class="stats js-mini-profile-stats" style="float:left">
                                    <li>
                                        <a class="js-nav" href="#">
                                            <strong><%=tweets%></strong>
                                            Tweets
                                        </a>
                                    </li>
                                    <li>
                                        <a class="js-nav" href="#">
                                            <strong><%=following%></strong>
                                            Following
                                        </a>
                                    </li>
                                    <li>
                                        <a class="js-nav" href="#">
                                            <strong><%=followers%></strong>
                                            Followers
                                        </a>
                                    </li>
                                </ul>
                                <a href="#dm" class="btn dm-button pull-right" type="button" title"Direct Messages" data-toggle="modal">
                                    <i class="icon-envelope"></i>
                                </a>
                                <div id="dm" class="modal hide fade">
                                    <div class="modal-header twttr-dialog-header">
                                        <div class="twttr-dialog-close" data-dismiss="modal" aria-hidden="true">&nbsp;</div>
                                        <h3>Direct Messages</h3>
                                    </div>
                                    <div class="modal-body">
                                        <!-- direct messages start -->
                            

                                        <!-- direct messages end -->
                                    </div>
                                    <div class="twttr-dialog-footer">
                                        Tip: you can send a message to anyone who follows you. <a href="#" target="_blank" class="learn-more">Learn more</a>
                                  </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title">Following</h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>

                    <!-- all tweets -->
                    <div class="stream following-stream">

                    	<%
					while(rs1.next())
        			{
        				tweeterid.add(rs1.getString("user_id"));
					}
					for (int i = tweeterid.size()-1; i >=0; i--) {//for open
						java.sql.PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM users_t WHERE user_id=?");
						ps2.setString (1, tweeterid.get(i));
						java.sql.ResultSet rs2 = ps2.executeQuery();
	
						while(rs2.next()) {//while open
    						tweetername = rs2.getString("fullname");
        					tweeterhandle = rs2.getString("username");
        				}
        					
						String deleteURL = "delete-following.jsp?key="+ key + "&target=" + tweeterid.get(i);
							
					%>
                        <!-- start tweet -->
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="user-actions">
                                    <a class="btn follow-btn" href = <%=deleteURL%> >                                     
                                      <span class-="button-text follow-text">
                                            <i class="follow"></i>
                                            Unfollow
                                        </span>
                                    </a>
                                </div>
                                <div class="content">
                                    <div class="stream-item-header">
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
                    </div>
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