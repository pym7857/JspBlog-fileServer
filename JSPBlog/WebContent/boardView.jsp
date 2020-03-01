<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<%
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	
	String pageNumber = "1";
	if(request.getParameter("pageNumber") != null) {
		pageNumber = request.getParameter("pageNumber");
	}
	try {
		Integer.parseInt(pageNumber);
	} catch (Exception e) {
		session.setAttribute("messageType", "오류 메세지");
		session.setAttribute("messageContent", "페이지 번호가 올바르지 않습니다."); 
		response.sendRedirect("index.jsp");	
		return;
	}
	
	ArrayList<BoardDTO> boardList = new BoardDAO().getList(pageNumber); /* 페이지당 게시글 정보를 가져오는 함수 */
	
	UserDAO userDAO = new UserDAO();
	String userProfile = userDAO.getProfile(userID); // profile의 경로를 가져오는 메서드
%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="css/custom.css?versionewg=2">
	<link rel="stylesheet" type="text/css" href="css/custom2.css?versiontff=2">
	<title>OKKY</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script src="https://kit.fontawesome.com/4aa58836e4.js" crossorigin="anonymous"></script>
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
				<li><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
				<li><a href="box.jsp">메세지함<span id="unread" class="label label-info"></span></a></li>
				<li class="active"><a href="boardView.jsp">자유게시판</a></li>
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
		<table style="margin:0 auto; text-align: center; border: 0;">
			<thead>
				<tr>
					<th style="width: 800px;" colspan="6"><h4>자유게시판 <i class="fa fa-pencil-alt"></i></h4></th>
				</tr>
				<tr>
					<th style="font-weight: bold; background-color: #fafafa; color: #000000; width: 70px;"><h5>번호</h5></th> 
					<th style="background-color: #fafafa; color: #000000;"><h5>제목</h5></th> 
					<th style="background-color: #fafafa; color: #000000;"><h5>작성자</h5></th> 
					<th style="background-color: #fafafa; color: #000000;"><h5>추천</h5></th> 
					<th style="background-color: #fafafa; color: #000000; width: 100px;"><h5>작성날짜</h5></th> 
					<th style="background-color: #fafafa; color: #000000; width: 70px;"><h5>조회수</h5></th> 
				</tr>
			</thead>
			<tbody>
			<%
				for(int i=0; i<boardList.size(); i++) {
					BoardDTO board = boardList.get(i);
			%>
				<tr>
					<td><%= board.getBoardID() %></td>
					<td style="text-align: left;"><a href="boardShow.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardTitle() %></a></td>
					<td><%= board.getUserID() %></td>
					<td><%= board.getBoardLike() %></td>
					<td><%= board.getBoardDate() %></td>
					<td><%= board.getBoardHit() %></td>
				</tr>
			<%
				}
			%>
				<!-- 페이지 처리 부분 -->
				<tr>
					<td colspan="6">
						<a href="boardWrite.jsp" class="btn btn-warning pull-right" type="submit">글쓰기</a>
						<ul class="pagination" style="margin: 0 auto;"> <!-- 부트스트랩 : 페이지네이션 <ul> 태그로 제공 -->
					<%
						int startPage = (Integer.parseInt(pageNumber) / 3) * 3 + 1; // ex.. 1,2,3페이지 까지는 startPage = 1, 4 페이지 부터는 startPage = 4
						if(Integer.parseInt(pageNumber) % 3 == 0) startPage -= 3;
						int targetPage = new BoardDAO().targetPage(pageNumber); // targetPage 개수 (현재 페이지 포함, 앞으로 처리할 페이지 개수)
						
						/* [왼쪽 버튼] '<' 버튼 누르면 startPage -1 으로 넘어간다 */
						if(startPage != 1) { 
					%>
							<li><a href="boardView.jsp?pageNumber=<%= startPage - 1 %>"><span class="glyphicon glyphicon-chevron-left" style="color: orange;"></span></a></li>
					<%
						} else {
					%>
							<li><span class="glyphicon glyphicon-chevron-left" style="color: orange;"></span></li>
					<%
						}
						/* [현재 페이지] startPage부터 현재페이지 넘버 이전까지의 버튼 */
						for(int i = startPage; i < Integer.parseInt(pageNumber); i++) {
					%>
							<li><a style="color: black; background-color: transparent;" href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						} /* [현재 페이지] 현재 페이지 넘버 버튼*/
					%>
						<li class="active"><a style="color: black; background-color: transparent;" href="boardView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>
					<%
						/* [현재 페이지] 현재 페이지 넘버 다음부터의 버튼 */
						for(int i = Integer.parseInt(pageNumber) + 1; i < targetPage + Integer.parseInt(pageNumber); i++) {
							/* startPage + 3 의 범위를 넘지않는 버튼에 한해서만 */
							if(i < startPage + 3) { 
					%>
								<li><a style="color: black; background-color: transparent;" href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
								
					<%
							}
						}
						/* [오른쪽 버튼] 현재 페이지에서 처리할 페이지가 startPage + 3 인것부터는 '>' 버튼 누르면 startPage + 3 으로 넘어간다  */
						if(targetPage + Integer.parseInt(pageNumber) > startPage + 2) {	
					%>	
							<li><a href="boardView.jsp?pageNumber=<%= startPage + 3 %>"><span class="glyphicon glyphicon-chevron-right" style="color: orange;"></span></a></li>
					<%
						} else { 
					%>
							<li><span class="glyphicon glyphicon-chevron-right" style="color: orange;"></span></li>
					<%
						}
					%>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<%
		/*
			UserRegisterServlet.java, UserLoginServlet에서 session.setAttribute로 정의한 
			messageContent,messageType 을 session.getAttribute를 통해 가져와서, 색깔설정 등의 messageModal 설정부분
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
</body>
</html>