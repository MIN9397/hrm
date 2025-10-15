<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}">
	<meta name="_csrf_header" content="${_csrf.headerName}">
    
    <title>근태 및 휴가 관리 시스템</title>

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
        input, button, select {
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

        /* 휴가 등록 모달 */
        #leaveModal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 9999; 
        }
        #leaveModal .modal-content {
            background: white;
            padding: 20px;
            border-radius: 8px;
            width: 300px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        #leaveModal select, #leaveModal button {
            margin-top: 10px;
            width: 80%;
        }
    </style>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const calendarEl = document.getElementById("calendar");
            const form = document.getElementById("searchForm");
            const input = document.getElementById("employeeId");
            const modal = document.getElementById("leaveModal");
            const leaveSelect = document.getElementById("leaveType");
            const confirmBtn = document.getElementById("confirmLeave");
            const cancelBtn = document.getElementById("cancelLeave");

            let selectedDate = null;

            // FullCalendar 초기화
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                locale: "ko",
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: ""
                },
                events: [],
                dateClick: function(info) {
                    const employeeId = input.value.trim();
                    if (!employeeId) {
                        alert("직원 ID를 먼저 입력해주세요.");
                        return;
                    }
                    selectedDate = info.dateStr;
                    modal.style.display = "flex";
                }
            });

            calendar.render();

         // 휴가 등록
            confirmBtn.addEventListener("click", async () => {
                const employeeId = input.value.trim();
                const leaveType = leaveSelect.value;
                if (!employeeId || !leaveType) return;

                try {
                    // ✅ JSP에 추가된 CSRF 메타태그에서 토큰 가져오기
                    const token = document.querySelector('meta[name="_csrf"]').getAttribute('content');
                    const header = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

                    const response = await fetch("/api/vacation/save", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                            [header]: token  // ✅ CSRF 토큰 추가!
                        },
                        body: JSON.stringify({
                            employeeId: employeeId,
                            leaveType: leaveType,
                            startDate: selectedDate,
                            endDate: selectedDate
                        })
                    });

                    if (!response.ok) throw new Error("HTTP " + response.status);
                    alert("휴가가 등록되었습니다.");

                    modal.style.display = "none";
                    loadAllEvents(employeeId); // 근태+휴가 다시 로드

                } catch (error) {
                    console.error("휴가 저장 실패:", error);
                    alert("휴가 등록 중 오류가 발생했습니다.");
                }
            });

            // 취소 버튼
            cancelBtn.addEventListener("click", () => {
                modal.style.display = "none";
            });


            // 근태 + 휴가 이벤트 통합 로드
            async function loadAllEvents(employeeId) {
                if (!employeeId) return;
                try {
                    const [attRes, vacRes] = await Promise.all([
                        fetch(`/api/attendance/list?employeeId=${employeeId}`),
                        fetch(`/api/vacation/list?employeeId=${employeeId}`)
                    ]);

                    const attendanceData = await attRes.json();
                    const vacationData = await vacRes.json();

                    // 근태 + 휴가 데이터 병합
                    const allEvents = [
                        ...attendanceData, 
                        ...vacationData.map(v => ({
                            title: v.leaveType,
                            start: v.startDate,
                            end: new Date(new Date(v.endDate).getTime() + 86400000).toISOString().split("T")[0],
                            color: "#4c8bf5"
                        }))
                    ];

                    calendar.removeAllEvents();
                    calendar.addEventSource(allEvents);

                } catch (error) {
                    console.error("이벤트 로드 실패:", error);
                }
            }

            // 직원 조회 버튼
            form.addEventListener("submit", function (e) {
                e.preventDefault();
                const employeeId = input.value.trim();
                if (employeeId) {
                    loadAllEvents(employeeId);
                }
            });

            // JSP에서 employeeId 전달받았을 때 자동 조회
            const defaultId = "<c:out value='${employeeId}' />";
            if (defaultId) {
                input.value = defaultId;
                loadAllEvents(defaultId);
            }
        });
    </script>
</head>

<body>
    <h2>근태 및 휴가 관리 시스템</h2>

    <form id="searchForm" method="get" action="#">
        <label>직원 ID: </label>
        <input type="number" id="employeeId" name="employeeId" required value="${employeeId}"/>
        <button type="submit">조회</button>
    </form>

    <div id="calendar"></div>

    <!-- 휴가 종류 선택 모달 -->
    <div id="leaveModal">
        <div class="modal-content">
            <h3>휴가 종류 선택</h3>
            <select id="leaveType">
                <option value="">-- 선택하세요 --</option>
                <option value="연차">연차</option>
                <option value="병가">병가</option>
                <option value="반차">반차</option>
                <option value="출장">출장</option>
            </select><br/>
            <button id="confirmLeave">등록</button>
            <button id="cancelLeave" style="background-color: #ccc; color:black;">취소</button>
        </div>
    </div>
</body>
</html>
