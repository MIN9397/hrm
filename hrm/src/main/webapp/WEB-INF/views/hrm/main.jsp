<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

.main-content {
  padding: 20px;
}

/* 상단 3박스 */
.top-boxes {
  display: flex;
  justify-content: space-between;
  gap: 20px;   /* 가로·세로 간격 */
  margin-bottom: 30px;
}

.top-boxes .box {
  width: 500px;
  height: 400px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
  box-sizing: border-box;
  overflow: hidden;
}

.profile-box {
  text-align: center;
  cursor: pointer;
}

.profile-box .profile-img {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  margin-bottom: 15px;
}

/* 리스트 스타일 */
.notice-box ul,
.inquiry-box ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.notice-box li,
.inquiry-box li {
  margin-bottom: 10px;
}

.notice-box a,
.inquiry-box a {
  text-decoration: none;
  color: #333;
}

.notice-box a:hover,
.inquiry-box a:hover {
  text-decoration: underline;
}

/* 하단 영역 */
.bottom-boxes {
  display: flex;
  gap: 20px;   /* 가로·세로 간격 */
  gap: 20px;
}

.graph-area {
  flex: 4; /* 40% */
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
}

.status-area {
  flex: 6; /* 60% */
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
}




</style>



</head>
<body>

<%@include file="/hrm/side.jsp" %>

<div class="main-content">
  <!-- 상단 3박스 -->
  <div class="top-boxes">
    <!-- 개인 요약 프로필 -->
    <div class="box profile-box" onclick="location.href='/profile/detail'">
      <img src="/images/profile.png" alt="프로필 사진" class="profile-img">
      <h3>홍길동</h3>
      <p>사번: 123456</p>
    </div>

    <!-- 공지사항 -->
    <div class="box notice-box">
      <h3>공지사항</h3>
      <ul>
        <li><a href="#">공지사항 제목 1</a></li>
        <li><a href="#">공지사항 제목 2</a></li>
        <li><a href="#">공지사항 제목 3</a></li>
        <li><a href="#">공지사항 제목 4</a></li>
        <li><a href="#">공지사항 제목 5</a></li>
      </ul>
    </div>

    <!-- 문의사항 -->
    <div class="box inquiry-box">
      <h3>문의사항</h3>
      <ul>
        <li><a href="#">문의 제목 1</a></li>
        <li><a href="#">문의 제목 2</a></li>
        <li><a href="#">문의 제목 3</a></li>
        <li><a href="#">문의 제목 4</a></li>
        <li><a href="#">문의 제목 5</a></li>
      </ul>
    </div>
  </div>

  <!-- 하단 그래프 + 현황판 -->
  <div class="bottom-boxes">
    <div class="graph-area">
      <!-- 그래프 들어갈 자리 -->
      <canvas id="chart"></canvas>
    </div>
    <div class="status-area">
      <h3>출근 현황</h3>
      <ul>
        <li>홍길동 - 출근</li>
        <li>김철수 - 지각</li>
        <li>이영희 - 결근</li>
        <!-- etc -->
      </ul>
    </div>
  </div>
</div>


</body>
</html>