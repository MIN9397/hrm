<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
<style>
.profile-img {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  object-fit: cover;
  border: 1px solid #ddd;
}
</style>
</head>
<body class="bg-light">
<%@include file="/hrm/side.jsp" %>
<div class="main-content p-0">
<div class="container py-4">
  <h3 class="mb-3"><i class="bi bi-person-circle me-2"></i>마이페이지</h3>

  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card p-3 text-center">
        <img class="profile-img mx-auto mb-2"
             src="/mypage/profile-image?employeeId=${me.employeeId}&t=${imgVersion}"
             onerror="this.src='https://via.placeholder.com/120?text=Profile'"
             alt="Profile"/>
        <div class="text-muted small">
          <c:out value="${me.username}"/>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <form id="mypageForm" method="post" action="/mypage/update" enctype="multipart/form-data" class="card p-3 shadow-sm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="row g-3">
          <div class="col-md-12">
            <label class="form-label">이메일</label>
            <input type="email" name="email" class="form-control" value="${me.email}" placeholder="example@company.com"/>
          </div>

          <div class="col-md-12">
            <label class="form-label">프로필 이미지</label>
            <input type="file" name="profileImage" accept="image/*" class="form-control"/>
            <div class="form-text">JPG/PNG 권장. 업로드 시 즉시 저장됩니다.</div>
          </div>

          <div class="col-md-6">
            <label class="form-label">새 비밀번호</label>
            <input type="password" name="password" class="form-control" autocomplete="new-password"/>
          </div>
          <div class="col-md-6">
            <label class="form-label">비밀번호 확인</label>
            <input type="password" name="passwordConfirm" class="form-control" autocomplete="new-password"/>
          </div>
        </div>

        <div class="mt-4 d-flex gap-2">
          <button type="submit" class="btn btn-primary">
            <i class="bi bi-check2-circle"></i> 저장
          </button>
          <a href="/main" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> 메인으로
          </a>
        </div>
      </form>
    </div>
  </div>
</div>
</div>

<script>
  // 프로필 이미지 선택 시 자동 저장
  document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('mypageForm');
    const fileInput = document.querySelector('input[name="profileImage"]');
    if (form && fileInput) {
      fileInput.addEventListener('change', function() {
        if (this.files && this.files.length > 0) {
          form.submit();
        }
      });
    }
  });
</script>
</body>
</html>
