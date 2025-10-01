<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>내맘대로 RM</title>
  <style>
    body {
      margin: 0;
      display: flex;
      min-height: 100vh;
      font-family: Arial, sans-serif;
    }

    /* 왼쪽 노란색 영역 (푸터/사이드바) */
    .sidebar {
      width: 220px;
      background-color: #ffc600; /* 노란색 */
      padding: 20px;
    }

    /* 메인 콘텐츠 영역 */
    .content {
      flex: 1;
      padding: 20px;
    }

    /* 서브메뉴 */
    .submenu {
      list-style: none;
      padding: 0;
      margin: 0;
      display: none; /* 처음에는 숨김 */
    }
    .submenu li {
      margin: 10px 0;
    }
    .submenu.active {
      display: block; /* 활성화 시 노출 */
    }

    /* 상단 메인 메뉴 */
    .topmenu {
      display: flex;
      gap: 20px;
      padding: 10px 20px;
      background: #fff;
      border-bottom: 1px solid #ddd;
    }
    .topmenu a {
      cursor: pointer;
      text-decoration: none;
      color: #333;
    }
  </style>
</head>
<body>
  <!-- 왼쪽 사이드/푸터 영역 -->
  <div class="sidebar">
    <ul id="submenu-container">
      <!-- 자바스크립트로 서브메뉴가 여기에 표시됨 -->
    </ul>
  </div>

  <!-- 메인 콘텐츠 -->
  <div class="content">
    <!-- 상단 메뉴 -->
    <nav class="topmenu">
      <a onclick="showSubmenu('person')">사원 관리</a>
      <a onclick="showSubmenu('dept')">부서 관리</a>
      <a onclick="showSubmenu('job')">직급 관리</a>
      <a onclick="showSubmenu('attend')">근태 관리</a>
      <a onclick="showSubmenu('salary')">급여 관리</a>
      <a onclick="showSubmenu('location')">Location</a>
    </nav>

    <h1>메인 화면</h1>
    <p>여기는 메인 컨텐츠가 표시되는 영역입니다.</p>
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
      container.innerHTML = ""; // 초기화

      if (submenus[menu]) {
        submenus[menu].forEach(item => {
          const li = document.createElement("li");
          li.textContent = item;
          container.appendChild(li);
        });
      }
    }
  </script>
</body>
</html>
