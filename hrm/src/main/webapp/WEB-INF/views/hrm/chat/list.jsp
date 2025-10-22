<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<sec:authentication property="principal.employee_id" var="meEmployeeId"/>
<sec:authentication property="principal.username" var="meUsername"/>
<meta name="me-id" content="${meEmployeeId}"/>
<meta name="me-username" content="${meUsername}"/>

<title>채팅 목록</title>
<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet' />
<link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css' rel='stylesheet' />
<style>
.main-content {
  padding: 20px;
}

.chat-list-container {
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  padding: 20px;
  max-width: 900px;
}

.chat-item {
  padding: 15px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: background 0.2s;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.chat-item:hover {
  background: #f8f9fa;
}

.chat-item:last-child {
  border-bottom: none;
}

.chat-info {
  flex: 1;
}

.chat-title {
  font-weight: bold;
  font-size: 1.1rem;
  margin-bottom: 5px;
  color: #222;
}

.chat-preview {
  color: #666;
  font-size: 0.9rem;
}

.chat-meta {
  text-align: right;
}

.chat-time {
  color: #999;
  font-size: 0.8rem;
}

.unread-badge {
  background: #dc3545;
  color: white;
  border-radius: 10px;
  padding: 2px 8px;
  font-size: 0.75rem;
  margin-top: 5px;
  display: inline-block;
}

/* 오른쪽 사원목록 패널 */
#employeePanel {
  position: fixed;
  top: 100px;
  right: 20px;
  width: 360px;
  height: calc(100vh - 140px);
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.15);
  border: 1px solid #eee;
  display: none;
  overflow: hidden;
  z-index: 1040;
}
#employeePanel .panel-header {
  padding: 12px 16px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
#employeePanel .panel-body {
  height: calc(100% - 52px);
  display: flex;
  flex-direction: column;
}
#employeePanel .search-box {
  padding: 10px 12px;
  border-bottom: 1px solid #f1f1f1;
}
#employeePanel .list {
  flex: 1;
  overflow-y: auto;
  padding: 8px 12px;
}
.employee-item {
  padding: 10px 8px;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  border-radius: 8px;
}
.employee-item:hover {
  background: #f8f9fa;
}
.employee-name {
  font-weight: 600;
  color: #222;
}
.employee-dept {
  font-size: 0.85rem;
  color: #888;
}
</style>
</head>
<body>

<%@include file="/hrm/side.jsp" %>

<div class="main-content">
  <div class="chat-list-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2><i class="bi bi-chat-dots"></i> 채팅 목록</h2>
      <div>
        <button type="button" class="btn btn-primary" onclick="openNewChat()">
          <i class="bi bi-plus-circle"></i> 새 채팅 시작
        </button>
        <button type="button" class="btn btn-outline-primary ms-2" onclick="startDeptChat()">
          <i class="bi bi-people"></i> 팀 채팅방
        </button>
      </div>
    </div>
    <div id="chatList"></div>



<!-- 오른쪽 사원 목록 패널 -->
<div id="employeePanel" aria-hidden="true">
  <div class="panel-header">
    <strong><i class="bi bi-people"></i> 사원 선택</strong>
    <button class="btn btn-sm btn-outline-secondary" onclick="closeEmployeePanel()">
      닫기
    </button>
  </div>
  <div class="panel-body">
    <div class="search-box">
      <input type="text" id="empSearch" class="form-control form-control-sm" placeholder="이름/부서 검색" oninput="filterEmployees()">
    </div>
    <div class="list" id="employeeList">
      <!-- 사원 목록 -->
    </div>
  </div>
</div>

<script>
  let employeesCache = [];
  const ME_ID = document.querySelector('meta[name="me-id"]')?.getAttribute('content') || null;
  const ME_USERNAME = document.querySelector('meta[name="me-username"]')?.getAttribute('content') || null;

  window.addEventListener('DOMContentLoaded', loadChatList);

  function loadChatList() {
    console.log('채팅 목록 로딩 시작 - ME_ID:', ME_ID, 'ME_USERNAME:', ME_USERNAME);

    fetch('/chat/rooms')
      .then(r => {
        if (!r.ok) {
          throw new Error('HTTP ' + r.status);
        }
        return r.json();
      })
      .then(list => {
        console.log('받은 채팅방 목록:', list);

        const container = document.querySelector('#chatList');
        if (!container) return;

        if (!Array.isArray(list) || list.length === 0) {
          container.innerHTML = '<div class="text-muted small p-2">표시할 채팅방이 없습니다.</div>';
          return;
        }

        // 채팅방 타이틀(상대방 이름/부서명) 결정 로직
        const getChatTitle = function(r) {
          // 부서 전용 방: "DEPT-{id}: {부서명}" -> "{부서명}"만 표시
          if (r.roomName && r.roomName.startsWith('DEPT-')) {
            const idx = r.roomName.indexOf(':');
            return idx > -1 ? r.roomName.substring(idx + 1).trim() : r.roomName;
          }

          // 백엔드에서 직접 제공하는 partnerName 사용
          if (r.partnerName && r.partnerName !== '알 수 없음') {
            return r.partnerName;
          }

          if (r.partnerUsername) {
            return r.partnerUsername;
          }

          // 폴백: roomName에서 "DM" 제거
          if (r.roomName) {
            return r.roomName.replace(/^DM\s+\d+-\d+$/, '채팅방');
          }

          return '채팅방';
        };

        container.innerHTML = list.map(r => {
          const titleSafe = escapeHtml(getChatTitle(r));
          const lastMsg = r.lastMessage || '메시지 없음';
          const timeStr = r.updatedAt ? new Date(r.updatedAt).toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'}) : '';
          const roomHref = '/chat/room/' + encodeURIComponent(r.roomId);
          return (
            '<div class="chat-item" onclick="location.href=\'' + roomHref + '\'">' +
              '<div class="chat-info">' +
                '<div class="chat-title"><i class="bi bi-person"></i> ' + titleSafe + '</div>' +
                '<div class="chat-preview">' + escapeHtml(lastMsg) + '</div>' +
              '</div>' +
              '<div class="chat-meta">' +
                '<div class="chat-time">' + timeStr + '</div>' +
              '</div>' +
            '</div>'
          );
        }).join('');
      })
      .catch(err => {
        console.error('채팅방 로딩 실패:', err);
        const container = document.querySelector('#chatList');
        if (container) {
          container.innerHTML = '<div class="text-danger small p-2">채팅방을 불러오지 못했습니다. 오류: ' + err.message + '</div>';
        }
      });
  }

  function openNewChat() {
    const panel = document.getElementById('employeePanel');
    panel.style.display = 'block';
    if (employeesCache.length === 0) {
      loadEmployees();
    }
  }

  function closeEmployeePanel() {
    document.getElementById('employeePanel').style.display = 'none';
  }

  function loadEmployees() {
    fetch('/chat/employees')
      .then(r => r.json())
      .then(data => {
        employeesCache = Array.isArray(data) ? data : [];
        renderEmployees(employeesCache);
      })
      .catch(() => {
        document.getElementById('employeeList').innerHTML =
          '<div class="text-danger small p-2">사원 목록을 불러오지 못했습니다.</div>';
      });
  }

  function escapeHtml(s) {
    if (s == null) return '';
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function renderEmployees(list) {
    const box = document.getElementById('employeeList');
    if (!list || list.length === 0) {
      box.innerHTML = '<div class="text-muted small p-2">표시할 사원이 없습니다.</div>';
      return;
    }
    box.innerHTML = list.map(function(e) {
      var id = e.employeeId || '';
      var name = escapeHtml(e.username || '');
      var dept = escapeHtml(e.deptName || '');
      return '<div class="employee-item" onclick="startChat(\'' + id + '\')">' +
               '<div class="employee-name">' + name + '</div>' +
               '<div class="employee-dept">' + dept + '</div>' +
             '</div>';
    }).join('');
  }

  function filterEmployees() {
    const q = (document.getElementById('empSearch').value || '').toLowerCase();
    const filtered = employeesCache.filter(e =>
      (e.username || '').toLowerCase().includes(q) ||
      (e.deptName || '').toLowerCase().includes(q)
    );
    renderEmployees(filtered);
  }

  function startChat(targetEmployeeId) {
    const token = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
    const header = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';

    fetch('/chat/room/new', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
        [header]: token || ''
      },
      body: new URLSearchParams({ targetEmployeeId })
    })
    .then(r => r.json())
    .then(({ roomId }) => {
      if (roomId) {
        location.href = '/chat/room/' + encodeURIComponent(roomId);
      } else {
        alert('채팅방 생성에 실패했습니다.');
      }
    })
    .catch(() => alert('채팅방 생성 중 오류가 발생했습니다.'));
  }

  // 팀(부서) 채팅방 생성/접속
  function startDeptChat() {
    const token = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
    const header = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';

    fetch('/chat/room/dept/new', {
      method: 'POST',
      headers: {
        [header]: token || ''
      }
    })
    .then(r => {
      if (!r.ok) throw new Error('HTTP ' + r.status);
      return r.json();
    })
    .then(({ roomId, error }) => {
      if (error) {
        alert('권한이 없습니다. 다시 로그인해주세요.');
        return;
      }
      if (roomId) {
        location.href = '/chat/room/' + encodeURIComponent(roomId);
      } else {
        alert('부서 채팅방 생성에 실패했습니다.');
      }
    })
    .catch(() => alert('부서 채팅방 생성 중 오류가 발생했습니다.'));
  }
</script>

</body>
</html>