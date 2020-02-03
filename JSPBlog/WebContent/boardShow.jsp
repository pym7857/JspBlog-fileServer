<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="board.CommentDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<%
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	String boardID = null;
	if(request.getParameter("boardID") != null) {
		boardID = (String) request.getParameter("boardID");
	}
	BoardDAO boardDAO = new BoardDAO();
	BoardDTO board = boardDAO.getBoard(boardID); // 하나의 게시물에 대한 정보 가져오기
	boardDAO.hit(boardID); // 게시물 들어올때마다 조회수 +1
	
	String boardUser = board.getUserID();
	String fromProfile = new UserDAO().getProfile(boardUser); // 게시물 작성자의 사진
	
	UserDAO userDAO = new UserDAO();
	String userProfile = userDAO.getProfile(userID); // profile의 경로를 가져오는 메서드
	
	ArrayList<CommentDTO> commentList = boardDAO.getCommentList(boardID); // 댓글 리스트를 가져오는 ArrayList
%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="css/custom.css?versionewg=2">
	<link rel="stylesheet" type="text/css" href="css/custom2.css?versiontff=2">
	<title>JSP Ajax 실시간 회원제 채팅 서비스</title>
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
		
		var boardID = '<%= boardID %>';
		
		/* 좋아요 개수 표시 함수 */
		function getLike() {
			$.ajax({
				type: "POST",
				url: "./boardLike",
				data: {boardID: boardID},
				success: function(result) {
					if(result >= 0) {
						showLikeNumber(result); // result = 좋아요 개수 
					}
					else {
						console.log(boardID);
					}
				}
				
			});
		}
		function showLikeNumber(result) {
			$('#likeNumber').html(result);
		}
		function getInfiniteLike() {
			setInterval(function() {
				getLike();
			}, 4000);
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
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="4"><h4>게시물 보기</h4></th>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>제목</h5></td>
					<td colspan="3"><h5><%= board.getBoardTitle() %></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>작성자</h5></td>
					<td colspan="3"><h5><img class="media-object img-circle" style="margin: 0 auto; max-width: 40px; max-height: 40px;" src="<%= fromProfile %>"></img><%= board.getUserID() %></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 100px;"><h5>작성날짜</h5></td>
					<td><h5><%= board.getBoardDate() %></h5></td>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>조회수</h5></td>
					<td><h5><%= board.getBoardHit() %></h5></td>
				</tr>
				<tr>
					<td style="vertical-align: middle; min-height: 150px; background-color: #fafafa; color: #000000; height: 100px; width:80px;"><h5>글 내용</h5></td>
					<td colspan="3" style="text-align: left;"><h5><%= board.getBoardContent() %></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>첨부파일</h5></td>
					<td colspan="3"><h5><a href="boardDownload.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardFile() %></a></h5></td>
				</tr>
			</thead>
			<tbody>
			<%
				if(userID != null) {
			%>
				<tr>
					<td colspan="5">
						<a href="boardLikeUpdate?boardID=<%= board.getBoardID() %>" class="btn btn-primary" style="background-color:white; color:black;">좋아요 <span id="likeNumber" style="color:red; font-weight:bold;"></span></a>
					</td>
				</tr>
				<tr>
			<%
				}
			%>
					<td colspan="5" style="text-align: right;">
						<a href="boardView.jsp" class="btn btn-primary">목록</a>
						<%
							if(userID != null && userID.equals(board.getUserID())) { // 작성자 본인만 볼 수 있는 버튼들 
						%>
							<a href="boardUpdate.jsp?boardID=<%= board.getBoardID() %>" class="btn btn-primary">수정</a>
							<a href="boardDelete?boardID=<%= board.getBoardID() %>" class="btn btn-primary" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</a>
						<%
							}
						%>
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 댓글  -->
		<div class="row">
		<%
			for(int i=0; i<commentList.size(); i++) {
				CommentDTO comment = commentList.get(i);
		%>
			<ul>
				<li style="list-style:none; display: inline; font-weight:bold; color:#5882FA;"><%= comment.getUserID() %></li>
				<li style="list-style:none; display: inline;"><%= comment.getContentDate() %></li>
			</ul>
			<ul>
				<li style="list-style:none; display: inline;"><%= comment.getContent() %></li>
		<%
				if(userID != null && userID.equals(comment.getUserID())) { // 댓글 작성자 본인에 한해서만 보여지도록 
		%>
				<a href="boardCommentDelete?commentID=<%= comment.getCommentID() %>" class="btn btn-primary pull-right" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</a>
		<%
				} 
		%>
			</ul>
			<hr>
		<%
			}
		%>
		</div>
		<%
			if(userID != null) {
		%>
			<!-- 댓글 입력창 -->
			<form method="post" action="./boardCommentWrite?boardID=<%= board.getBoardID() %>">
				<div class="row">
					<input class="form-control" maxlength="100" name="content" style="height:80px;" placeholder="댓글을 입력해주세요.">
					<input class="btn btn-primary pull-right" type="submit" value="댓글쓰기" style="margin-top:10px; font-weight:bold; font-size:120%; height:40px; width:180px; border:1px solid red; background-color:red;">	
				</div>
			</form>
			<hr>
		<%
			} else {
		%>
			<h5 style="text-align:center;"> 로그인을 하셔야 댓글을 작성할 수 있습니다. </h5>
		<%
			}
		%>
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
	</script>
	<%
		if(userID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function() {
				getUnread(); // 4초 안기다리고 바로 볼 수 있게 먼저해놓음 
				getInfiniteUnread();
				getLike();
				getInfiniteLike();
			});
		</script>
	<%
		}
	%>
</body>
</html>