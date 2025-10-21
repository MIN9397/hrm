<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>메일 보내기</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
<style>
.main-content { padding: 20px; }
.mail-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,.1);
  padding: 20px;
  max-width: 900px;
}
</style>
</head>
<body>
<%@include file="/hrm/side.jsp" %>

<div class="main-content">
  <div class="mail-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="mb-0"><i class="bi bi-envelope"></i> 메일 보내기</h3>
    </div>

    <c:if test="${not empty success}">
      <div class="alert alert-success" role="alert">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>

    <form action="/mail/send" method="post" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <div class="mb-3">
        <label class="form-label">받는 사람 이메일</label>
        <input type="email" name="toEmail" class="form-control" placeholder="example@company.com" required />
      </div>

      <div class="mb-3">
        <label class="form-label">제목 (선택)</label>
        <input type="text" name="subject" class="form-control" placeholder="제목을 입력하세요 (선택)" />
      </div>

      <div class="mb-3">
        <label class="form-label">내용</label>
        <textarea name="content" class="form-control" rows="10" placeholder="메일 본문 내용을 입력하세요" required></textarea>
      </div>

      <div class="mb-3">
        <label class="form-label">첨부파일 (여러 개 선택 가능)</label>
        <input type="file" name="attachments" class="form-control" multiple />
        <div class="form-text">허용 가능한 파일만 첨부하세요. 보안 상 경로 문자는 제거됩니다.</div>
      </div>

      <div class="d-flex gap-2">
        <button type="submit" class="btn btn-primary"><i class="bi bi-send"></i> 보내기</button>
        <a href="/main" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> 메인으로</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>
