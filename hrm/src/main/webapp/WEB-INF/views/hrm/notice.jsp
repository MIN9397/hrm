<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 목록</title>
<style>
body {
  font-family: "맑은 고딕", sans-serif;
  background-color: #f6f7fb;
  margin: 0;
  padding: 0;
}

.container {
  width: 1000px;
  margin: 50px auto;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 30px;
  box-sizing: border-box;
}

h2 {
  text-align: center;
  margin-bottom: 25px;
  font-size: 24px;
  color: #333;
  border-bottom: 2px solid #007bff;
  padding-bottom: 10px;
}

/* 테이블 */
.notice-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

.notice-table th, .notice-table td {
  padding: 12px 10px;
  text-align: center;
  border-bottom: 1px solid #ddd;
  font-size: 15px;
}

.notice-table th {
  background-color: #f1f3f6;
  font-weight: bold;
}

.notice-table td.title {
  text-align: left;
  padding-left: 15px;
}

.notice-table a {
  text-decoration: none;
  color: #333;
}

.notice-table a:hover {
  color: #007bff;
  text-decoration: underline;
}

.notice-table tr:hover {
  background-color: #f9fbff;
}

/* 버튼 */
.btn-area {
  text-align: right;
  margin-top: 10px;
}

.btn-write {
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 10px 18px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.btn-write:hover {
  background-color: #0056b3;
}

/* 페이지네이션 */
.pagination {
  text-align: center;
  margin-top: 20px;
}

.pagination a {
  display: inline-block;
  margin: 0 5px;
  padding: 6px 10px;
  color: #007bff;
  border: 1px solid #ddd;
  border-radius: 4px;
  text-decoration: none;
}

.pagination a:hover {
  background-color: #007bff;
  color: #fff;
  border-color: #007bff;
}

.pagination .active {
  background-color: #007bff;
  color: #fff;
  border-color: #007bff;
}
</style>
</head>
<body>

<%@include file="/hrm/side.jsp" %>

<div class="container">
  <h2>공지사항</h2>

  <table class="notice-table">
    <thead>
      <tr>
        <th style="width:80px;">번호</th>
        <th style="width:500px;">제목</th>
        <th style="width:120px;">작성자</th>
        <th style="width:150px;">등록일</th>
        
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty list}">
        <tr><td colspan="5">등록된 공지사항이 없습니다.</td></tr>
      </c:if>

      <c:forEach items="${list}" var="notice" varStatus="status">
        <tr>
          <td>${notice.noticeId}</td>
          <td class="title">
            <a href="/notice/detail?noticeId=${notice.noticeId}">
              ${notice.title}
            </a>
          </td>
          <td>${notice.writer}</td>
          <td>${notice.issueDate2}</td>
          
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <div class="btn-area">
    <button class="btn-write" onclick="location.href='/notice/insert'">글쓰기</button>
  </div>

  <!-- 페이지네이션 -->
  <div class="pagination">
    <c:if test="${page > 1}">
      <a href="?page=${page - 1}">이전</a>
    </c:if>

    <c:forEach begin="1" end="${totalPages}" var="p">
      <a href="?page=${p}" class="${p == page ? 'active' : ''}">${p}</a>
    </c:forEach>

    <c:if test="${page < totalPages}">
      <a href="?page=${page + 1}">다음</a>
    </c:if>
  </div>
</div>

</body>
</html>
