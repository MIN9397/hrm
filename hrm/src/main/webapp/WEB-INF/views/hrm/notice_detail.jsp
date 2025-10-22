<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>공지 사항 작성 페이지</title>
<!-- Optional: Bootstrap CDN for quick styling (삭제하거나 로컬로 변경 가능) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<style>
/* 간단한 커스텀 스타일 */
.container { max-width: 900px; margin-top: 30px; }
.required { color: #d00; }
</style>

</head>
<body>

<%@include file="/hrm/side.jsp" %>

	<div class="container">
		<h1 class="mb-4">공지사항 작성</h1>


		<!-- 서버에서 전달되는 에러/메시지 출력 -->
		<c:if test="${not empty error}">
			<div class="alert alert-danger">${error}</div>
		</c:if>
		<c:if test="${not empty success}">
			<div class="alert alert-success">${success}</div>
		</c:if>


		<!-- 공지 작성 폼: enctype="multipart/form-data"는 파일업로드용 -->
		<!-- action은 서버 측 컨트롤러(예: /notice/save)로 맞춰주세요 -->
		<form id="noticeForm" method="post"
			action="${pageContext.request.contextPath}/notice/save">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />


			<!-- 보통 로그인한 사용자의 아이디를 숨겨서 보냄 -->
			<input type="hidden" name="authorId"
				value="${sessionScope.loginUser != null ? sessionScope.loginUser.id : ''}" />


			<div class="mb-3">
				<label for="title" class="form-label">제목 <span
					class="required">*</span></label> <input type="text" class="form-control"
					id="title" name="title" maxlength="200" readonly
					value="${dto.title}" required>
			</div>





			<div class="mb-3">
				<label for="content" class="form-label">내용 <span
					class="required">*</span></label>
				<textarea class="form-control" id="content" name="content" rows="12" readonly
					required>${dto.content}</textarea>
				<div class="form-text"></div>
			</div>




			<div class="d-flex gap-2">
				<a href="${pageContext.request.contextPath}/notice"
					class="btn btn-secondary">목록으로</a>

			</div>
		</form>

	</div>




	<script>
		document.getElementById('noticeForm').addEventListener('submit',
				function(e) {
				});
	</script>

</body>
</html>