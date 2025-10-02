<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HRM 로그인</title>
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background: #f8f8f8;
      color: #333;
    }

    .container {
      display: flex;
      min-height: 100vh;
      padding: 0 200px;   /* 좌우 여백 */
    }

    /* 왼쪽 설명 영역 */
    .left {
      flex: 2;
      padding: 60px;
      background: #fff;
    }

    .left h1 {
      font-size: 28px;
      margin-bottom: 20px;
      margin-left: 40px;
    }

    .left h2 {
      font-size: 20px;
      margin: 30px 0 10px;
      margin-left: 40px;
    }

    .left p {
      font-size: 15px;
      line-height: 1.6;
      margin-bottom: 10px;
      margin-left: 40px;
    }

    /* 오른쪽 로그인 영역 */
    .right {
      flex: 1;
      background: #0072c6;
      color: #fff;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      padding: 40px 20px;
    }

    .right h1 {
      font-size: 24px;
      margin-bottom: 20px;
    }

    .form-group {
      width: 100%;
      max-width: 280px;
      margin-bottom: 15px;
    }

    .form-group input, 
    .form-group select {
      width: 100%;
      padding: 12px;
      border-radius: 6px;
      border: none;
      font-size: 14px;
    }

    .btn {
      width: 100%;
      max-width: 280px;
      padding: 12px;
      background: #ffbf00;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
      margin-top: 10px;
    }

    .phone {
      margin-top: 20px;
      font-size: 16px;
      font-weight: bold;
    }
    .logo1 img {
	  width: 300px;   /* 가로 크기 */
	  height: auto;   /* 세로는 비율 유지 */
	}

    /* 반응형 */
    @media (max-width: 768px) {
      .container {
        flex-direction: column;
      }
      .left, .right {
        flex: none;
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- 왼쪽 영역 -->
    <div class="left">
        <div class="logo1">
       		<a href="#"><img src="/img/logo_500.png" alt="로고" /></a>
    	</div>
      <h1>내맘대로 H.R.M</h1>
      <h2>자신 없으면 보여드리지 않습니다.</h2>
      <p>- 눈으로 직접 보고 구매할 수 있는 인사관리 프로그램입니다.</p>
      <p>- 내맘대로 H.R.M는 이미 모든 기능이 준비되어 있기에 가능합니다.</p>

      <h2>쉽게 체험할 수 있습니다.</h2>
      <p>- 다양한 기능을 쉽게 이용할 수 있도록 기본 데이터가 입력되어 있습니다.</p>
      <p>- 궁금한 점이 생기면 언제든 문의를 주시면 연락드리겠습니다.</p>

      <p style="margin-top:40px; font-size:13px; color:#666;">
        ※ 일반 사용자는 다음과 같은 제한이 있을 수 있습니다.<br>
        · 사용자 ID / 사용자명 기능은 가상 데이터<br>
        · 사용자별 권한, 환경설정 변경 불가<br>
        · 데이터 보관주기 제한<br>
        관리자는 프로그램에서는 모든 기능을 정상적으로 사용할 수 있습니다.
      </p>
    </div>
    <!-- 오른쪽 로그인 폼 -->
    <div class="right">
	<form action="/login" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	  
      <h1>내맘대로 H.R.M</h1>
      <div class="form-group">
     	  <c:if test="${param.error != null}">
				아이디 비밀번호를 확인후 다시 시도해주세요.
		  </c:if>
		  <c:if test="${param.logout != null}">
				You have been logged out.
		  </c:if>
      </div>
      <div class="form-group">
       	<input type="text" name="empno" placeholder="사원번호 입력하세요.">
      </div>
      <div class="form-group">
        <input type="text" name="id" placeholder="이름을 입력하세요." value="user">
      </div>
      <div class="form-group">
		<input type="text" name="pw" placeholder="password"  value="password">
      </div>
      <div class="form-group">
      	<button class="btn" type="submit">로그인</button>
      </div>
      <div class="phone">📞 031-123-4567</div>
      
	</form>
    </div>
  </div>
</body>
</html>