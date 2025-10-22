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
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="/res/js/script.js"></script>
  
  <style>
    body {
      margin: 0;
      font-family: 'Helvetica', 'Arial', sans-serif;
      color: #333;
      background-color: #fff;
    }

    /* 상단 헤더 */
    header {
      padding: 10px 40px;
      background: #fff;
      border-bottom: 1px solid #eee;
      display: flex;
      align-items: center;
      justify-content: space-between;
      position: relative;
    }

    .logo img {
      width: 400px;
    }

    /* 상단 네비게이션 */
    .nav {
      display: flex;
      gap: 20px;
  	  position: absolute;
  	  right: 400px;   /* 우측에서 300px 떨어뜨림 */
  	  top: 70%;       /* 세로 가운데 맞춤 */
  	  transform: translateY(-50%); /* 세로 중앙 보정 */
    }
    .nav a {
      color: #222;
      text-decoration: none;
    }

    /* 우측 상단 유저메뉴 */
    .user-menu {
      position: absolute;
      top: 10px;
      right: 200px;
      font-size: 0.8rem;
      display: flex;
      gap: 10px;
    }
    .user-menu a {
      color: #444;
      text-decoration: none;
    }

    /* 레이아웃 구조 */
    .layout {
      display: flex;
    }

    /* 왼쪽 사이드바 */
	.sidebar {
	  width: 220px;
	  background-color: #fff;   /* 흰색으로 변경 */
	  min-height: calc(100vh - 70px); /* 헤더 높이 제외 */
	  padding: 20px;
	  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1); /* 오른쪽으로 살짝 그림자 */
	}
    /* 사이드바 안 메뉴 */
    .submenu {
      list-style: none;
      padding: 0;
      margin: 20px 0 0 0;
    }
    .submenu li {
      margin: 10px 0;
    }
    .submenu a {
      color: #222;
      text-decoration: none;
      font-size: 0.9rem;
    }
  </style>
</head>
<body>

  <!-- 헤더 -->
  <header>
    <div class="logo">
      <a href="/main"><img src="/img/logo.png" alt="로고" /></a>
    </div>
    <nav class="nav">
      <a href="/employee/manage" onclick="showSubmenu('person')">사원 관리</a>
      <a href="/vacation" onclick="showSubmenu('dept')">휴가 관리</a>
      <a href="/check" onclick="showSubmenu('attend')">근태 관리</a>
      <a href="#" onclick="showSubmenu('salary')">급여 관리</a>
    </nav>

    <!-- 우측 상단 메뉴 -->
    <div class="user-menu">
      <a href="/main">홈(Home)</a>
      <a href="/">로그인</a>
      <a href="/">로그아웃</a>
      <a href="/mypage">마이프로필</a>
    </div>
  </header>

  <!-- 헤더 아래 레이아웃 -->
  <div class="layout">
    <!-- 사이드바 -->
    <div class="sidebar">
      <h4>메뉴</h4>
      <ul class="submenu" id="submenu-container">
        <!-- 자바스크립트로 서브메뉴 동적 출력 -->
      </ul>
      
      <!-- 채팅 탭 (메뉴 하단 고정) -->
      <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
        <h5 style="margin-bottom: 15px; color: #333;">채팅</h5>
        <ul class="submenu">
          <li><a href="/chat/list"><i class="fas fa-comments"></i> 채팅 목록</a></li>
          <li><a href="/chat/new"><i class="fas fa-plus-circle"></i> 새 채팅</a></li>
        </ul>
      </div>

      <!-- 메일 탭 (메뉴 하단 고정) -->
      <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
        <h5 style="margin-bottom: 15px; color: #333;">메일</h5>
        <ul class="submenu">
          <li><a href="/mail/compose"><i class="fas fa-envelope"></i> 메일 보내기</a></li>
        </ul>
      </div>
    </div>



  <script>
    const submenus = {
      person: ["사원 등록", "사원 조회", "사원 수정"],
      dept: ["부서 등록", "부서 목록"],
      job: ["직급 등록", "직급 목록"],
      attend: ["출근 기록", "퇴근 기록", "근태 통계"],
      salary: ["급여 계산", "급여 지급", "세금 관리"],
      location: ["지점 안내", "지도 보기"]
    };

    function showSubmenu(menu) {
      const container = document.getElementById("submenu-container");
      container.innerHTML = "";

      if (submenus[menu]) {
        submenus[menu].forEach(item => {
          const li = document.createElement("li");
          li.innerHTML = `<a href="#">${item}</a>`;
          container.appendChild(li);
        });
      }
    }
  </script>
</body>
</html>
