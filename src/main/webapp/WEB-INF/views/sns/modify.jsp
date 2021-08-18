<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="Free Website Template" name="keywords">
<meta content="Free Website Template" name="description">
<!-- Favicon -->
<link href="img/favicon.ico" rel="icon">
<!-- Google Font -->
<link
	href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;600;700;800&display=swap"
	rel="stylesheet">
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css"
	rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gugi&display=swap"
	rel="stylesheet">

<!-- Template Stylesheet -->
<link href="/css/style.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<link
	href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<!------ Include the above in your HEAD tag ---------->
<link rel="stylesheet"
	href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css"
	integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p"
	crossorigin="anonymous" />

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
	integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
	crossorigin="anonymous"></script>

<script src="/js/main.js"></script>


<style>
.navbar {
	position: absolute;
	top: 8%;
}

#SnSbody {
	position: absolute;
	top: 20%;
	margin-left: 4%;
}

#titlename {
	margin-top: 1%;
	margin-bottom: 0;
	font-size: 30px;
	font-family: 'Gugi', cursive;
	color: white;
}

img {
	width: 100%;
}

#search {
	width: 500px;
	position: relative;
}

.Explanation {
	position: relative;
	top: 30%;
}

style>body {
	background-color: #eeeeee;
}

.h7 {
	font-size: 0.8rem;
}

.gedf-wrapper {
	margin-top: 0.97rem;
}

@media ( min-width : 992px) {
	.gedf-main {
		padding-left: 4rem;
		padding-right: 4rem;
	}
	.gedf-card {
		margin-bottom: 2.77rem;
	}
}
/**Reset Bootstrap*/
.dropdown-toggle::after {
	content: none;
	display: none;
}

#commenticon, #top, #love, #modicomm {
	cursor: pointer;
}

#commenticon {
	color: #AA96DA;
}

#del, #modi, #delcomm, #modicomm {
	font-size: 3px;
}

#top {
	position: fixed;
	bottom: 5%;
	right: 16%;
	width: 35px;
	display: none;
	font-size: 50px;
}

#photo {
	max-width: 300px;
	max-height: 400px;
}
</style>
<script>
	$(function() {

		//무한스크롤
		var count = 1;
		var isScroll = true;
		let loadNewPage = $(window).on("scroll",(function() {
			if (((window.innerHeight + window.scrollY) >= document.body.offsetHeight)&& isScroll) {
				$.ajax({
					url : "/sns/page",
					type : "get",
					data : {"count" : count++},
					dataType : "json"
				}).done(function(e) {
						//console.log(e);
					})
			}
		}));

		//파일명출력
		$('#file').change(function() {
			var files = $('input[name="file"]')[0].files;

			for (var i = 0; i < files.length; i++) {
				let name = files[i].name

				let delDiv = $("<div>");
				let delBtn = $("<button>");
				delBtn.addClass("delfile");
				delBtn.text("-")
				delDiv.append(delBtn);

				let rowDiv = $("<div>");
				rowDiv.addClass("row");

				rowDiv.append(name);
				rowDiv.append(delDiv);

				let br = $("<br>");

				$("#upload").append(rowDiv);
				$("#upload").append(br);
			}

		});
		
		
		$("#images-tab").on('click',function(){
			console.log($(this).siblings("#hiddenfile").val())
			$.ajax({
				url : "/sns/modifyfile",
				data : {"parent":$(this).siblings("#hiddenfile").val()},
				type : "POST",
				dataType:"JSON"
			}).done(function(resp){
				for(var i = 0; i < resp.length; i++){
					let oriName = resp[i].oriName

					let delDiv = $("<div>");
					let delBtn = $("<button>");
					delBtn.addClass("delfile");
					delBtn.text("-")
					let input = $("<input type=hidden>");
					input.addClass("fileseq");
					input.text(resp[i].seq);
					delDiv.append(delBtn);
					delDiv.append(input);

					let rowDiv = $("<div>");
					rowDiv.addClass("row");

					rowDiv.append(oriName);
					rowDiv.append(delDiv);

					let br = $("<br>");

					$("#fileList").append(rowDiv);
					$("#fileList").append(br);
					
				}
			})
		})

		//출력한 파일 삭제
		document.getElementById
		$("#upload").on("click", ".delfile", function() { //동적바인딩
			$(this).closest(".row").remove();
		})
		
		//기존파일삭제
		$(document).on("click",".delfile",function(){
			var con_test = confirm("사진을 삭제하시겠습니까?");
			if(con_test == true){
				$.ajax({
					url : "/sns/delfile",
					type : "POST",
					data : {"seq" :$(this).siblings(".fileseq").text()}					
				}).done(function(resp){
					if(resp == 1){
						alert('파일삭제완료')
						$(this).empty();
					}
				})
			}
			else{
			  return false;
			}
		})

		//댓글버튼눌렀을때
		$(document).on("click","#commenticon",function(){
			let hidden_comment = $(this).parent().siblings("#hiddencomment");
			if($(this).parent().siblings("#hiddencomment").css("display")=="none"){
				$(this).parent().siblings("#hiddencomment").show();
				$.ajax({
					url : "/snscomm/replyList",
					type : "POST",
					data : {"parentSeq":$(this).parent().siblings("#hiddencomment").children(".input-group").children("#hidden").val()},
					dataType:"JSON",
				}).done(function(resp){ 
					//댓글뿌리기
					for(var i = 0; i < resp.length; i++){
						
						let ul = $("<ul>")
						ul.attr("class","comment-list");
						ul.attr("id", "commentList");
						
						let body_div = $("<div>");
						body_div.attr("class","comment-body");
						
						let comment_head = $("<div>");
						comment_head.attr("class","comment-heading");
						
						let comment_writer = $("<h6>");
						comment_writer.text(resp[i].id);
						
						let delete_tag = $("<a>");
						delete_tag.attr("href","/snscomm/delete?seq="+resp[i].seq);
						delete_tag.attr("id","delcomm");
						delete_tag.text("삭제");
						
						let modify_tag = $("<a>");
						modify_tag.attr("href","#");
						modify_tag.attr("id","modicomm");
						modify_tag.text("수정");
											
						let input = $("<input type=hidden id=commentseq>");
						input.text(resp[i].seq);
						
						let comment = $("<div>");
						comment.attr("id","comment");
						comment.text(resp[i].contents);
						
						if(resp[i].id == $("#session").val()){
							comment_writer.append(delete_tag);
							comment_writer.append(modify_tag);
						}
						
						comment_head.append(comment_writer);
						comment_head.append(input);
												
						body_div.append(comment_head);
						body_div.append(comment);						
												
						ul.append(body_div);						
						$(hidden_comment).append(ul);						
					}					
				})
			}else{
				$(this).parent().siblings("#hiddencomment").hide();
				let delete_ul = $(hidden_comment).children(".comment-list");
				for(let i =0; i<delete_ul.length; i++){
					$(delete_ul[i]).remove();
				}				
			}
		})
		//화면올리기
		$(window).scroll(function() {
			if ($(this).scrollTop() > 200) {
				$('#top').fadeIn();
			} else {
				$('#top').fadeOut();
			}
		});
		$('#top').click(function() {
			$('html, body').animate({
				scrollTop : 0
			}, 400);
			return false;
		});

		$("#search").keyup(
				function(e) {
					if (e.keyCode == 13) {
						location.href = "/AllBoardList/allList?search=" + $("#search").val();
					}
				})

		$("#chat").on("click", function() {
			location.href = "/chat";
		})

	})
</script>
</head>
<body>

	<!-- Top Bar Start -->
	<div class="top-bar d-none d-md-block">
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-6">
					<div class="top-bar-left">
						<div class="text">
							<h2>AM 9:00 - PM 7:00</h2>
						</div>
						<div class="text">
							<h2>02 123 4567</h2>
							<p>고객 센터</p>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="top-bar-right">
						<div class="social">
							<a href="/sns/main"><i class="fab fa-twitter"></i></a> <a
								href="/sns/main"><i class="fab fa-facebook-f"></i></a> <a
								href="/sns/main"><i class="fab fa-instagram"></i></a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Top Bar End -->

	<!-- Nav Bar Start -->
	<div class="navbar navbar-expand-lg bg-dark navbar-dark">
		<div class="container-fluid">
			<a href="/" class="navbar-brand"><p id=titlename>돈-다</a>
			</p>
			<button type="button" class="navbar-toggler" data-toggle="collapse"
				data-target="#navbarCollapse">
				<span class="navbar-toggler-icon"></span>
			</button>
			<c:choose>
				<c:when test="${loginID == null }">
					<div class="collapse navbar-collapse justify-content-between"
						id="navbarCollapse">
						<div class="navbar-nav ml-auto">
							<input class="form-control mr-sm-5" type="search"
								placeholder="물품, 지역을 검색해주세요." id=search aria-label="Search">
							<a href="/person/login" class="nav-item nav-link active">Login</a>
							<!-- Login Page 이동 -->
							<a href="/person/join" class="nav-item nav-link">Sign Up</a>
							<!-- SignUp Page 이동 -->
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="collapse navbar-collapse justify-content-between"
						id="navbarCollapse">
						<div class="navbar-nav ml-auto">
							<input class="form-control mr-sm-5" type="search"
								placeholder="물품, 지역을 검색해주세요." id=search aria-label="Search">
							<a href="/person/logout" class="nav-item nav-link active">Logout</a>
							<!-- Logout -->
							<div class="collapse navbar-collapse" id="navbarNavDropdown">
								<ul class="navbar-nav">
									<li class="nav-item dropdown"><a
										class="nav-link dropdown-toggle" href="#"
										id="navbarDropdownMenuLink" role="button"
										data-toggle="dropdown" aria-haspopup="true"
										aria-expanded="false"> Menu </a>
										<div class="dropdown-menu"
											aria-labelledby="navbarDropdownMenuLink">
											<a class="dropdown-item" href="#">Board</a> <a
												class="dropdown-item" href="/sns/main">SNS</a> <a
												class="dropdown-item" href="#">My page</a> <a
												class="dropdown-item" href="#">Charging</a>
										</div></li>
								</ul>
								<button type="button" class="btn btn-outline-warning" id="chat">Chatting</button>
							</div>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	<!-- Nav Bar End -->


	<div class="container-fluid gedf-wrapper" id=SnSbody>
		<div class="row">
			<div class="col-md-3"></div>
			<div class="col-md-6 gedf-main">

				<!--- 글쓰기-->
				<form action="/sns/modiProc" method=post
					enctype="multipart/form-data">
					<div class="card gedf-card">
						<div class="card-header">
							<ul class="nav nav-tabs card-header-tabs" id="myTab"
								role="tablist">
								<li class="nav-item"><a class="nav-link active"
									id="posts-tab" data-toggle="tab" href="#posts" role="tab"
									aria-controls="posts" aria-selected="true">글 작성</a></li>
								<li class="nav-item"><a class="nav-link" id="images-tab"
									data-toggle="tab" role="tab" aria-controls="images"
									aria-selected="false" href="#images">사진첨부</a>
									<input type="hidden" name="seq" id=hiddenfile value="${seq }"></li>
								
							</ul>
						</div>
						<div class="card-body">
							<div class="tab-content" id="myTabContent">
								<div class="tab-pane fade show active" id="posts"
									role="tabpanel" aria-labelledby="posts-tab">
									<div class="form-group">
										<label class="sr-only" for="contents">post</label>
										<textarea class="form-control" id="contents" name="contents"
											rows="3">${contents }</textarea>
									</div>
								</div>
								<div class="tab-pane fade" id="images" role="tabpanel"
									aria-labelledby="images-tab">
									<div class="form-group">
										<div class="custom-file">
											<input type=file name=file id=file accept=".gif, .jpg, .png" multiple>
											<div id=fileList></div>
											<div id=upload></div>
										</div>
									</div>
									<div class="py-4"></div>
								</div>
							</div>
							<div class="btn-toolbar justify-content-between">
								<div class="btn-group">
									<button type="submit" class="btn btn-success">수정하기</button>
									<a href=/sns/main><button type="button" id=warning
											class="btn btn-warning">취소하기</button></a>
								</div>
								<!-- 카테고리 -->
								<div class="btn-group">
									<select name=category>
										<option>우리동네질문</option>
										<option>동네홍보</option>
										<option>기타</option>
									</select>
								</div>
							</div>
						</div>
					</div>
				</form>

				<!--- 게시글-->
				<c:forEach var="item" items="${list}">
					<div class="card gedf-card">
						<div class="card-header">
							<div class="d-flex justify-content-between align-items-center">
								<div class="d-flex justify-content-between align-items-center">
									<div class="mr-2">
										<img class="rounded-circle" width="45"
											src="https://picsum.photos/50/50" alt="">
									</div>
									<div class="ml-2">
										<div class="h5 m-0">
											${item.id} <input type=hidden id=hiddenseq value=${item.seq }>
											<c:choose>
												<c:when test="${loginID == item.id }">
													<a
														href="${pageContext.request.contextPath}/sns/delete?seq=${item.seq }"
														id=del>삭제</a>
													<a
														href="${pageContext.request.contextPath}/sns/modify?seq=${item.seq }"
														id=modi>수정</a>
												</c:when>
											</c:choose>
										</div>
										<div class="h7 text-muted">${item.region}</div>
									</div>
								</div>
								<div></div>
							</div>
						</div>
						<div class="card-body">
							<div class="text-muted h7 mb-2">
								<i class="fa fa-clock-o"></i>${item.category }
							</div>
							<c:forEach var="file" items="${file}">
								<c:choose>
									<c:when test="${file.parent == item.seq }">
										<a
											href="/sns/download?oriName=${file.oriName}&sysName=${file.sysName}">
											<img src="data:image/png;base64,${file.sysName}" id=photo>
										</a>
									</c:when>
								</c:choose>

							</c:forEach>
							<p class="card-text">${item.contents }</p>
						</div>
						<div class="card-footer">
							<c:choose>
								<c:when test="${isLove.indexOf(String.valueOf(item.seq)) != -1}">
									<a class="card-link" id=love style="color: #FF6B6B"><i
										class="fas fa-heart"></i>${item.love }</a>
								</c:when>
								<c:otherwise>
									<a class="card-link" id=love style="color: #FDD2BF"><i
										class="far fa-heart"></i>${item.love }</a>
								</c:otherwise>
							</c:choose>

							<a class="card-link" id=commenticon><i
								class="fas fa-comment-dots"></i>Comment</a>
						</div>
					</div>
				</c:forEach>
			</div>
			<div class="col-md-3">
				<i class="fas fa-arrow-up" id=top></i>
			</div>
		</div>
	</div>
	</div>
	<input type=hidden id=session value=${loginID }>
</body>
</html>