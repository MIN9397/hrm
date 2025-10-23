<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>근태 관리</title>
<style>
.content-area {
    flex: 1;
    padding: 50px 60px;
    font-family: 'Noto Sans KR', sans-serif;
    background-color: #ffffff;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    border-radius: 12px;
    width: 1500px;
    margin: 40px auto;
    color: #2c3e50;
}

/* 각 열 간격 좁히기 */
.content-area thead th:nth-child(1) { width: 23%; }  /* 근무일 */
.content-area thead th:nth-child(2) { width: 23%; }  /* 출근시간 */
.content-area thead th:nth-child(3) { width: 23%; }  /* 퇴근시간 */
.content-area thead th:nth-child(4) { width: 31%; }  /* 관리자 수정 */


.content-area h2 {
    font-size: 2.2rem;
    margin-bottom: 15px;
    text-align: center;
    color: #34495e;
}

.content-area p {
    font-size: 1rem;
    text-align: center;
    margin-bottom: 30px;
    color: #7f8c8d;
}

.content-area form {
    margin-bottom: 20px;
    display: flex !important;
    justify-content: center;
    gap: 15px;
    flex-wrap: wrap;
    align-items: center;
}

.content-area form label {
    font-weight: 600;
    font-size: 1rem;
}

.content-area form input[type="number"] {
    padding: 8px 12px;
    border-radius: 8px;
    border: 1.5px solid #ccc;
    font-size: 1rem;
    width: 180px;
    transition: border-color 0.3s ease;
}

.content-area form input[type="number"]:focus {
    border-color: #3498db;
    outline: none;
}

.button-container {
  display: flex;
  justify-content: center;
  gap: 15px;
  flex-wrap: nowrap;
  margin-bottom: 20px;
}

.content-area button.checkin,
.content-area button.checkout {
  width: 160px;
  font-size: 1.2rem;
  border-radius: 8px;
  border: none;
  font-weight: 700;
  cursor: pointer;
  color: white;
  padding: 10px 24px;
  text-align: center;
  transition: background-color 0.3s ease;
}

.content-area button.checkin {
  background-color: #27ae60;
}

.content-area button.checkin:hover {
  background-color: #219150;
}

.content-area button.checkout {
  background-color: #e74c3c;
}

.content-area button.checkout:hover {
  background-color: #c0392b;
}


/* 버튼 텍스트 중앙 정렬 */
.content-area button.checkin,
.content-area button.checkout {
    text-align: center;
}

.content-area h3 {
    font-size: 1.8rem;
    margin-top: 40px;
    margin-bottom: 20px;
    color: #34495e;
    text-align: center;
}

.content-area table {
    border-collapse: separate;
    border-spacing: 0 10px;
    width: 100%;
    background-color: transparent;
}

.content-area thead tr {
    background-color: #3498db;
    color: white;
    border-radius: 12px;
    font-weight: 700;
}

.content-area thead th {
    padding: 12px 15px;
    text-align: center;
}

.content-area tbody tr {
    background-color: #fefefe;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.content-area tbody td {
    padding: 15px 12px;
    text-align: center;
    font-size: 1rem;
    vertical-align: middle;
}

.content-area tbody tr td:last-child {
    width: 200px;
}

/* 관리자 수정 form 스타일 */
.content-area tbody form {
    display: flex;
    justify-content: center;
    gap: 10px;
    align-items: center;
}

.content-area tbody input[type="time"] {
    border-radius: 6px;
    border: 1.5px solid #ccc;
    padding: 5px 8px;
    font-size: 1rem;
    width: 90px;
    transition: border-color 0.3s ease;
}

.content-area tbody input[type="time"]:focus {
    border-color: #3498db;
    outline: none;
}

.content-area tbody button {
    padding: 6px 14px;
    background-color: #2980b9;
    border-radius: 6px;
    font-weight: 600;
    color: white;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.content-area tbody button:hover {
    background-color: #1c5980;
}

/* 반응형 */
@media (max-width: 700px) {
    .content-area {
        padding: 20px 25px;
        margin: 20px 15px;
    }

    .content-area form {
        flex-direction: column;
        gap: 10px;
    }

    .content-area form input[type="number"] {
        width: 100%;
    }

    .content-area tbody form {
        flex-direction: column;
        gap: 8px;
    }

    .content-area tbody input[type="time"] {
        width: 100%;
    }
}

.layout1 {
  display: flex;
  gap: 0px; /* 사이드바와 본문 사이 공간 */
  padding: 0px;
  max-width: 1500px; /* 원하는 최대 폭 */
  margin: 0 auto; /* 화면 중앙 정렬 */
  box-sizing: border-box;
}



</style>
</head>
<body>
<%@include file="/hrm/side.jsp" %>
<!-- 기존의 layout 구조를 따라가야 하므로 이 안에 본문을 넣습니다 -->
<div class="layout1">
    <%-- 사이드바는 side.jsp에서 렌더링됨 --%>

    <!-- 본문 컨텐츠 영역 -->
    <div class="content-area">
        <h2>근태 관리❤️</h2>
        <p>사원명: ${username} | 사원번호: ${employeeId} | 부서번호: ${deptId}</p>
		<c:if test="${deptId == 1}">
		<div class="button-group">
            <form method="get" action="/check" style="margin-bottom: 10px;">
                <label>직원 ID 검색:</label>
                <input type="number" name="employeeId" placeholder="직원 ID 입력" value="${employeeId}">
                <button type="submit">검색</button>
            </form>
        </div>
        </c:if>
			
			<c:if test="${deptId != 1}">	
			  <div class="button-container">
			    <form action="/attendance/checkin" method="post">
			      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			      <button type="submit" class="checkin">출근</button>
			    </form>
			
			    <form action="/attendance/checkout" method="post">
			      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			      <button type="submit" class="checkout">퇴근</button>
			    </form>
			  </div>
			</c:if>

        <h3>출퇴근 기록</h3>
        <table>
            <thead>
                <tr>
                    <th>근무일</th>
                    <th>출근시간</th>
                    <th>퇴근시간</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="a" items="${attendanceList}">
                    <tr>
                        <td>${a.workDate}</td>
                        <td>${a.checkInTime}</td>
                        <td>${a.checkOutTime}</td>
                        <td>
                            <!-- ✅ 관리자만 수정 가능 -->
							<c:if test="${deptId == 1}">
							    <form action="/attendance/update" method="post" style="display:inline;">
							        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
							        <input type="hidden" name="attendanceId" value="${a.attendanceId}" />
							
							        <div class="time-edit-box">
							            <input type="time" name="checkInTime" value="${a.checkInTime}" required />
							            <input type="time" name="checkOutTime" value="${a.checkOutTime}" />
							        </div>
							
							        <button type="submit" class="save-btn">저장</button>
							    </form>
							</c:if>

                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>