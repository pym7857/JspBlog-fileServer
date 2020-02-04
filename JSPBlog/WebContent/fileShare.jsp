<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="user.UserDAO" %>
<%@ page import="user.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
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

	ArrayList<FileDTO> fileList = new FileDAO().getList();
%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="css/custom.css?ver=1">
	<link rel="stylesheet" type="text/css" href="css/custom2.css?ver=1">
	<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.7.1/jquery.contextMenu.min.css" />
	<title>JSP Ajax 실시간 회원제 채팅 서비스</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.7.1/jquery.contextMenu.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.7.1/jquery.ui.position.js"></script>
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
		
		var FnObj = {
				convertToVolumeStr: function(fileVolume) {
					var sizeStr;
					var temp = fileVolume;
					if (temp < 1024)
						sizeStr = Math.round(temp*100)/100.0+' Byte';
					else if ((temp /= 1024) < 1024)
						sizeStr = Math.round(temp*100)/100.0+' KB';
					else if ((temp /= 1024) < 1024)
						sizeStr = Math.round(temp*100)/100.0+' MB';
					else if ((temp /= 1024) < 1024)
						sizeStr = Math.round(temp*100)/100.0+' GB';
					else if ((temp /= 1024) < 1024)
						sizeStr = Math.round(temp*100)/100.0+' TB';
					else if ((temp /= 1024) < 1024)
						sizeStr = Math.round(temp*100)/100.0+' PB';
					return sizeStr;
				},
				changeFile: function(fileToUpload) {
					var file = fileToUpload.files[0];
					//console.log(file);
					if (file) {
						$('#fileVolume').text(FnObj.convertToVolumeStr(file.size));
					}
				}
		}
		
		function load(fileToUpload) {
			dataType : null;
			downLink : null;
			fileName : null;
			StreamingLink : null;
		
			this.fileName = fileToUpload;
			var dlink = 'localhost:8084<%= request.getContextPath() %>/downloadAction?file=';
			dlink += fileName
			this.downLink = dlink;
			//console.log(fileName);
			var contextMenuItems = {}
			contextMenuItems.download = {
            	name: "다운로드", 
            	icon: "copy",
            	callback: function(key, opt) {
            		//location.href = downLink;
            		//location.replace(downLink);
            		//window.location.href = downLink;
            		window.open(downLink); // this.downLink라고 하면 에러 ! 
            	}
            };
       		var tempType = fileName.split('.')[1];
       		this.dataType = tempType;
       		//console.log(dataType);
       		var slink = 'streaming.jsp?file=';
       		slink += fileName
       		this.StreamingLink = slink;
       		console.log(StreamingLink)
   			contextMenuItems.webStreaming = {
               	name: "웹 스트리밍", 
               	icon: "copy",
               	callback: function(key, opt) {
               		if (dataType == 'mp4') {
               			location.href = StreamingLink;
               		}
               		else {
               			alert('비디오 형식이 아닙니다!');
               		}
               	}
   	        };
			contextMenuItems.del = {
            	name: "삭제", 
            	icon: "delete"
	        };
			contextMenuItems.quit = {
               	name: "닫기", 
               	icon: function(){
               	    return 'context-menu-icon context-menu-icon-quit';
               	},
               	callback: function(key, opt) {}
            };
			
			$.contextMenu({
				selector: '.downloadtag',
	            trigger: 'left', // left mouse button
				animation: {duration: 200, show: 'slideDown', hide: 'slideUp'},
	            items: contextMenuItems
			});
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
	
	<form action="./uploadAction" method="post" enctype="multipart/form-data">
		<div class="container">
			<table class="table" style="margin-bottom: 10px;">
				<tr>
					<td class="col-xs-1">파일 업로드</td>
					<td colspan="2">
						<input type="file" name="file" onchange="FnObj.changeFile(this);">
					</td>
					<td class="col-xs-1">용량</td>
					<td class="col-xs-1">
						<span id="fileVolume"></span>
					</td>
					<td class="col-xs-1">
						<input type="submit" name="file" value="업로드" class="btn btn-success btn-xs" style="float:left;" 
						data-toggle="tooltip" data-placement="bottom" title="파일을 업로드 합니다.">
					</td>
				</tr>
			</table>
		</div>
	</form>
	
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="6"><h4>파일 토렌트</h4></th>
				</tr>
				<tr>
					<th style="font-weight: bold; background-color: #fafafa; color: #000000; width: 70px;"><h5>유형</h5></th> 
					<th style="background-color: #fafafa; color: #000000;"><h5>파일 이름</h5></th> 
					<th style="background-color: #fafafa; color: #000000;"><h5>용량</h5></th>
					<th style="background-color: #fafafa; color: #000000;"><h5>업로더</h5></th> 
					<th style="background-color: #fafafa; color: #000000; width: 100px;"><h5>업로드 날짜</h5></th> 
					<th style="background-color: #fafafa; color: #000000; width: 120px;"><h5>다운로드 횟수</h5></th> 
				</tr>
			</thead>
			<tbody>
			<%
				for(FileDTO file : fileList) {
			%>
				<tr>
					<td style="text-align:center; vertical-align: middle;"><%= file.getFileType() %></td>
					<td style="text-align: left; vertical-align: middle;"><a class="downloadtag" onclick="load(this.title);"
					title=<%= java.net.URLEncoder.encode(file.getFileRealName(), "UTF-8")%>><%= file.getFileName() %></a></td>
					<td style="text-align:center; vertical-align: middle;"><%= file.getFileSize() %></td>
					<td style="text-align:center; vertical-align: middle;"><%= userID %></td>
					<td style="text-align:center; vertical-align: middle;"><%= file.getFileDate() %></td>
					<td style="text-align:center; vertical-align: middle;"><%= file.getDownloadCount() %></td>
				</tr>
			<%
				}
			%>
			</tbody>
		</table>
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
</body>
</html>