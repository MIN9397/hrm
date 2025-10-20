<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

	<title>급여 리스트</title>
<style>
  /* 메인 콘텐츠 영역 */
  .content {
    flex: 1;
    padding: 40px;
    background-color: #fafafa;
  }

  .banner {
    text-align: center;
    margin-bottom: 20px;
  }

  .banner img {
    width: 90%;
    max-width: 1500px;
    border-radius: 10px;
  }

  .payd-table {
    width: 90%;
    margin: 30px auto;
    border-collapse: collapse;
    text-align: center;
  }

  .payd-table th,
  .payd-table td {
    border: 1px solid #ccc;
    padding: 12px 16px;
  }

  .payd-table th {
    background-color: #f4f4f4;
  }

  .pagination {
    display: flex;
    justify-content: center;
    gap: 8px;
    margin: 20px 0;
  }

  .pagination a {
    padding: 8px 12px;
    text-decoration: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    color: black;
  }

  .pagination a.active {
    background-color: #007bff;
    color: white;
    border-color: #007bff;
  }
</style>

</head>

<body>
<%@include file="/hrm/side.jsp" %>

<div class="content">
  	<!-- 예약 확인 배너 -->
	<div class="banner">
	  <img src="/img/msalary1.jpg" alt="공지 배너 이미지">
	</div>





<br>

<h2 style="text-align:center;">월별 급여 리스트</h2>

<table class="payd-table">
  <thead>
    <tr>
      <th>직원명</th>
      <th>직책명</th>
      <th>년 / 월</th>
      <th>총급여액</th>
      <th>실지급액</th>
      <th>내역 확인</th> <!-- ✅ 컬럼명 변경 -->
      
    </tr>
  </thead>
  <tbody>
    <c:forEach var="pay" items="${list}">
      <tr>
        <td>${pay.username}</td>
        <td>${pay.jobTitle}님</td>
        <td>${pay.payMonth} 급여 명세</td>
        <td>
        
        <fmt:formatNumber value="${pay.totalPayment}" pattern="#,##0.0"/>
        
        </td>
        <td>
        <fmt:formatNumber value="${pay.netPayment}" pattern="#,##0.0"/>
        </td>
        
        
                <!-- ✅ 버튼 추가 -->
        <td>
          <a href="/salary?pay_id=${pay.payId}" 
             class="btn btn-sm btn-success">
             월별 내역 확인
          </a>
        </td>
        
      </tr>
    </c:forEach>
  </tbody>
</table>

<!-- 페이지네이션 -->
<div class="pagination">
    <c:forEach begin="1" end="${totalPages}" var="i">
        <a href="?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>
</div>
</div>





  

</body>
</html>
