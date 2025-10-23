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
.profile-container {
  width: 950px;
  margin: 20px auto;
  font-family: "Noto Sans KR", sans-serif;
}

.profile-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 15px;
  font-size: 14px;
  
}

.profile-table th,
.profile-table td {
  border: 1px solid #ccc;
  padding: 8px 10px;
  text-align: left;
}

.profile-table th {
  background-color: #f6f6f6;
  width: 99px;
  max-width: 99px;  /* 👈 최대폭 제한 */
  font-weight: 500;
}

.profile-table td {
  width: 120px;
  max-width: 150px;  /* 👈 최대폭 제한 */
  background-color: #fff;
}

.photo-cell {
  width: 220px;
  text-align: center;
  vertical-align: middle;
}

.profile-img {
  width: 200px;
  height: 200px;
  border-radius: 4px;
  object-fit: cover;
  border: 1px solid #ccc;
}

/* 상단/하단 표 간격 조정 */
.top-table {
  margin-bottom: 10px;
}

.bottom-table th {
  text-align: center;
}

.form-container {
  width: 950px;           /* 상단 프로필과 동일한 폭 */
  margin: 0 auto 40px;    /* 가운데 정렬 + 아래 여백 */
}

.form-container .card {
  border: 1px solid #ccc; /* 표와 어울리는 테두리 */
}

.form-container .btn {
  min-width: 120px;
}

</style>
</head>
<body class="bg-light">
<%@include file="/hrm/side.jsp" %>
<div class="main-content p-0">
<div class="container py-4">
  <h3 class="mb-3"><i class="bi bi-person-circle me-2"></i>마이페이지</h3>

<div class="profile-container">
  <!-- 🔹 상단 기본 정보 -->
  <table class="profile-table top-table">
    <tr>
      <!-- 왼쪽: 프로필 사진 -->
      <td class="photo-cell" rowspan="3">
        <img class="profile-img"
             src="/mypage/profile-image?employeeId=${me.employeeId}&t=${imgVersion}"
             onerror="this.src='https://via.placeholder.com/150?text=사진'"
             alt="Profile">
      </td>

      <!-- 오른쪽: 이름 / 사번 -->
      <th>이름</th>
      <td><c:out value="${me.username}"/></td>
      <th>사번</th>
      <td><c:out value="${me.employeeId}"/></td>
    </tr>

    <tr>
      <th>부서</th>
      <td><c:out value="${me.deptName}"/></td>
      <th>직책</th>
      <td><c:out value="${me.jobTitle}"/></td>
    </tr>

    <tr>
      <th>생년월일</th>
      <td><c:out value="${me.birth}"/></td>
      <th>연락처</th>
      <td><c:out value="${me.phone}"/></td>
    </tr>
  </table>

  <!-- 🔹 하단 추가 정보 -->
  <table class="profile-table bottom-table">
    <tr>
      <th>입사일</th>
      <td><c:out value="${me.hireDate}"/></td>
      <th>직군</th>
      <td><c:out value="${me.retireDate}"/></td>
      <th>사용연차</th>
      <td><c:out value="${me.retireDate}"/></td>
      <th>성별</th>
      <td><c:out value="${me.retireDate}"/></td>
    </tr>

    <tr>
      <th>결혼여부</th>
      <td><c:out value="${me.retireDate}"/></td>
      <th>이메일</th>
      <td><c:out value="${me.email}"/></td>
      <th>남은연차</th>
      <td><c:out value="${me.retireDate}"/></td>
      <th>퇴사일</th>
      <td><c:out value="${me.retireDate}"/></td>
    </tr>

    <tr>
      <th>주소</th>
      <td colspan="7"><c:out value="${me.address}"/></td>
    </tr>

    <tr>
      <th>부양가족</th>
      <td><c:out value="${me.dependents}"/></td>
      <th>자녀수</th>
      <td><c:out value="${me.children}"/></td>
      <th>관리구분</th>
      <td><c:out value="${me.retireDate}"/></td>
      <th>사원코드</th>
      <td><c:out value="${me.employeeCode}"/></td>
    </tr>
  </table>
</div>


<div class="form-container">
  <form id="mypageForm" method="post" action="/mypage/update"
        enctype="multipart/form-data" class="card p-3 shadow-sm">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

    <div class="row g-3">
      <div class="col-md-12">
        <label class="form-label">이메일</label>
        <input type="email" name="email" class="form-control"
               value="${me.email}" placeholder="example@company.com"/>
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
        <button type="button" class="btn btn-success" onclick="window.open('/certificate?employeeId=${me.employeeId}', '_blank')">
    	<i class="bi bi-file-earmark-text"></i> 재직증명서 출력 </button>
    	

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
