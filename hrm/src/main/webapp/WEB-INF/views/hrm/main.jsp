<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

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
  padding: 20px;
  color: inherit;
  display: block;
}

.profile-box .profile-img {
  width: 200px;
  height: 200px;
  border-radius: 50%;
  object-fit: cover;
  display: block;
  margin: 0 auto 14px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.15);
}

.profile-box .profile-info {
  background: transparent;
  padding: 0;
  border-radius: 0;
}

.profile-box .profile-info h3,
.profile-box .profile-info p {
  margin: 0;
  color: #222;
  text-shadow: none;
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
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
}



</style>
<script>

      document.addEventListener('DOMContentLoaded', function() {
        let calendarEl = document.getElementById('calendar');

        let headerToolbar = {
          left: 'prevYear,prev,next,nextYear today',
          center: 'title',
          right: 'dayGridMonth,listWeek'
        };

        // 서버 저장/삭제 헬퍼 함수
        function saveEventToServer(ev) {
          const no = ev.extendedProps?.no || ev.id;
          const payload = {
            no: no,
            title: ev.title,
            start: ev.startStr,
            end: ev.endStr || ev.startStr,
            allDayStatus: ev.allDay ? 'TRUE' : 'FALSE',
            backgroundColor: ev.backgroundColor || ev.backgroundColor,
            textColor: ev.textColor || ev.textColor
          };

          const token = document.querySelector('meta[name="_csrf"]').getAttribute('content');
          const header = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

          return fetch("/scheduleUpdate.do", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              [header]: token
            },
            body: JSON.stringify(payload)
          }).then(res => {
            if (!res.ok) throw new Error("update failed");
            return true;
          });
        }

        function deleteEventFromServer(no) {
          const token = document.querySelector('meta[name="_csrf"]').getAttribute('content');
          const header = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

          return fetch("/scheduleDelete.do", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              [header]: token
            },
            body: JSON.stringify({ no })
          }).then(res => {
            if (!res.ok) throw new Error("delete failed");
            return true;
          });
        }

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
          selectMirror: true, // 선택 시 미리보기 표시
          slotEventOverlap: true,
          eventOverlap: true,


          //일정 목록 불러오기
          events: "/scheduleList.do",

          //날짜 클릭 시 (등록) - Month 뷰에서 사용
          dateClick: function(info) {
            let title = prompt("일정 제목을 입력하세요:");
            if (title) {
              let eventData = {
                title: title,
                start: info.dateStr,
                end: info.dateStr,
                allDayStatus: 'TRUE' // 하루종일 일정
              };

              // CSRF 토큰 읽어오기
              const token = document.querySelector('meta[name="_csrf"]').getAttribute('content');
              const header = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

              fetch("/scheduleInsert.do", {
                  method: "POST",
                  headers: {
                      "Content-Type": "application/json",
                      [header]: token  // 헤더에 CSRF 토큰 추가
                  },
                  body: JSON.stringify(eventData)
              })
              .then(res => {
                  if (res.ok) {
                      alert("일정이 등록되었습니다!");
                      calendar.refetchEvents();
                  } else {
                      alert("등록 실패!");
                  }
              });
            }
          },

          // 일정 클릭 시 (수정/삭제)
          eventClick: function(info) {
            const no = info.event.extendedProps?.no || info.event.id;
            if (!no) {
              alert("일정 식별자(no)를 찾을 수 없습니다.");
              return;
            }

            if (confirm("이 일정을 삭제하시겠습니까?")) {
              deleteEventFromServer(no)
                .then(() => {
                  alert("삭제되었습니다.");
                  calendar.refetchEvents();
                })
                .catch(() => alert("삭제 실패!"));
              return;
            }

            const newTitle = prompt("새 제목을 입력하세요.", info.event.title);
            if (newTitle && newTitle.trim() !== '' && newTitle !== info.event.title) {
              info.event.setProp('title', newTitle.trim());
              saveEventToServer(info.event)
                .then(() => {
                  alert("수정되었습니다.");
                  calendar.refetchEvents();
                })
                .catch(() => {
                  alert("수정 실패!");
                });
            }
          },

          // 드래그로 날짜 이동 시 (수정)
          eventDrop: function(info) {
            saveEventToServer(info.event)
              .then(() => {
                calendar.refetchEvents();
              })
              .catch(() => {
                alert("수정 실패!");
                info.revert();
              });
          },

          // 리사이즈로 종료일 변경 시 (수정)
          eventResize: function(info) {
            saveEventToServer(info.event)
              .then(() => {
                calendar.refetchEvents();
              })
              .catch(() => {
                alert("수정 실패!");
                info.revert();
              });
          }


        });
        calendar.render();
        });
</script>


</head>
<body>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

<%@include file="/hrm/side.jsp" %>

<div class="main-content">
  <!-- 상단 3박스 -->
  <div class="top-boxes">
    <!-- 개인 요약 프로필 -->
    <div class="box profile-box" onclick="location.href='/mypage'">
      <img src="/mypage/profile-image?employeeId=${me.employeeId}&t=${imgVersion}" alt="프로필 사진" class="profile-img" onerror="this.src='https://via.placeholder.com/600x400?text=Profile'">
      <div class="profile-info">
        <h3>${empty me.username ? '로그인 사용자' : me.username}</h3>
        <p>사번: ${me.employeeId}</p>
      </div>
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
  <!-- calender + chat -->
  <div class="calendar-chat-boxes">
    <div class="calendar-panel">
      <div id='calendar'></div>
  </div>
</div>


</body>
</html>