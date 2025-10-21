<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>채팅방</title>
<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet' />
<link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css' rel='stylesheet' />
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<style>
.main-content {
  padding: 20px;
}

.chat-container {
  background: #fff;
  border-radius: 12px;
  box-shadow: 2px 2px 12px rgba(0,0,0,0.1);
  height: calc(100vh - 150px);
  max-height: 700px;
  display: flex;
  flex-direction: column;
  max-width: 1000px;
}

.chat-header {
  padding: 20px;
  border-bottom: 2px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: #f8f9fa;
}

.message {
  margin-bottom: 15px;
  clear: both;
}

.message-sender {
  font-weight: bold;
  margin-bottom: 5px;
  font-size: 0.85rem;
  color: #555;
}

.message-content {
  background: #fff;
  padding: 10px 15px;
  border-radius: 12px;
  display: inline-block;
  max-width: 70%;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.message.mine {
  text-align: right;
}

.message.mine .message-content {
  background: #007bff;
  color: white;
}

.message.mine .message-sender {
  text-align: right;
}

.chat-input-area {
  padding: 20px;
  border-top: 2px solid #eee;
  display: flex;
  gap: 10px;
  background: #fff;
}

.chat-input-area input {
  flex: 1;
  border-radius: 20px;
  padding: 10px 20px;
}

.chat-input-area button {
  border-radius: 20px;
  padding: 10px 25px;
}
</style>
</head>
<body>

<%@include file="/hrm/side.jsp" %>

<div class="main-content">
  <div class="chat-container">
    <div class="chat-header">
      <div class="d-flex align-items-center gap-2">
        <h4 class="mb-0"><i class="bi bi-chat-dots"></i> <span id="roomTitle">채팅방 ${roomName}</span></h4>
        <button type="button" class="btn btn-sm btn-outline-primary" onclick="renameRoom()">
          <i class="bi bi-pencil-square"></i> 이름 변경
        </button>
      </div>
      <a href="/chat/list" class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-list"></i> 목록으로
      </a>
    </div>
    
    <div class="chat-messages" id="chatMessages">
      <!-- 메시지가 여기 표시됩니다 -->
    </div>
    
    <div class="chat-input-area">
      <input type="text" id="messageInput" class="form-control" placeholder="메시지를 입력하세요..." />
      <button onclick="sendMessage()" class="btn btn-primary">
        <i class="bi bi-send"></i> 전송
      </button>
    </div>
  </div>
</div>

<script>
  let stompClient = null;
  // 로그인 사용자 ID (없으면 null)
  const CURRENT_USER_ID = Number('${empty me ? "" : me.employee_id}') || null;
  // 현재 채팅방 ID - 안전하게 정수 파싱
  const ROOM_ID = parseInt('${roomId}', 10);

  // URL 안전 생성 헬퍼
  function buildUrl(...parts) {
    return parts
      .map(part => String(part).replace(/^\/+|\/+$/g, ''))
      .filter(part => part.length > 0)
      .join('/');
  }

  window.addEventListener('DOMContentLoaded', function() {
    if (!ROOM_ID || isNaN(ROOM_ID) || ROOM_ID <= 0) {
      alert('유효하지 않은 채팅방입니다.');
      window.location.href = '/chat/list';
      return;
    }
    // 기존 메시지 히스토리 먼저 로드
    try { loadHistory(); } catch (e) { console.error('Failed to load history:', e); }
    // STOMP 연결
    try { connect(); } catch (e) { console.error('Failed to connect STOMP:', e); }
  });

  function connect() {
    const socket = new SockJS('/ws-stomp');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function(frame) {
      console.log('Connected: ' + frame);

      // 방별 topic 구독
      stompClient.subscribe('/topic/chat/' + ROOM_ID, function(message) {
        const chatMessage = JSON.parse(message.body);
        showMessage(chatMessage);
      });
    });
  }

  function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const messageContent = messageInput.value.trim();
    
    if (!messageContent) {
      alert('메시지를 입력해주세요.');
      return;
    }

    // 서버 DTO(ChatMessageDto)에 맞춘 필드만 전송
    const message = {
      roomId: ROOM_ID,
      message: messageContent
    };

    if (stompClient && stompClient.connected) {
      stompClient.send("/app/chat.send", {}, JSON.stringify(message));
      messageInput.value = '';
    } else {
      alert('서버와의 연결이 끊어졌습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  // 채팅방 메시지 히스토리 로드
  function loadHistory() {
    const url = '/' + buildUrl('chat', 'room', ROOM_ID, 'messages');
    fetch(url)
      .then(res => {
        if (!res.ok) throw new Error('failed to load history: ' + res.status);
        return res.json();
      })
      .then(list => {
        if (Array.isArray(list)) {
          list.forEach(msg => showMessage(msg));
        }
      })
      .catch(err => console.error('메시지 기록 로드 실패:', err));
  }

  // 채팅방 이름 변경
  function renameRoom() {
    const titleEl = document.getElementById('roomTitle');
    const currentName = titleEl ? titleEl.textContent.trim() : '';
    const newName = prompt('채팅방 이름을 입력하세요.', currentName);
    if (!newName || !newName.trim()) return;

    const token = document.querySelector('meta[name="_csrf"]').getAttribute('content');
    const header = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

    const url = '/' + buildUrl('chat', 'room', ROOM_ID, 'rename');
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        [header]: token
      },
      body: JSON.stringify({ roomName: newName.trim() })
    })
    .then(res => {
      if (!res.ok) throw new Error('rename failed');
      return res.json().catch(() => ({ success: true }));
    })
    .then((data) => {
      if (!data || data.success !== false) {
        if (titleEl) titleEl.textContent = newName.trim();
      } else {
        alert(data.message || '이름 변경에 실패했습니다.');
      }
    })
    .catch(() => alert('이름 변경에 실패했습니다.'));
  }

  // 페이지 이탈 시 안전하게 연결 종료
  window.addEventListener('beforeunload', function() {
    if (stompClient && stompClient.connected) {
      try {
        stompClient.disconnect(function() {});
      } catch (e) {
        // ignore
      }
    }
  });

  // 수신 메시지 표시 (간단 렌더링)
  function showMessage(msg) {
    const box = document.getElementById('chatMessages');
    if (!box) return;

    const isMine = (CURRENT_USER_ID != null) && (Number(msg && msg.senderId) === Number(CURRENT_USER_ID));

    const wrap = document.createElement('div');
    wrap.className = 'message' + (isMine ? ' mine' : '');

    const content = document.createElement('div');
    content.className = 'message-content';
    content.textContent = msg && msg.message ? String(msg.message) : '';

    wrap.appendChild(content);
    box.appendChild(wrap);
    box.scrollTop = box.scrollHeight;
  }
</script>

</body>
</html>