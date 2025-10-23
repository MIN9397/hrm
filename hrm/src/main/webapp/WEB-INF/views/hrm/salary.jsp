<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
<meta charset="UTF-8">
<title>사원별 급여명세서</title>
<style>
  body {
    font-family: '맑은 고딕', sans-serif;
    margin: 40px;
    background: #f7f7f7;
  }
  .pay-slip {
    position: relative;
    background: #fff;
    border: 1px solid #ccc;
    border-radius: 10px;
    width: 800px;
    margin: 30px auto;
    padding: 30px;
    box-shadow: 0 0 8px rgba(0,0,0,0.1);
  }
  h2 {
    text-align: center;
    border-bottom: 2px solid #333;
    padding-bottom: 10px;
  }
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
  }
  th, td {
    border: 1px solid #ccc;
    padding: 8px 10px;
    text-align: right;
  }
  th {
    background: #efefef;
  }
  .section-title {
    background: #dce6f1;
    text-align: left;
    font-weight: bold;
  }
  .total {
    background: #f9f9c9;
    font-weight: bold;
  }
  
	.pdf-btn {
	  position: absolute;
	  top: 15px;
	  right: 15px;
	  background-color: #007bff;
	  color: white;
	  border: none;
	  padding: 6px 12px;
	  border-radius: 6px;
	  cursor: pointer;
	  font-size: 14px;
	  transition: background-color 0.2s ease;
	}
	
	.pdf-btn:hover {
	  background-color: #0056b3;
	}
	  
</style>
</head>

<body>
<%@include file="/hrm/side.jsp" %>



  <div class="pay-slip" >
    <h2>급여명세서</h2>
	<button class="pdf-btn" onclick="printPaySlip()">PDF 출력</button>
    <table>
      <tr><th class="section-title" colspan="4">[사원정보]</th></tr>
      <tr>
        <th>사원명</th><td>${detail.username}</td>
        <th>사번</th><td>${detail.employeeId}</td>
      </tr>
      <tr>
        <th>부서</th><td>${detail.deptName}</td>
        <th>지급월</th><td>${detail.payMonth}</td>
      </tr>
    </table>

    <table>
      <tr><th class="section-title" colspan="4">[지급항목]  <span style="font-size: 12px; font-weight: 400; color: red;">※ 식대는 기본급 포함 입니다.</span></th></tr>
      <tr><th>항목</th><th>금액</th><th>비고</th><th>비과세</th></tr>
      <tr><td>기본급</td><td><fmt:formatNumber value="${detail.baseSalary}" type="number" groupingUsed="true"/></td><td></td><td></td></tr>
      <tr><td>식대</td><td><fmt:formatNumber value="${detail.mealAllowance}" type="number" groupingUsed="true"/></td><td></td><td>O</td></tr>
      <tr><td>자가운전보조금</td><td><fmt:formatNumber value="${detail.carAllowance}" type="number" groupingUsed="true"/></td><td></td><td>O</td></tr>
      <tr><td>육아수당</td><td><fmt:formatNumber value="${detail.childcareAllowance}" type="number" groupingUsed="true"/></td><td></td><td>O</td></tr>
      <tr><td>${detail.bonus1Name}</td><td><fmt:formatNumber value="${detail.bonus1}" type="number" groupingUsed="true"/></td><td></td><td></td></tr>
      <tr><td>${detail.bonus2Name}</td><td><fmt:formatNumber value="${detail.bonus2}" type="number" groupingUsed="true"/></td><td></td><td></td></tr>
      <tr class="total"><td>지급총액</td><td><fmt:formatNumber value="${detail.totalPayment}" type="number" groupingUsed="true"/></td><td colspan="2"></td></tr>
    </table>

    <table>
      <tr><th class="section-title" colspan="3">[공제항목]</th></tr>
      <tr><th>항목</th><th>금액</th><th>비고</th></tr>
      <tr><td>국민연금</td><td><fmt:formatNumber value="${detail.pension}" type="number" groupingUsed="true"/></td><td></td></tr>
      <tr><td>건강보험</td><td><fmt:formatNumber value="${detail.healthInsurance}" type="number" groupingUsed="true"/></td><td></td></tr>
      <tr><td>고용보험</td><td><fmt:formatNumber value="${detail.employmentInsurance}" type="number" groupingUsed="true"/></td><td></td></tr>
      <tr><td>소득세</td><td><fmt:formatNumber value="${detail.incomeTax}" type="number" groupingUsed="true"/></td><td></td></tr>
      <tr><td>지방소득세</td><td><fmt:formatNumber value="${detail.localTax}" type="number" groupingUsed="true"/></td><td></td></tr>
      <tr class="total"><td>공제총액</td><td><fmt:formatNumber value="${detail.totalDeduction}" type="number" groupingUsed="true"/></td><td></td></tr>
    </table>

    <table>
      <tr><th class="section-title" colspan="2">[실지급액]</th></tr>
      <tr>
        <th>수령액</th>
        <td><fmt:formatNumber value="${detail.netPayment}" type="number" groupingUsed="true"/>원</td>
      </tr>
    </table>

    <p style="text-align:right; margin-top:30px;">지급일자: <span>${detail.payDate}</span></p>
  </div>
  
<script>
function printPaySlip() {
  const printContents = document.querySelector('.pay-slip').innerHTML;
  const originalContents = document.body.innerHTML;

  document.body.innerHTML = printContents;
  window.print();
  document.body.innerHTML = originalContents;
  location.reload(); // 페이지 리로드해서 스크립트 재실행 보장
}
</script>
  
</body>
</html>
