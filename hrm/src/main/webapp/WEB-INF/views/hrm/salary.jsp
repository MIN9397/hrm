<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
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
    background: #fff;
    border: 1px solid #ccc;
    border-radius: 10px;
    width: 800px;
    margin: auto;
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
</style>
</head>

<body>
<%@include file="/hrm/side.jsp" %>
  <div class="pay-slip" >
    <h2>급여명세서</h2>

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
      <tr><td>기본급</td><td>${detail.baseSalary}</td><td></td><td></td></tr>
      <tr><td>식대</td><td>${detail.mealAllowance}</td><td></td><td>O</td></tr>
      <tr><td>자가운전보조금</td><td>${detail.carAllowance}</td><td></td><td>O</td></tr>
      <tr><td>육아수당</td><td>${detail.childcareAllowance}</td><td></td><td>O</td></tr>
      <tr><td>${detail.bonus1Name}</td><td>${detail.bonus1}</td><td></td><td></td></tr>
      <tr><td>${detail.bonus2Name}</td><td>${detail.bonus2}</td><td></td><td></td></tr>
      <tr class="total"><td>지급총액</td><td>${detail.totalPayment}</td><td colspan="2"></td></tr>
    </table>

    <table>
      <tr><th class="section-title" colspan="3">[공제항목]</th></tr>
      <tr><th>항목</th><th>금액</th><th>비고</th></tr>
      <tr><td>국민연금</td><td>${detail.pension}</td><td></td></tr>
      <tr><td>건강보험</td><td>${detail.healthInsurance}</td><td></td></tr>
      <tr><td>고용보험</td><td>${detail.employmentInsurance}</td><td></td></tr>
      <tr><td>소득세</td><td>${detail.incomeTax}</td><td></td></tr>
      <tr><td>지방소득세</td><td>${detail.localTax}</td><td></td></tr>
      <tr class="total"><td>공제총액</td><td>${detail.totalDeduction}</td><td></td></tr>
    </table>

    <table>
      <tr><th class="section-title" colspan="2">[실지급액]</th></tr>
      <tr>
        <th>수령액</th>
        <td>${detail.netPayment}원</td>
      </tr>
    </table>

    <p style="text-align:right; margin-top:30px;">지급일자: <span>${detail.payDate}</span></p>
  </div>
</body>
</html>
