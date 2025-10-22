<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

<style>
:root {
  /* 사이드바 기본 폭. side.jsp에서 다른 값을 쓰면 동일 변수로 덮어쓸 수 있습니다. */
  --sidebar-width: 250px;
}
html, body {
  width: 100%;
  height: 100%;
}
body {
  overflow-x: hidden;
}
.main-content {
  width: calc(100% - var(--sidebar-width));
}
@media (max-width: 992px) {
  .main-content {
    margin-left: 0;
    width: 100%;
  }
}
.clickable-row { cursor: pointer; }
.clickable-row:hover { background-color: rgba(0, 0, 0, 0.03); }
</style>
</head>
<body class="bg-light">
<%@include file="/hrm/side.jsp" %>
<div class="main-content p-0">
<div class="container-fluid px-0 py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="mb-0"><i class="bi bi-people-fill me-2"></i>사원 관리</h3>
    <sec:authorize access="principal.role_id == '2'">
      <a href="/employee/register" class="btn btn-primary">
        <i class="bi bi-person-plus-fill"></i> 사원 등록
      </a>
    </sec:authorize>
  </div>

  <div class="card">
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-hover align-middle">
          <thead class="table-light">
            <tr>
              <th>사원 이름</th>
              <th>직급</th>
              <th>부서 이름</th>
              <th>이메일</th>
              <th>주소</th>
              <th>전화번호</th>
              <th>생년월일</th>
              <th>입사일</th>
              <th>퇴사일</th>
              <th>부양가족</th>
              <th>자녀 수</th>
              <th>활성화 여부</th>
              <th>퇴사</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="e" items="${employees}">
              <tr class="clickable-row" onclick="location.href='/employee/edit?employeeId=${e.employeeId}'">
                <td><c:out value="${e.username}"/></td>
                <td><c:out value="${e.jobTitle}"/></td>
                <td><c:out value="${e.deptName}"/></td>
                <td><c:out value="${empty e.email ? '-' : e.email}"/></td>
                <td><c:out value="${empty e.address ? '-' : e.address}"/></td>
                <td><c:out value="${empty e.phone ? '-' : e.phone}"/></td>
                <td><c:choose>
                      <c:when test="${not empty e.birth}">
                        <c:out value="${e.birth}"/>
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>
                <td><c:choose>
                      <c:when test="${not empty e.hireDate}">
                        <c:out value="${e.hireDate}"/>
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>
                <td><c:choose>
                      <c:when test="${not empty e.retireDate}">
                        <c:out value="${e.retireDate}"/>
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>
                <td><c:out value="${empty e.dependents ? '-' : e.dependents}"/></td>
                <td><c:out value="${empty e.children ? '-' : e.children}"/></td>
                <td>
                  <a href="/employee/toggle-enabled?employeeId=${e.employeeId}"
                     class="text-decoration-none" onclick="event.stopPropagation();">
                    <c:choose>
                      <c:when test="${e.enabled == 1}">
                        <span class="badge bg-success">활성화</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge bg-secondary">비활성화</span>
                      </c:otherwise>
                    </c:choose>
                  </a>
                </td>
                <td>
                  <form method="post" action="/employee/resign" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="employeeId" value="${e.employeeId}"/>
                    <button type="submit" class="btn btn-outline-danger btn-sm"
                            <c:if test="${e.enabled != 1}">disabled</c:if>>
                      <i class="bi bi-person-dash"></i> 퇴사
                    </button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty employees}">
              <tr>
                <td colspan="13" class="text-center text-muted">사원 데이터가 없습니다.</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="mt-3">
    <a href="/main" class="btn btn-outline-secondary">
      <i class="bi bi-arrow-left"></i> 메인으로
    </a>
  </div>
</div>
</div>
</body>
</html>
