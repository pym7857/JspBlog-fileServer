<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,700" rel="stylesheet">
	<title>OKKY</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> 
	<link rel="stylesheet" type="text/css" href="css/custom.css">
	<link rel="stylesheet" type="text/css" href="css/custom2.css">
	<script src="https://kit.fontawesome.com/4aa58836e4.js" crossorigin="anonymous"></script>
	<style type="text/css">
		body{
			color: #fff;
			background: #3598dc;
			font-family: 'Roboto', sans-serif;
		}
	    .form-control{
			height: 41px;
			background: #f2f2f2;
			box-shadow: none !important;
			border: none;
		}
		.form-control:focus{
			background: #e2e2e2;
		}
	    .form-control, .btn{        
	        border-radius: 3px;
	    }
		.signup-form{
			width: 390px;
			margin: 30px auto;
		}
		.signup-form form{
			color: #999;
			border-radius: 3px;
	    	margin-bottom: 15px;
	        background: #fff;
	        box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
	        padding: 30px;
	    }
		.signup-form h2 {
			color: #333;
			font-weight: bold;
	        margin-top: 0;
	    }
	    .signup-form hr {
	        margin: 0 -30px 20px;
	    }    
		.signup-form .form-group{
			margin-bottom: 20px;
		}
		.signup-form input[type="checkbox"]{
			margin-top: 3px;
		}
		.signup-form .row div:first-child{
			padding-right: 10px;
		}
		.signup-form .row div:last-child{
			padding-left: 10px;
		}
	    .signup-form .btn{        
	        font-size: 16px;
	        font-weight: bold;
			background: #3598dc;
			border: none;
			min-width: 140px;
	    }
		.signup-form .btn:hover, .signup-form .btn:focus{
			background: #2389cd !important;
	        outline: none;
		}
	    .signup-form a{
			color: #fff;
			text-decoration: underline;
		}
		.signup-form a:hover{
			text-decoration: none;
		}
		.signup-form form a{
			color: #3598dc;
			text-decoration: none;
		}	
		.signup-form form a:hover{
			text-decoration: underline;
		}
	    .signup-form .hint-text {
			padding-bottom: 15px;
			text-align: center;
	    }
	    .temp {
	    	color: black;
	    }
	</style>
	<script type="text/javascript">
		/* 이벤트 처리 */
		function registerCheckFunction() {		// Function(): ajax로 모달 띄워주는 역할
			var userID = $('#userID').val();		// (input 부분의) id:userID
			$.ajax({
				type: 'POST',
				url: './UserRegisterCheckServlet',
				data: {userID: userID},
				success: function(result) {		// result는... (UserRegisterCheckServlet) response.getWriter.write( userDAO.registerCheck(result) ) 로 부터...
					if(result == 1) { 
						$('#checkMessage > p').html('사용할 수 있는 아이디입니다.');				
						$('#checkType').attr('class', 'modal-content panel-success');	// 초록
					} else {
						$('#checkMessage > p').html('사용할 수 없는 아이디입니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');	// 노랑
					}
					$('#checkModal').modal("show");
				}
			});
		}
		function passwordCheckFunction() {
			var userPassword1 = $('#userPassword1').val();		// Line:116
			var userPassword2 = $('#userPassword2').val();
			if(userPassword1 != userPassword2) {
				$('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');		// Line 151:  <h5 id:psswordCheckMessage></h5>
			} else {
				$('#passwordCheckMessage').html('');
			}
		}
	</script>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID != null) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "이미 로그인된 회원입니다.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
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
				}
			%>
		</div>
	</nav>
	
	<div class="signup-form">
	    <form method="post" action="./userRegister">
			<h2>Sign Up</h2>
			<p>Please fill in this form to create an account!</p>
			<hr>
	        <div class="form-group">
				<input type="text" class="form-control" id="userID" name="userID" placeholder="아이디를 입력하세요" required="required">
				<button class="btn btn-warning" onclick="registerCheckFunction();" type="button">중복체크</button>
	        </div>
			<div class="form-group">
	            <input onkeyup="passwordCheckFunction();" type="password" class="form-control" id="userPassword1" name="userPassword1" placeholder="비밀번호를 입력하세요" required="required">
	        </div>
			<div class="form-group">
	            <input onkeyup="passwordCheckFunction();" type="password" class="form-control" id="userPassword2" name="userPassword2" placeholder="비밀번호를 다시 입력하세요" required="required">
	        </div>        
	        <div class="form-group">
				<input type="text" class="form-control" id="userName" name="userName" placeholder="이름을 입력하세요" required="required">
	        </div>
	        <div class="form-group">
				<input type="number" class="form-control" id="userAge" name="userAge" placeholder="나이를 입력하세요" required="required">
	        </div>
	        <div class="form-group" style="text-align:center; margin:0 auto;">
				<div class="btn-group" data-toggle="buttons">
					<label class="btn btn-primary active">
						<input type="radio" name="userGender" autocomplete="off" value="남자" checked>남자
					</label>
					<label class="btn btn-primary">
						<input type="radio" name="userGender" autocomplete="off" value="여자">여자
					</label>
				</div>
			</div>
	        <div class="form-group">
				<input type="email" class="form-control" id="userEmail" name="userEmail" placeholder="이메일을 입력하세요" required="required">
	        </div>
	        <div class="form-group">
				<label class="checkbox-inline"><input type="checkbox" required="required"> I accept the <a href="#">Terms of Use</a> &amp; <a href="#">Privacy Policy</a></label>
			</div>
			<div class="form-group">
	            <button type="submit" class="btn btn-primary btn-lg">Sign Up</button>
	        </div>
	    </form>
		<div class="hint-text">Already have an account? <a href="#">Login here</a></div>
	</div>
	<%
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
	<script>
		$('#messageModal').modal("show");
	</script>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<!-- checkModal -->
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">		<!-- id: checkType -->
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>		
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							확인메세지
						</h4>
					</div>
					<div class="modal-body" id="checkMessage">		<!-- id: checkMessage -->
						<p class="temp"></p>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>