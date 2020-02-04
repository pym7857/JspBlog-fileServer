<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="file.FileDAO" %>
<%@ page import="file.FileDTO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
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
	<title>JSP Ajax 실시간 회원제 채팅 서비스</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<style type="text/css">
		.downloadtag {
			cursor: pointer;
			transition: color 0.3s ease 0s, text-shadow 0.3s ease 0s;
		}
		.downloadtag:hover {
			color: black;
			text-shadow: 2px 2px 8px #000000;
		}
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
			<a class="navbar-brand" href="index.jsp">실시간 채팅 서비스</a>
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
		/*
			//String directory = application.getRealPath("/upload/");
			String directory = "C:/JSP/upload/";
			String files[] = new File(directory).list(); // File들을 담을 배열 
			
			for (String file : files) {
				out.write("<a href=\"" + request.getContextPath() + "/downloadAction?file=" +
					java.net.URLEncoder.encode(file, "UTF-8") + "\">" + file + "</a><br>");
			}
		*/
		ArrayList<FileDTO> fileList = new FileDAO().getList();
		
		for(FileDTO file : fileList) {
			out.write("<a class='downloadtag' href=\"" + request.getContextPath() + "/downloadAction?file=" +
					java.net.URLEncoder.encode(file.getFileRealName(), "UTF-8") + "\">" + 
						file.getFileName() + "(다운로드 횟수: " + file.getDownloadCount() + ")</a><br>");
		}
	%>
</body>
</html>