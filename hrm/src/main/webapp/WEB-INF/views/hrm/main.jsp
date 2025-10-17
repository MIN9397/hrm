<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet' />
<link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css' rel='stylesheet' />
<link href='https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.13.1/css/all.css' rel='stylesheet'>
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/main.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/bootstrap5@6.1.19/index.global.min.js'></script>
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
.calendar {
padding: 20px;
flex: 6; /* 60% */
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);}



</style>
<script>

      document.addEventListener('DOMContentLoaded', function() {
        let calendarEl = document.getElementById('calendar');

        let headerToolbar = {
          left: 'prevYear,prev,next,nextYear today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
        };

        let calendar = new FullCalendar.Calendar(calendarEl, {
          initialView: 'dayGridMonth',
          themeSystem: 'bootstrap5',
          locale: 'ko',
          timezone: 'local',
          headerToolbar: headerToolbar,
          editable: true,
          dayMaxEvents: true,
          nowIndicator: true,
          selectable: true,
          unselectAuto: true,

          //일정 목록 불러오기
          events: "/scheduleList.do",

          //날짜 클릭 시
          dateClick: function(info) {
            let title = prompt("일정 제목을 입력하세요:");
            if (title) {
              let eventData = {
                title: title,
                start: info.dateStr,
                end: info.dateStr,
                allDayStatus: 'TRUE' // 하루종일 일정
              };

              fetch("/scheduleInsert.do", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(eventData)
              })
              .then(res => {
                if (res.ok) {
                  alert("일정이 등록되었습니다!");
                  calendar.refetchEvents(); // 새로고침 없이 일정 갱신
                } else {
                  alert("등록 실패!");
                }
              });
            }
          }


        });
        calendar.render();
        });
</script>


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
  <!-- calender -->
  <div class="calendar">
  <div id='calendar'></div>
  </div>
</div>


</body>
</html>