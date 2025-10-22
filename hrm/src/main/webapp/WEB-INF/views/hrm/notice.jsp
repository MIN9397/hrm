<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

.main-content {
  padding: 20px;
}

/* 상단 3박스 */
.top-boxes {
  display: flex;
  justify-content: space-between;
  gap: 20px;   /* 가로·세로 간격 */
  margin-bottom: 30px;
}

.top-boxes .box {
  width: 500px;
  height: 800px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
  box-sizing: border-box;
  overflow: hidden;
}

.profile-box {
  text-align: center;
  cursor: pointer;
}

.profile-box .profile-img {
  width: 120px;
  height: 200px;
  border-radius: 50%;
  margin-bottom: 15px;
}

/* 리스트 스타일 */
.notice-box ul,
.inquiry-box ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.notice-box li,
.inquiry-box li {
  margin-bottom: 10px;
}

.notice-box a,
.inquiry-box a {
  text-decoration: none;
  color: #333;
}

.notice-box a:hover,
.inquiry-box a:hover {
  text-decoration: underline;
}

/* 하단 영역 */
.bottom-boxes {
  display: flex;
  gap: 20px;   /* 가로·세로 간격 */
  gap: 20px;
}

.graph-area {
  flex: 4; /* 40% */
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
}

.status-area {
  flex: 6; /* 60% */
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
}




</style>



</head>
<body>

<%@include file="/hrm/side.jsp" %>

<div class="main-content">
  <!-- 상단 3박스 -->
  <div class="top-boxes">
    
    <!-- 공지사항 -->
    <div class="box notice-box">
      <h3>공지사항</h3>
      <button onclick = "location.href = '/notice/insert'">글쓰기</button>
      <a href="notice_insert.jsp"></a>
      <ul>
      	<c:forEach items="${list }" var="notice">
        	<li><a href="/notice/detail?noticeId=${notice.noticeId }">${notice.title }</a></li>
        </c:forEach>
        
      </ul>
    </div>

  </div>
</div>


</body>
</html>