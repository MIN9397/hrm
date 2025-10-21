<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>휴가 등록</title>
    <link rel="stylesheet" href="/hrm/css/attendance/vacation.css">
</head>
<body>
<%@include file="/hrm/side.jsp" %>
<div class="layout">
        <div class="content">
<h2>휴가 등록</h2>

<form method="post" action="/vacation/save">
    <label for="employeeId">직원 ID</label>
    <input type="number" name="employeeId" id="employeeId" required value="${employeeId}" <c:if test="${deptId != 1}">readonly</c:if>/>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	
    <label for="leaveType">휴가 종류</label>
    <select name="leaveType" id="leaveType" required>
        <option value="">-- 선택하세요 --</option>
        <option value="연차">연차</option>
        <option value="병가">병가</option>
        <option value="반차">반차</option>
        <option value="출장">출장</option>
    </select>

    <label for="startDate">시작일</label>
    <input type="date" name="startDate" id="startDate" required/>

    <label for="endDate">종료일</label>
    <input type="date" name="endDate" id="endDate" required/>

    <button type="submit">휴가 등록</button>
</form>
	<div style="margin-top:10px;">
     <button type="button" onclick="viewVacationList()">휴가 목록 보기</button>
	</div>
	
	<script>
function viewVacationList() {
    const empId = document.getElementById('employeeId').value;
    if (!empId) {
        alert("직원 ID를 입력하세요!");
        return;
    }
    window.location.href = '/vacation/list?employeeId=' + empId;
}

</script>
	
<c:if test="${not empty vacations}">
    <h3 style="text-align:center;">휴가 목록</h3>
    <table>
        <thead>
            <tr>
                <th>휴가 ID</th>
                <th>직원 ID</th>
                <th>휴가 종류</th>
                <th>시작일</th>
                <th>종료일</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="v" items="${vacations}">
<tr>
    <td>${v.leaveId}</td>
    <td>${v.employeeId}</td>
    <td>${v.leaveType}</td>
    <td>${v.startDate}</td>
    <td>${v.endDate}</td>
    <td>${v.status}</td>
    <td>
        <c:if test="${deptId == 1}">
            <!-- ✅ 관리자만 승인/반려 버튼 -->
            <form action="/vacation/approve" method="post" style="display:inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="leaveId" value="${v.leaveId}" />
                <button type="submit">승인</button>
            </form>
            <form action="/vacation/reject" method="post" style="display:inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="leaveId" value="${v.leaveId}" />
                <button type="submit">반려</button>
            </form>
        </c:if>

        <!-- ✅ 모든 직원이 사용할 수 있는 삭제 버튼 -->
        <form method="post" action="/vacation/delete" style="display:inline;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="leaveId" value="${v.leaveId}" />
            <button type="submit" onclick="return confirm('삭제하시겠습니까?');">삭제</button>
        </form>
    </td>
</tr>
</c:forEach>

        </tbody>
    </table>
</c:if>
 </div>
    </div>
    <!-- ✅ 조회 버튼 동작 스크립트 -->

</body>
</html>
