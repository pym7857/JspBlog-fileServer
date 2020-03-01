<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>OKKY</title>

  <!-- Custom fonts for this theme -->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic" rel="stylesheet" type="text/css">
  <link href="css/freelancer.min.css" type="text/css" rel="stylesheet">
  <link href="css/animate.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  <script src="https://kit.fontawesome.com/4aa58836e4.js" crossorigin="anonymous"></script>
  <style type="text/css">
	/* skillsInfo*/
	#skillsInfoArea {
		margin: 0 auto;
		width: 86%;
		max-width: 1280px;
		border-radius: 40px;
		padding: 50px;
	}
	#skillsArea {
		width: 50%;
		float: left;
		margin-right: 5%;
	}
	#infoArea {
		width: 44%;
		display: inline-block;
	}
	#infoArea tr {
		height: 40px;
	}
	.skillProgressBarBG {
		background: #ddd;
		width: 100%;
		margin-bottom: 5px;
	}
	.skillProgressBar {
		height: 10px;
	}
  </style>
  <script type="text/javascript">
	  $(function(){
		  $('#introduce').hover(function(){
			  $(this).addClass('animated rubberBand'); // animate.css
		    	console.log('hover!');
			}, function() {
				$(this).removeClass('animated rubberBand');
				console.log('unhover!');
			});
	  });
  </script>
  <script type="text/javascript">
	  var FnObj = {
				bodyScrollEvt: function(evt) {
					this.scrollSkillsGraph.process();
				},
				scrollSkillsGraph: {
					isFirst: true,
					process: function() {
						if (this.isFirst && $('#skillsInfoArea').offset().top - $(window).height() < $('html').scrollTop()) {
							var valueArr = [];
							$('#skillsInfoArea').find('.skillProgressBar').each(function() {
								valueArr.push([this, $(this).width()/$(this).parent().width()]);
								$(this).css('width', '1px');
							});
							for (let i = 0; i < valueArr.length; i++) {
								setTimeout(function() {
									$(valueArr[i][0]).css('transition', 'width 1s ease 0.7s');
									$(valueArr[i][0]).css('width', Math.round(valueArr[i][1]*100)+'%');
								}, 100*(i+1));
							}
							this.isFirst = false;
						}
					}
				}
	  }
  </script>
  
</head>

<body id="page-top" onscroll="FnObj.bodyScrollEvt(this);">

  <!-- Navigation -->
  <nav class="navbar navbar-expand-lg bg-secondary text-uppercase fixed-top" id="mainNav">
    <div class="container">
      <a class="navbar-brand js-scroll-trigger" href="#page-top"> Y&lt;&gt;UNG ++ <i class="fa fa-palette"></i></a>
      <button class="navbar-toggler navbar-toggler-right text-uppercase font-weight-bold bg-primary text-white rounded" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
        Menu
        <i class="fas fa-bars"></i>
      </button>
      <div class="collapse navbar-collapse" id="navbarResponsive">
        <ul class="navbar-nav ml-auto">
          <li class="nav-item mx-0 mx-lg-1">
            <a class="nav-link py-3 px-0 px-lg-3 rounded js-scroll-trigger" href="#portfolio">Portfolio</a>
          </li>
          <li class="nav-item mx-0 mx-lg-1">
            <a class="nav-link py-3 px-0 px-lg-3 rounded js-scroll-trigger" href="#about">About</a>
          </li>
          <li class="nav-item mx-0 mx-lg-1">
            <a class="nav-link py-3 px-0 px-lg-3 rounded js-scroll-trigger" href="#contact">Contact</a>
          </li>
          <li class="nav-item mx-0 mx-lg-1">
            <a class="nav-link py-3 px-0 px-lg-3 rounded js-scroll-trigger" href="index.jsp" style="color: yellow">Server</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

  <!-- Masthead -->
  <header class="masthead bg-primary text-white text-center">
    <div class="container d-flex align-items-center flex-column">

      <!-- Masthead Avatar Image -->
      <img class="masthead-avatar mb-5" src="img/avataaars.svg" alt="">

      <!-- Masthead Heading -->
      <h1 id="introduce" class="masthead-heading text-uppercase mb-0">Hello! I'm YoungMin Park</h1>

      <!-- Icon Divider -->
      <div class="divider-custom divider-light">
        <div class="divider-custom-line"></div>
        <div class="divider-custom-icon">
          <i class="fas fa-star"></i>
        </div>
        <div class="divider-custom-line"></div>
      </div>

      <!-- Masthead Subheading -->
      <p class="masthead-subheading font-weight-light mb-0">Student - Web Developer - Algorithm</p>

    </div>
  </header>
  
  <!-- About Section -->
  <section class="page-section bg-primary text-white mb-0" id="about">
    <div class="container">
    
      <!-- About Section Heading -->
      <h2 class="page-section-heading text-center text-uppercase text-white">About</h2>

      <!-- Icon Divider -->
      <div class="divider-custom divider-light">
        <div class="divider-custom-line"></div>
        <div class="divider-custom-icon">
          <i class="fas fa-star"></i>
        </div>
        <div class="divider-custom-line"></div>
      </div>
      
      <!-- SkiilsInfoArea -->
	  <div id="skillsInfoArea" class="contentArticle">
		<h2 style="text-align: center;"><i class="axi axi-head"></i> Skills & Info</h2>
		<div id="skillsArea">
			<b>HTML5</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #F44336; width: 75%;"></div>
			</div>
			<b>CSS3</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #FFA000; width: 55%;"></div>
			</div>
			<b>Javascript & jQuery</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #6060ff; width: 65%;"></div>
			</div>
			<b>Python</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #2196F3; width: 90%;"></div>
			</div>
			<b>Java</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #8cf519; width: 60%;"></div>
			</div>
			<b>Servlet</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #fbff10; width: 70%;"></div>
			</div>
			<b>SQL</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #F06292; width: 45%;"></div>
			</div>
			<b>C++</b>
			<div class="skillProgressBarBG">
				<div class="skillProgressBar" style="background: #27ae60; width: 10%;"></div>
			</div>
		</div>
		<div id="infoArea">
			<table style="width: 100%; font-family: sans-serif;">
				<tr>
					<th>AGE</th>
					<td>26</td>
				</tr>
				<tr>
					<th>BIRTH</th>
					<td>March 19, 1995</td>
				</tr>
				<tr>
					<th>SCHOOL</th>
					<td>Dankook Univ.</td>
				</tr>
				<tr>
					<th>MAJOR</th>
					<td>Software Engineering</td>
				</tr>
				<tr>
					<th>GRADE</th>
					<td>senior</td>
				</tr>
				<tr>
					<th>E-MAIL</th>
					<td>angksflvlf52@gmail.com</td>
				</tr>
				<tr>
					<th>SITE</th>
					<td>https://edelweiss-ever.tistory.com/</td>
				</tr>
				<tr>
					<th>PHONE</th>
					<td>010-2049-7699</td>
				</tr>
			</table>
		</div>
	  </div>
    </div>
  </section>

  <!-- Contact Section -->
  <section class="page-section" id="contact">
    <div class="container">

      <!-- Contact Section Heading -->
      <h2 class="page-section-heading text-center text-uppercase text-secondary mb-0">Contact Me</h2>

      <!-- Icon Divider -->
      <div class="divider-custom">
        <div class="divider-custom-line"></div>
        <div class="divider-custom-icon">
          <i class="fas fa-star"></i>
        </div>
        <div class="divider-custom-line"></div>
      </div>

      <!-- Contact Section Form -->
      <div class="row">
        <div class="col-lg-8 mx-auto">
          <!-- To configure the contact form email address, go to mail/contact_me.php and update the email address in the PHP file on line 19. -->
          <form name="sentMessage" id="contactForm" novalidate="novalidate">
            <div class="control-group">
              <div class="form-group floating-label-form-group controls mb-0 pb-2">
                <label>Name</label>
                <input class="form-control" id="name" type="text" placeholder="Name" required="required" data-validation-required-message="Please enter your name.">
                <p class="help-block text-danger"></p>
              </div>
            </div>
            <div class="control-group">
              <div class="form-group floating-label-form-group controls mb-0 pb-2">
                <label>Your Email Address</label>
                <input class="form-control" id="email" type="email" placeholder="Email Address" required="required" data-validation-required-message="Please enter your email address.">
                <p class="help-block text-danger"></p>
              </div>
            </div>
            <div class="control-group">
              <div class="form-group floating-label-form-group controls mb-0 pb-2">
                <label>Phone Number</label>
                <input class="form-control" id="phone" type="tel" placeholder="Phone Number" required="required" data-validation-required-message="Please enter your phone number.">
                <p class="help-block text-danger"></p>
              </div>
            </div>
            <div class="control-group">
              <div class="form-group floating-label-form-group controls mb-0 pb-2">
                <label>Message</label>
                <textarea class="form-control" id="message" rows="5" placeholder="Message" required="required" data-validation-required-message="Please enter a message."></textarea>
                <p class="help-block text-danger"></p>
              </div>
            </div>
            <br>
            <div id="success"></div>
            <div class="form-group">
              <button type="submit" class="btn btn-primary btn-xl" id="sendMessageButton">Send</button>
            </div>
          </form>
        </div>
      </div>

    </div>
  </section>

  <!-- Footer -->
  <footer class="footer text-center">
    <div class="container">
      <div class="row">

        <!-- Footer Location -->
        <div class="col-lg-4 mb-5 mb-lg-0">
          <h4 class="text-uppercase mb-4">Location</h4>
          <p class="lead mb-0">Republic of Korea</p>
        </div>

        <!-- Footer Social Icons -->
        <div class="col-lg-4 mb-5 mb-lg-0">
          <h4 class="text-uppercase mb-4">Around the Web</h4>
          <a class="btn btn-outline-light btn-social mx-1" href="#">
            <i class="fab fa-fw fa-facebook-f"></i>
          </a>
          <a class="btn btn-outline-light btn-social mx-1" href="#">
            <i class="fab fa-fw fa-twitter"></i>
          </a>
          <a class="btn btn-outline-light btn-social mx-1" href="#">
            <i class="fab fa-fw fa-linkedin-in"></i>
          </a>
          <a class="btn btn-outline-light btn-social mx-1" href="#">
            <i class="fab fa-fw fa-dribbble"></i>
          </a>
        </div>

        <!-- Footer About Text -->
        <div class="col-lg-4">
          <h4 class="text-uppercase mb-4">Email</h4>
          <p class="lead mb-0">angksflvlf52@gmail.com<br/>
            <a href="mailto:angksflvlf52@gmail.com">contact me</a></p>
        </div>

      </div>
    </div>
  </footer>

  <!-- Copyright Section -->
  <section class="copyright py-4 text-center text-white">
    <div class="container">
      <small>Copyright &copy; 박영민 2020</small>
    </div>
  </section>

  <!-- Scroll to Top Button (Only visible on small and extra-small screen sizes) -->
  <div class="scroll-to-top d-lg-none position-fixed ">
    <a class="js-scroll-trigger d-block text-center text-white rounded" href="#page-top">
      <i class="fa fa-chevron-up"></i>
    </a>
  </div>


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
