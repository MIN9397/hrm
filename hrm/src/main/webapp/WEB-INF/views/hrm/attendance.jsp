<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>근태 관리 시스템</title>

    <!-- FullCalendar -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/main.min.css" rel="stylesheet"/>

    <style>
        body {
            font-family: "Pretendard", sans-serif;
            margin: 40px;
            background: #fafafa;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        form {
            text-align: center;
            margin-bottom: 30px;
        }
        input, button {
            padding: 6px 10px;
            font-size: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        #calendar {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            padding: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
    </style>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const calendarEl = document.getElementById("calendar");
            const input = document.getElementById("employeeId");
            const btn = document.getElementById("searchBtn");

            // FullCalendar 초기화
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                locale: "ko",
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: ""
                },
                events: []
            });

            calendar.render();

            // 근태 데이터 로드 (비동기)
            async function loadAttendance(employeeId) {
                if (!employeeId) {
                    alert("직원 ID를 입력하세요.");
                    return;
                }

                console.log("[loadAttendance] 요청 ID:", employeeId);

                try {
                    const response = await fetch(`/api/attendance/list?employeeId=\${encodeURIComponent(employeeId)}`);
                    if (!response.ok) throw new Error("HTTP " + response.status);
                    const data = await response.json();

                    console.log("[loadAttendance] 응답 데이터:", data);

                    calendar.removeAllEvents();
                    calendar.addEventSource(data);

                } catch (error) {
                    console.error("근태 데이터 로드 실패:", error);
                    alert("데이터를 불러오는 중 오류가 발생했습니다.");
                }
            }

            // 조회 버튼 클릭 시 캘린더만 갱신
            btn.addEventListener("click", function () {
                const employeeId = input.value.trim();
                loadAttendance(employeeId);
            });

            // Enter 키로도 조회 가능
            input.addEventListener("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    btn.click();
                }
            });

            // JSP에서 employeeId가 넘어온 경우 자동 로드
            const defaultId = "<c:out value='${employeeId}' />";
            if (defaultId) {
                input.value = defaultId;
                loadAttendance(defaultId);
            }
        });
    </script>
</head>

<body>
    <h2>근태 관리 시스템</h2>

    <!-- form 대신 비동기 버튼으로 처리 -->
    <div style="text-align:center; margin-bottom:30px;">
        <label>직원 ID: </label>
        <input type="number" id="employeeId" name="employeeId" required value="${employeeId}"/>
        <button type="button" id="searchBtn">조회</button>
    </div>

    <div id="calendar"></div>
</body>
</html>
