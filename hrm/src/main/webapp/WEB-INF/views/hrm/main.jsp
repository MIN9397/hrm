<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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


.main-area {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  gap: 40px;
}

/* 왼쪽: 프로필 + 공지 */
.left-area {
  display: flex;
  flex-direction: column;
  width: 500px; /* 달력과 동일 폭 */
  gap: 20px;
}

/* 오른쪽: 달력 */
.right-area {
  width: 900px; /* 프로필 영역과 동일 폭 */
}

/* 프로필 박스 */
.profile-box {
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 0px;
  text-align: center;
  height: 440px; /* 공지보다 길게 설정 */
}

.profile-line {
  width: 470px;          /* 선의 전체 너비 */
  border: none;          /* 기본 테두리 제거 */
  border-top: 3px solid #0516f5; /* 선의 굵기와 색상 */
  margin: 13px auto;
}


.profile-img {
  width: 200px;
  height: 200px;
  border-radius: 50%;
  object-fit: cover;
  opacity: 0.9;
  margin-bottom: 25px;
  margin-top: 5px;
}


/* 표 형식 (3행 × 2열 = 6항목) */
.profile-table {
  width: 95%;
  border-collapse: collapse;
  margin: 0 auto 10px auto;
  font-size: 14px;
  margin-bottom: 25px;
}

.profile-table th {
  background-color: #f0f0f0; /* 회색 고정 컬럼 */
  text-align: left;
  padding: 6px 10px;
  width: 25%;

}

.profile-table td {
  text-align: left;
  padding: 6px 10px;
  width: 25%;
  background-color: #fafafa;
}

/* 수정 버튼 */
.edit-btn {
  margin-top: 1px;
  background-color: #007bff;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s ease;
  width: 450px; /* 버튼 너비 고정 */
  text-align: center; /* 텍스트 중앙정렬 */
}

.edit-btn:hover {
  background-color: #0056b3;
}



/* 공지사항 박스 */
.notice-box {
  background: #fff;
  border-radius: 10px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 10px;
  padding-right: 1px; /* 스크롤 여백 */
  height: 280px; /* 프로필보다 짧게 */
  overflow: hidden !important;
}

/* 공지사항 제목 영역 */
.notice-box h3 {
  background-color: #f0f0f0; /* 밝은 회색 */
  padding: 8px 12px;
  border-radius: 8px;
  margin-bottom: 10px;
  font-size: 1.2rem;
  font-weight: 600;
  
  top: 0;
  z-index: 2;
}

.notice-box h3 a {
  color: #333;
  text-decoration: none;
}

/* 공지사항 목록 */
.notice-box ul {
  list-style: none; /* 점 제거 */
  padding: 0;
  margin: 0;
  overflow-y: auto;
}

/* 공지 개별 항목 */
.notice-box li {
  background-color: rgba(253, 244, 227, 0.4); /* 베이지 + 투명도 0.4 */
  margin-bottom: 8px;
  border-radius: 6px;
  padding: 8px 12px;
  transition: background-color 0.2s ease;
  height: 32px; 
}



/* 공지 링크 스타일 */
.notice-box a {
  text-decoration: none;
  color: #333;
  display: block;
}

.notice-box a:hover {
  text-decoration: underline;
}


/* 달력 박스 */
.calendar-box {
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
  height: 740px; /* 프로필+공지 높이 합과 비슷하게 */
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

<!-- 전체 메인 컨텐츠 -->
<div class="main-content">

  <div class="main-area">
    <!-- 왼쪽 영역 (프로필 + 공지사항) -->
    <div class="left-area">
      <!-- 프로필 -->
		<div class="profile-box">
		 <hr class="profile-line"> <!-- 👈 추가된 부분 -->
		  <div class="profile-header">
		 
		    <img src="/mypage/profile-image?employeeId=${me.employeeId}&t=${imgVersion}" 
		         alt="프로필 사진" 
		         class="profile-img"
		         onerror="this.src='https://via.placeholder.com/600x400?text=Profile'">

		  </div>
		
		  <table class="profile-table">
		    <tr>
		      <th>이름</th>
		      <td>${empty me.username ? '로그인 사용자' : me.username}</td>
		      <th>사번</th>
		      <td>${me.employeeId}</td>
		    </tr>
		    <tr>
		      <th>부서</th>
		      <td>${me.deptName}</td>
		      <th>직책</th>
		      <td>${me.jobTitle}</td>
		    </tr>
		    <tr>
		      <th>생년월일</th>
		      <td>${me.birth}</td>
		      <th>연락처</th>
		      <td>${me.phone}</td>
		    </tr>
		  </table>
				
		  <button class="edit-btn" onclick="location.href='/mypage'">프로필 수정</button>
		</div>


      <!-- 공지사항 -->
      <div class="notice-box">
        <h3><a href="/notice">공지사항</a></h3>
        <ul>
          <c:choose>
            <c:when test="${not empty noticeTitles}">
              <c:forEach items="${noticeTitles}" var="title">
                <li><a href="#">${title}</a></li>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <li><span class="text-muted">공지사항이 없습니다.</span></li>
            </c:otherwise>
          </c:choose>
        </ul>
      </div>
    </div>

    <!-- 오른쪽 달력 -->
    <div class="right-area">
      <div class="calendar-box">
        <div id='calendar'></div>
      </div>
    </div>
  </div>
</div>


<script>
  // 공지사항 박스 높이에 맞춰 목록 개수 자동 조정
  function fitNoticeItems() {
    const box = document.querySelector('.notice-box');
    if (!box) return;
    const list = box.querySelector('ul');
    const header = box.querySelector('h3');
    if (!list || !header) return;

    const getNum = (v) => {
      const n = parseFloat(v);
      return isNaN(n) ? 0 : n;
    };

    const boxStyle = getComputedStyle(box);
    const headerStyle = getComputedStyle(header);

    // 박스 내부에서 리스트가 사용할 수 있는 최대 높이 계산
    const available = box.clientHeight
      - header.offsetHeight
      - getNum(headerStyle.marginBottom)
      - getNum(boxStyle.paddingTop)
      - getNum(boxStyle.paddingBottom);

    // 모든 항목을 일단 보이게 한 뒤, 넘치는 항목만 감춤
    const items = Array.from(list.children);
    items.forEach(li => li.classList.remove('d-none'));

    let used = 0;
    for (const li of items) {
      const liStyle = getComputedStyle(li);
      const h = li.offsetHeight + getNum(liStyle.marginTop) + getNum(liStyle.marginBottom);
      if (used + h <= available) {
        used += h;
      } else {
        li.classList.add('d-none');
      }
    }
  }

  function debounce(fn, wait) {
    let t;
    return function() {
      clearTimeout(t);
      t = setTimeout(() => fn.apply(this, arguments), wait);
    };
  }

  window.addEventListener('load', fitNoticeItems);
  window.addEventListener('resize', debounce(fitNoticeItems, 150));
</script>

</body>
</html>