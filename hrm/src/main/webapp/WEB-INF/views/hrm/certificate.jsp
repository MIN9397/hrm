<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>재직증명서 출력</title>
<!-- html2canvas & jsPDF CDN -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  
    <style>
    body {
      font-family: 'Malgun Gothic', sans-serif;
      background-color: #f8f8f8;
      text-align: center;
    }

    
    #certificate {
      width: 794px;  /* A4 비율 */
      height: 1123px;
      margin: 30px auto;
      background-image: url('<%= request.getContextPath() %>/img/certificate.png');
      background-size: cover;
      background-repeat: no-repeat;
      position: relative;
      color: #000;
    }

    .field {
      position: absolute;
      font-size: 18px;
      font-weight: bold;
    }

    /* 배경 위에 표시될 텍스트 좌표 (조정 가능) */
    #name { top: 195px; left: 250px; }
    #birth { top: 195px; left: 600px; }
    #department { top: 243px; left: 250px; }
    #position { top: 243px; left: 600px; }
    #address { top: 291px; left: 250px; }
    #inp { top: 385px; left: 250px; }
    #hireDate { top: 338px; left: 250px; }
    #issueDate { top: 750px; left: 351px; }
    
    button {
      background: #1976d2; color: white; padding: 8px 20px;
      border: none; border-radius: 5px; cursor: pointer; font-size: 14px;
    }
    
    .content {
    flex: 1;
    padding: 40px;
    background-color: #fafafa;
  }
  </style>
  
</head>
<body>

<%@include file="/hrm/side.jsp" %>
<div class="content">
<CENTER><h2>재직증명서</h2></CENTER>
  <!-- ✅ 용도 입력창 + PDF 버튼 -->
  <div style="margin-bottom: 10px;">
    <label for="purpose"> 용도 입력 > </label>
    <input type="text" id="purpose" placeholder="예: 은행 제출용" />
    <button onclick="generatePDF()">PDF 출력</button>
  </div>

   <div id="certificate">
    <div class="field" id="name">${certi.username}</div>
    <div class="field" id="birth">${certi.birth}</div>
    <div class="field" id="department">${certi.deptName}</div>
    <div class="field" id="position">${certi.jobTitle}</div>
    <div class="field" id="address">${certi.address}</div>
    <div class="field" id="hireDate">${certi.sDate} ~ 현재</div>
        <!-- ✅ 입력된 용도 표시될 부분 -->
    <div class="field" id="inp"></div>
    
    <div class="field" id="issueDate">${certi.issueDate}</div>
    
    
  </div>

</div>
<script>
  // ✅ PDF 출력 함수
  function generatePDF() {
    // 입력창 값 읽어서 증명서 내 #inp에 표시
    const purpose = document.getElementById("purpose").value || " ";
    document.getElementById("inp").innerText = purpose;

    html2canvas(document.querySelector("#certificate"), {scale: 2}).then(canvas => {
      const imgData = canvas.toDataURL("image/png");
      const pdf = new jspdf.jsPDF('p', 'mm', 'a4');
      const pdfWidth = 210;
      const pdfHeight = (canvas.height * pdfWidth) / canvas.width;
      pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
      pdf.save("재직증명서_" + "${certi.username}" + ".pdf");
    });
  }
</script>

</body>
</html>