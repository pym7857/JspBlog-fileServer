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
	<link rel="stylesheet" type="text/css" href="css/custom.css?after">
	<link rel="stylesheet" type="text/css" href="css/custom2.css?ver=1">
	<link href="css/animate.css" rel="stylesheet">
	<title>OKKY</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script src="https://kit.fontawesome.com/4aa58836e4.js" crossorigin="anonymous"></script>
	<style type="text/css">
		.viewtag {
			cursor: pointer;
			transition: color 0.3s ease 0s, text-shadow 0.3s ease 0s;
		}
		.viewtag:hover {
			color: black;
			text-shadow: 2px 2px 8px #000000;
		}
	</style>
	<script type="text/javascript">
		$(function(){
			  $('.media').hover(function(){
				  $(this).addClass('animated pulse');
			    	console.log('hover2!');
				}, function() {
					$(this).removeClass('animated pulse');
					console.log('unhover2!');
				});
		  });
	</script>
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
	<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp"><i class="fa fa-home"></i> Y&lt;&gt;UNG ++</a>
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
                <h4><i class="fa fa-fire"></i> 실시간 인기 게시물</h4>
               	<hr>
            <%
				for(int i=0; i<boardPopularList.size(); i++) {
					BoardDTO board = boardPopularList.get(i);
			%>
				<ul>
					<li style="list-style:none; font-weight: bold;"><img src="images\star.png" style="width:20px; height:20px;"></img>&nbsp<a class="viewtag" href="boardShow.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardTitle() %></a></li>
					<li style="list-style:none; margin-top:5px; font-size: 80%; color:grey;">작성자 <%= board.getUserID() %> | 조회  <%= board.getBoardHit() %> | 추천 <%= board.getBoardLike() %></li>
					
				</ul>
				<hr style="margin-top:0px;">
			<%
				}
			%>
            </div>
            <div class="col-md-6">
            	<h4><i class="fa fa-map-marker-alt"></i> 최신글</h4>
            	<hr>
            <%
				for(int i=0; i<boardList.size(); i++) {
					BoardDTO board = boardList.get(i);
			%>
				<ul>
					<li style="list-style:none; font-weight: bold;"><img src="images\balloon.png" style="width:50px; height:30px;"></img>&nbsp<a class="viewtag" href="boardShow.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardTitle() %></a></li>
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
            <div class="panel-heading" style="background-color: #6b7ae0;">
                <h3 class="panel-title"><span class="glyphicon glyphicon-pencil"></span>
                &nbsp;&nbsp;<b>포트폴리오</b></h3>
            </div>
            <div class="panel-body">
                <div class="media">
                    <div class="media-left">
                        <a href="#"><img class="media-object" src="images/rasp.png" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a style="font-weight:bold;" href="#">라즈베리파이 AIOT 자율주행 차</a>&nbsp;<span class="badge">New</span></h4>
                        	4학년 1학기 종합설계 프로젝트. Object Detection을 이용한 장애물&표지판 인식, Hough Line Transform을 이용한 차선 인식 및 자율주행 <br>
                        	RC car에 직접 모터드라이버를 적용해 자율주행 차 제작. <br>
                        	(3월 30일 완성 예정 ..)
                    </div>
                </div>
                <hr>
                <div class="media">
                    <div class="media-left">
                        <a href="#"><img class="media-object" src="images/sh.png" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a style="font-weight:bold;" href="#">Price Change Prediction</a>&nbsp;<span class="badge">New</span></h4>
                        	3학년2학기 종합설계 프로젝트. 웹 크롤링을 통해 KAMIS에서 농산물 유통가격정보와 날짜 등을 얻어오고, 기상청 사이트에서 20개년 날짜정보를 크롤링.<br>
                        	이후 Pearson Correlation을 이용해 변인들간의 가중치 분석 후 실제 사용변인 결정. <br>
                        	이를 토대로 tensorflow API를 이용해 가격의 다변인 선형회귀 적용&예측. 또한 LSTM을 이용해 수개월 후의 가격까지 예측. <br>
                        	Python Flask, ASW EC2를 이용하여 최종적으로 호스팅 구축 완료.
                    </div>
                </div>
                <hr>
                <div class="media">
                    <div class="media-left">
                        <a href="#"><img class="media-object" src="images/jsp.png" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a style="font-weight:bold;" href="#">JSP Ajax를 이용한 커뮤니티 & 파일공유 사이트</a>&nbsp;<span class="badge">New</span></h4>
							JSP Ajax를 이용해 실시간 채팅서비스 & 자유게시판 커뮤니티 제작. 자유게시판 커뮤니티 게시글의 페이지 네이션, 좋아요, 댓글 구현 <br>
							MultiPartRequest를 이용해 파일 다운로드 & 업로드 구현. Html5 video.js를 이용해 웹 스트리밍 구현. <br>
							Javascript 코드를 통해, 파일 공유 페이지 context menu구현 & 검색 필터링 구현. <br>
							cafe24.com를 통해 최종 호스팅 구축 완료.
                    </div>
                </div>
                <hr>
                <div class="media">
                    <div class="media-left">
                        <a href="#"><img class="media-object" src="images/jsImage.jpg" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a style="font-weight:bold;" href="#">VanillaJS를 이용한 웹 게임</a>&nbsp;<span class="badge">New</span></h4>
                        	2048게임, 테트리스 등을 직접 만들어보며 JS전반에 걸친 여러 중요 개념들을 효율적으로 학습.
                    </div>
                </div>
                <hr>
                <div class="media">
                    <div class="media-left">
                        <a href="#"><img class="media-object" src="images/pythonImage.png" style="width:120px; height: 120px;"></a>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading"><a style="font-weight:bold;" href="#">파이썬 웹 크롤링을 이용한 indeed 자동화</a>&nbsp;<span class="badge">New</span></h4>
                        	Beautiful Soup를 이용해, 직접 채용공고 사이트에 들어가지 않고도 여러 디테일한 구인 정보를 엑셀형태로 정렬하여 추출. 
                    </div>
                </div>
                <hr>
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
		$(document).ready(function() {
			$('.dropdown,.dropdown-menu').hover(function(){
		          if($(window).width()>=768){
		            $(this).addClass('open').trigger('shown.bs.dropdown')
		            return false;
		          }
		        },function(){
		          if($(window).width()>=768){
		            $(this).removeClass('open').trigger('hidden.bs.dropdown')
		            return false;
		          }
		        })
		});
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