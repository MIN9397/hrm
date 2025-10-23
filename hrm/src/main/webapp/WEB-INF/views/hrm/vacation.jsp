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

<c:if test="${deptId == 1}">
    <form method="get" action="/vacation" style="margin-bottom: 15px;">
        <label for="employeeId">직원 ID 검색:</label>
        <input type="number" name="employeeId" id="employeeId" value="${employeeId}" placeholder="직원 ID 입력" />
        <button type="submit">검색</button>
    </form>
</c:if>


<form method="post" action="/vacation/save">
    <!-- ✅ 일반직원은 hidden, 관리자면 입력 가능 -->
    <c:choose>
        <c:when test="${deptId == 1}">
            <label for="employeeId">직원 ID</label>
            <input type="number" name="employeeId" id="employeeId" required value="${employeeId}" />
        </c:when>
        <c:otherwise>
            <input type="hidden" name="employeeId" id="employeeId" value="${employeeId}" />
        </c:otherwise>
    </c:choose>

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

<h3 style="text-align:center;">휴가 목록</h3>

<c:choose>
    <c:when test="${not empty vacations}">
        <table>
            <thead>
                <tr>
                    <th>휴가 ID</th>
                    <th>직원 ID</th>
                    <th>휴가 종류</th>
                    <th>시작일</th>
                    <th>종료일</th>
                    <th>상태</th>
                    <th>관리</th>
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
                        <!-- ✅ 승인 상태 표시 -->
	                    <td>
	                        <c:choose>
	                            <c:when test="${v.status == '승인'}">
	                                <span style="color:green; font-weight:bold;">${v.status}</span>
	                            </c:when>
	                            <c:when test="${v.status == '반려'}">
	                                <span style="color:red; font-weight:bold;">${v.status}</span>
	                            </c:when>
	                            <c:otherwise>
	                                <span style="color:gray;">대기중</span>
	                            </c:otherwise>
	                        </c:choose>
	                    </td>
                        <td>
                            <c:if test="${deptId == 1}">
                                <!-- 관리자 승인/반려 -->
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

                            <!-- 모든 직원 삭제 가능 -->
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
    </c:when>

    
    <c:otherwise>
        <p style="text-align:center; color:gray;">등록된 휴가가 없습니다.</p>
    </c:otherwise>
</c:choose>
 </div>
    </div>
    <!-- ✅ 조회 버튼 동작 스크립트 -->

</body>
</html>
