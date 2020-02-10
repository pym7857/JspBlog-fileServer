<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="user.UserDAO" %>
<%@ page import="user.UserDTO" %>
<%@ page import="java.io.File" %>
<%@ page import="file.FileDAO" %>
<%@ page import="file.FileDTO" %>
<html>
<%
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) { 
		session.setAttribute("messageType", "오류 메세지");
		session.setAttribute("messageContent", "현재 로그인이 되어 있지 않습니다."); 
		response.sendRedirect("login.jsp");	
		return;
	}

	UserDAO userDAO = new UserDAO();
	String userProfile = userDAO.getProfile(userID); // profile의 경로를 가져오는 메서드
	
%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="css/custom.css?ver=1">
	<link rel="stylesheet" type="text/css" href="css/custom2.css?ver=1">
	<link href="https://vjs.zencdn.net/7.0.0/video-js.css" rel="stylesheet">
	<script src="https://vjs.zencdn.net/7.0.0/video.min.js"></script>
	<script src="https://unpkg.com/silvermine-videojs-quality-selector/dist/js/silvermine-videojs-quality-selector.min.js"></script>
	<title>스트리밍</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script src="https://kit.fontawesome.com/4aa58836e4.js" crossorigin="anonymous"></script>
	<style type="text/css">
	  .vjs-default-skin { color: #ffffff; font-size: 1.5rem;}
	  .vjs-default-skin .vjs-play-progress,
	  .vjs-default-skin .vjs-volume-level { background-color: #ff0000 }
	  .vjs-default-skin .vjs-control-bar,
	  .vjs-default-skin .vjs-big-play-button { background: rgba(0,0,0,0.43) }
	  .vjs-default-skin .vjs-slider { background: rgba(0,0,0,0.14333333333333334) }
	</style>
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
		
		// 비디오 
		var video;
		
		$('document').ready(function() {
			FnObj.initVideoPlayer();
			FnObj.bindVideoPlayerKeyEvent();
		});
		
		var FnObj = {
				// 비디오 초기화 설정
				initVideoPlayer: function() {
					var options = {
							language: 'kr',
							controls: true,
							autoplay: true,
							notSupportedMessage: '해당 영상을 재생할 수 없습니다. 자바스크립트 사용 옵션이 꺼져있거나 혹은 웹에서 지원하지 않는 영상 인코딩 포맷입니다.',
							playbackRates: [0.25, 0.5, 0.75, 1, 1.5, 2],
							//nativeControlsForTouch: true,
							preload: 'auto',
							fluid: true,
							fill: true,
							controlBar: {
						        children: [
						            "playToggle",
						            "volumePanel",
						            "currentTimeDisplay",
						            "timeDivider",
						            "durationDisplay",
						            "progressControl",
						            "remainingTimeDisplay",
						            "QualitySelector",
						            "PlaybackRateMenuButton",
						            "subCapsButton",
						            "audioTrackButton",
						            "fullscreenToggle"
						        ]
						    }
						};
						video = videojs('streaming_video', options); // https://docs.videojs.com/tutorial-setup.html (Manual Setup 탭 참조)
				},
				// 비디오 키보드 이벤트 처리
				bindVideoPlayerKeyEvent: function() {
					window.onkeydown = function(event) {
						//화살표 왼쪽
						if (event.keyCode == 37)
							video.currentTime(video.currentTime()-5);
						//화살표 오른쪽
						else if (event.keyCode == 39)
							video.currentTime(video.currentTime()+5);
						//화살표 위쪽
						else if (event.keyCode == 38)
							video.volume(video.volume()+0.1);
						//화살표 아래쪽
						else if (event.keyCode == 40)
							video.volume(video.volume()-0.1);
						//스페이스바
						else if (event.keyCode == 32) {
							if (video.paused())
								video.play();
							else
								video.pause();
						}
					    //엔터키
						else if (event.keyCode == 13) {
							if (video.isFullscreen())
								video.exitFullscreen();
							else
								video.requestFullscreen();
						}
						//ESC키
						else if (event.keyCode == 27)
							if (video.isFullscreen())
								video.exitFullscreen();
					}
				}
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
			<a class="navbar-brand" href="index.jsp"><i class="fa fa-home"></i> 조유리 사생팬</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
				<li><a href="box.jsp">메세지함<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">자유게시판</a></li>
				<li class="active"><a href="fileShare.jsp">파일공유</a></li>
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
	
	<%
		String tempName = request.getParameter("file"); // url의 parameter에서 fileName=? 부분 
		//System.out.println('2' + tempName);
		String streamFileName = tempName;
	%>
	
	<!-- 비디오 플레이어 -->
	<div class="container" style="padding-top: 90px;">
		<video id="streaming_video" class="video-js vjs-default-skin">
			<source src="http://pym7857.cafe24.com/downloadAction?file=<%= streamFileName %>" type="video/mp4" label="원본">
		</video>
	</div>
	<div style="text-align: center; margin-top: 10px; font-size: 2rem; color: #bbb;">Powered by <a href="http://www2.videojs.com/" title="http://www2.videojs.com/">Video.js</a></div>
	
	<!-- 메세지 모달 -->
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
</body>
</html>