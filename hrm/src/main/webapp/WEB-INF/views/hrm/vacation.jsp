<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>휴가 등록</title>
    <style>
        body { font-family: "Pretendard", sans-serif; margin: 40px; background: #fafafa; }
        h2 { text-align: center; }
        form {
            width: 400px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        label, input, select {
            display: block;
            width: 100%;
            margin-bottom: 15px;
        }
        button {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        table {
            margin: 30px auto;
            width: 80%;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        td form {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    margin: 0; /* 여백 제거 */
		    padding: 0;
		    height: 100%;
		}
		
		td form button {
		    padding: 6px 12px;
		    font-size: 14px;
		    border-radius: 4px;
		    border: none;
		    background-color: #007bff;
		    color: white;
		    cursor: pointer;
		}
		
		td form button:hover {
		    background-color: #0056b3;
		}
        
    </style>
</head>
<body>

<h2>휴가 등록</h2>

<form method="post" action="/vacation/save">
    <label for="employeeId">직원 ID</label>
    <input type="number" name="employeeId" id="employeeId" required value="${employeeId}"/>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	
    <label for="leaveType">휴가 종류</label>
    <select name="leaveType" id="leaveType" required>
        <option value="">-- 선택하세요 --</option>
        <option value="연차">연차</option>
        <option value="병가">병가</option>
        <option value="반차">반차</option>
        <option value="출장">출장</option>
    </select>

    <label for="startDate">시작일</label>
    <input type="date" name="startDate" id="startDate" required/>

    <label for="endDate">종료일</label>
    <input type="date" name="endDate" id="endDate" required/>

    <button type="submit">휴가 등록</button>
</form>

<c:if test="${not empty vacations}">
    <h3 style="text-align:center;">휴가 목록</h3>
    <table>
        <thead>
            <tr>
                <th>휴가 ID</th>
                <th>직원 ID</th>
                <th>휴가 종류</th>
                <th>시작일</th>
                <th>종료일</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="v" items="${vacations}">
                <tr>
                    <td>${v.leaveId}</td>
                    <td>${v.employeeId}</td>
                    <td>${v.leaveType}</td>
                    <td>${v.startDate}</td>
                    <td>${v.endDate}</td>
                    <td>
			            <form method="post" action="/vacation/delete" style="display:inline;">
			                <!-- ✅ CSRF 토큰 포함 -->
			                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			                <input type="hidden" name="leaveId" value="${v.leaveId}" />
			                <input type="hidden" name="employeeId" value="${v.employeeId}" />
			                <button type="submit" onclick="return confirm('삭제하시겠습니까?');">삭제</button>
			            </form>
			        </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>

</body>
</html>
