<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<%@include file="/hrm/side.jsp" %>
<sec:authorize access="principal.role_id == '2'">
<div class="main-content p-0">
<div class="container py-4">
  <h3 class="mb-3"><i class="bi bi-pencil-square me-2"></i>사원 수정</h3>

  <form method="post" action="/employee/edit" class="card p-3 shadow-sm">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <input type="hidden" name="employeeId" value="${employee.employeeId}" />
    <div class="row g-3">
      <div class="col-md-4">
        <label class="form-label">이름</label>
        <input type="text" name="username" class="form-control" value="${employee.username}" required />
      </div>
      <div class="col-md-4">
        <label class="form-label">연봉</label>
        <input type="number" name="salaryYear" class="form-control" min="0" step="1" value="${employee.salaryYear}" required />
      </div>
      <div class="col-md-4">
        <label class="form-label">입사일</label>
        <input type="date" name="sDate" class="form-control" value="${employee.hireDate}" />
      </div>

      <div class="col-md-12">
        <label class="form-label">이메일</label>
        <input type="email" name="email" class="form-control" placeholder="example@company.com" value="${employee.email}" />
      </div>

      <div class="col-md-12">
        <label class="form-label">주소</label>
        <input type="text" name="address" class="form-control" placeholder="주소를 입력하세요" value="${employee.address}" />
      </div>
      <div class="col-md-6">
        <label class="form-label">전화번호</label>
        <input type="tel" name="phone" class="form-control" placeholder="010-1234-5678" value="${employee.phone}" />
      </div>
      <div class="col-md-6">
        <label class="form-label">생년월일</label>
        <input type="date" name="birth" class="form-control" value="${employee.birth}" />
      </div>

      <div class="col-md-6">
        <label class="form-label">직급</label>
        <select name="jobId" class="form-select" required>
          <option value="" disabled>직급 선택</option>
          <c:forEach var="j" items="${jobs}">
            <option value="${j.jobId}" <c:if test="${j.jobId == employee.jobId}">selected</c:if>>
              <c:out value="${j.jobTitle}"/>
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="col-md-6">
        <label class="form-label">부서</label>
        <select name="deptId" class="form-select" required>
          <option value="" disabled>부서 선택</option>
          <c:forEach var="d" items="${departments}">
            <option value="${d.deptId}" <c:if test="${d.deptId == employee.deptId}">selected</c:if>>
              <c:out value="${d.deptName}"/>
            </option>
          </c:forEach>
        </select>
      </div>

      <div class="col-md-6">
        <label class="form-label">부양가족 수</label>
        <input type="number" name="dependents" class="form-control" min="0" step="1" value="${employee.dependents}" />
      </div>
      <div class="col-md-6">
        <label class="form-label">자녀 수</label>
        <input type="number" name="children" class="form-control" min="0" step="1" value="${employee.children}" />
      </div>
    </div>

    <div class="mt-4 d-flex gap-2">
      <button type="submit" class="btn btn-primary">
        <i class="bi bi-check2-circle"></i> 저장
      </button>
      <a href="/employee/manage" class="btn btn-outline-secondary">
        <i class="bi bi-x-circle"></i> 취소
      </a>
    </div>
  </form>
</div>
</div>
</sec:authorize>
<sec:authorize access="!(principal.role_id == '2')">
  <div class="container py-5 text-center text-muted">
    접근 권한이 없습니다.
    <div class="mt-3">
      <a class="btn btn-outline-secondary" href="/main"><i class="bi bi-arrow-left"></i> 메인으로</a>
    </div>
  </div>
</sec:authorize>
</body>
</html>
