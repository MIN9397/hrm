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
        padding: 40px;
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f9f9f9;
    }

    .content-area button {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        color: #fff;
        cursor: pointer;
        margin-right: 10px;
    }

    .content-area .checkin {
        background-color: #4CAF50;
    }

    .content-area .checkout {
        background-color: #F44336;
    }

    .content-area table {
        border-collapse: collapse;
        width: 100%;
        margin-top: 30px;
        background-color: #fff;
    }

    .content-area th,
    .content-area td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }

    .content-area th {
        background-color: #f5f5f5;
    }
    </style>
</head>
<body>
<%@include file="/hrm/side.jsp" %>
<!-- 기존의 layout 구조를 따라가야 하므로 이 안에 본문을 넣습니다 -->
<div class="layout">
    <%-- 사이드바는 side.jsp에서 렌더링됨 --%>

    <!-- 본문 컨텐츠 영역 -->
    <div class="content-area">
        <h2>근태 관리</h2>
        <p>사원명: ${username} | 사원번호: ${employeeId} | 부서번호: ${deptId}</p>

        <form action="/attendance/checkin" method="post" style="display:inline;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="checkin">출근</button>
        </form>

        <form action="/attendance/checkout" method="post" style="display:inline;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="checkout">퇴근</button>
        </form>

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
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>