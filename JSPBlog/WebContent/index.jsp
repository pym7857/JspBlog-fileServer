<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="user.UserDTO" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<%
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}

	UserDAO userDAO = new UserDAO();
	String userProfile = userDAO.getProfile(userID); // profile의 경로를 가져오는 메서드
	
	BoardDAO boardDAO = new BoardDAO();
	ArrayList<BoardDTO> boardPopularList = boardDAO.getPopularList(); /* 실시간 인기 게시글 정보를 가져오는 함수 */
	ArrayList<BoardDTO> boardList = boardDAO.getRecentList(); /*최신 게시글 정보를 가져오는 함수 */

%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="css/custom.css?ver=1">
	<link rel="stylesheet" type="text/css" href="css/custom2.css?ver=1">
	<title>OKKY</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
		/* 상단 내비게이션 메세지함 unread 라벨 표시 */
		function getUnread() {
			$.ajax({
				type: "POST",
				url: "./chatUnread",
				data: {
					userID: encodeURIComponent('<%= userID %>'),
				},
				success: function(result) {
					if(result >= 1) {
						showUnread(result);
					} else {
						showUnread('');
					}
				}
			});
		}
		function getInfiniteUnread() {
			setInterval(function() {
				getUnread();
			}, 4000);
		}
		function showUnread(result) {
			$('#unread').html(result);
		}
	</script>
</head>
<body>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp">조유리 사생팬 블로그</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
				<li><a href="box.jsp">메세지함<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">자유게시판</a></li>
				<li><a href="fileShare.jsp">파일공유</a></li>
			</ul>
			<%
				if(userID == null){ // 로그인이 안된사람들에 한해 보여지는 네비게이션 바
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>	
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="update.jsp">회원정보수정</a></li>
						<li><a href="profileUpdate.jsp">프로필 사진 수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>	
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="userStatus.jsp"><img class=".media-object img-circle" style="media-object: display:none; margin: 0 auto; max-width: 50px; max-height: 50px;" src="<%= userProfile %>"></img></a></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<div class="row">
            <div class="col-md-6">
                <h4>실시간 인기 게시물</h4>
               	<hr>
            <%
				for(int i=0; i<boardPopularList.size(); i++) {
					BoardDTO board = boardPopularList.get(i);
			%>
				<ul>
					<li style="list-style:none; font-weight: bold;"><img src="images\star.png" style="width:20px; height:20px;"></img>&nbsp<a href="boardShow.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardTitle() %></a></li>
					<li style="list-style:none; margin-top:5px; font-size: 80%; color:grey;">작성자 <%= board.getUserID() %> | 조회  <%= board.getBoardHit() %> | 추천 <%= board.getBoardLike() %></li>
					
				</ul>
				<hr style="margin-top:0px;">
			<%
				}
			%>
            </div>
            <div class="col-md-6">
            	<h4>최신글</h4>
            	<hr>
            <%
				for(int i=0; i<boardList.size(); i++) {
					BoardDTO board = boardList.get(i);
			%>
				<ul>
					<li style="list-style:none; font-weight: bold;"><img src="images\balloon.png" style="width:50px; height:30px;"></img>&nbsp<a href="boardShow.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardTitle() %></a></li>
					<li style="list-style:none; margin-top:5px; font-size: 80%; color:grey;">작성자 <%= board.getUserID() %> | 조회  <%= board.getBoardHit() %> | 추천 <%= board.getBoardLike() %></li>
				</ul>
				<hr style="margin-top:0px;">
			<%
				}
			%>
            </div>
        </div> 
        <hr>
        <!-- 미디어 -->
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title"><span class="glyphicon glyphicon-pencil"></span>
                &nbsp;&nbsp;최신 강의 목록</h3>
            </div>
            <div class="panel-body">
                <div class="media">
                    <div class="media-left">
                        <a href="lecture.html?lectureName=C"><img class="media-object" src="images/C.png" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a href="lecture.html?lectureName=C">C언어 기초 프로그래밍 강의</a>&nbsp;<span class="badge">New</span></h4>
                        C언어 강의는 기초 프로그래밍 강의입니다. 처음 프로그래밍을 접하는 입문자가 듣기에 적합합니다.
                        강의료는 무료이며 C언어 기초 프로그래밍 강의는 총 20강으로 구성됩니다. 
                    </div>
                </div>
                <hr>
                <div class="media">
                    <div class="media-left">
                        <a href="lecture.html?lectureName=Java"><img class="media-object" src="images/java.jpg" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a href="lecture.html?lectureName=Java">JAVA언어 기초 프로그래밍 강의</a>&nbsp;<span class="badge">New</span></h4>
                        JAVA언어 강의는 기초 프로그래밍 강의입니다. 처음 프로그래밍을 접하는 입문자가 듣기에 적합합니다.
                        강의료는 무료이며 JAVA언어 기초 프로그래밍 강의는 총 20강으로 구성됩니다. 
                    </div>
                </div>
                <hr>
                <div class="media">
                    <div class="media-left">
                        <a href="lecture.html?lectureName=Android"><img class="media-object" src="images/android.png" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a href="lecture.html?lectureName=Android">안드로이드 기초 프로그래밍 강의</a>&nbsp;<span class="badge">New</span></h4>
                        안드로이드 강의는 기초 프로그래밍 강의입니다. 처음 프로그래밍을 접하는 입문자가 듣기에 적합합니다.
                        강의료는 무료이며 안드로이드 기초 프로그래밍 강의는 총 20강으로 구성됩니다. 
                    </div>
                </div>
            </div>
        </div>
	</div>
	<%
		/*
			UserRegisterServlet.java, UserLoginServlet에서 session.setAttribute로 정의한 
			messageContent,messageType 을 session.getAttribute를 통해 가져와서, 색깔셋팅 등 messageModal 설정부분
		*/
		String messageContent = null;
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		if (messageContent != null) {
	%>
	<!--  messageModal -->
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if(messageType.equals("오류 메세지")) out.println("panel-warning"); else out.println("panel-success");%> ">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>		<!-- x버튼 -->
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body">
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<script>
		$('#messageModal').modal("show");
	</script>
	<%
		if(userID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function() {
				getUnread(); // 4초 안기다리고 바로 볼 수 있게 먼저해놓음 
				getInfiniteUnread();
			});
		</script>
	<%
		}
	%>
	  <!-- Bootstrap core JavaScript -->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Plugin JavaScript -->
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Contact Form JavaScript -->
  <script src="js/jqBootstrapValidation.js"></script>
  <script src="js/contact_me.js"></script>

  <!-- Custom scripts for this template -->
  <script src="js/freelancer.min.js"></script>
</body>
</html>