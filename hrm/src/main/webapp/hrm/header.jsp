<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>인사는 내맘대로</title>
  <script src="https://kit.fontawesome.com/08035877d1.js" crossorigin="anonymous"></script>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
  <script src="/res/js/script.js"></script>
  
  
  <style>
    body {
      
      font-family: 'Helvetica', 'Arial', sans-serif;
      color: #333;
      background-color: #fff;
    }
    header {
      align: left;
      padding: 30px 100px;
      background: #fff;
      border-bottom: 1px solid #eee;
    }
	.logo {
	  display: flex;
	  align-items: center;
	  gap: 10px;
	  font-size: 1.5rem;
	  margin-bottom: 0; /* 기존 20px 제거 */
	}
    .logo img {
      width: 350px;
    }
.nav {
  display: flex;
  gap: 25px;
  position: absolute;
  right: 500px;   /* 우측에서 300px 떨어뜨림 */
  top: 12%;       /* 세로 가운데 맞춤 */
  transform: translateY(-50%); /* 세로 중앙 보정 */
}
    a{
    	color:#222;
    	text-decoration: none;
    }
    .user-menu {
    	position:absolute;
    	top:20px;
    	right:220px;
      	display: flex;
      	justify-content: flex-end;
      	gap : 10px;
      	font-size: 0.7rem;

  </style>
</head>
<body>

  <!-- 헤더 -->
  <div class="user-menu">
  	  <a href="/mypage">홈(Home)</a>
      <a href="/login">로그인</a>
      <a href="/register">로그아웃</a>
 	  <a href="/re_data">마이프로필</a>
  </div>
  <header>
    <div class="logo">
       <a href="/main"><img src="/img/hotel_logo2.jpg" alt="로고" /></a>
     <!-- <strong>내맘대로</strong> HOTEL -->
    </div>
    
    <nav class="nav">
      <a href="#">사원 관리</a>
      <a href="#">부서 관리</a>
      <a href="/list">직급 관리</a>
      <a href="/notice">근태 관리</a> 
      <a href="/qna">급여 관리</a>
      <a href="#">Location</a>
    </nav>
    
  </header>
</html>
</body>