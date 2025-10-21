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
      <div>
        <h4 class="mb-0"><i class="bi bi-chat-dots"></i> 채팅방 ${roomId}</h4>
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
  
  function connect() {
    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);
    
    stompClient.connect({}, function(frame) {
      console.log('Connected: ' + frame);
      
      stompClient.subscribe('/topic/chat', function(message) {
        const chatMessage = JSON.parse(message.body);
        showMessage(chatMessage);
      });
      
      // 입장 메시지
      const joinMessage = {
        type: 'JOIN',
        sender: '${me.username}' || '사용자',
        content: '님이 입장하셨습니다.'
      };
      stompClient.send("/app/chat.send", {}, JSON.stringify(joinMessage));
    });
  }
  
  function sendMessage() {
    const input = document.getElementById('messageInput');
    const content = input.value.trim();
    
    if (content && stompClient) {
      const message = {
        type: 'CHAT',
        content: content,
        sender: '${me.username}' || '사용자'
      };
      
      stompClient.send("/app/chat.send", {}, JSON.stringify(message));
      input.value = '';
    }
  }
  
  function showMessage(message) {
    const messagesDiv = document.getElementById('chatMessages');
    const messageDiv = document.createElement('div');
    messageDiv.className = 'message';
    
    const currentUser = '${me.username}' || '사용자';
    if (message.sender === currentUser) {
      messageDiv.classList.add('mine');
    }
    
    if (message.type === 'JOIN' || message.type === 'LEAVE') {
      messageDiv.innerHTML = `
        <div style="text-align: center; color: #999; font-size: 0.85rem;">
          ${message.sender} ${message.content}
        </div>
      `;
    } else {
      messageDiv.innerHTML = `
        <div class="message-sender">${message.sender}</div>
        <div class="message-content">${message.content}</div>
      `;
    }
    
    messagesDiv.appendChild(messageDiv);
    messagesDiv.scrollTop = messagesDiv.scrollHeight;
  }
  
  // Enter 키로 전송
  document.addEventListener('DOMContentLoaded', function() {
    connect();
    
    document.getElementById('messageInput').addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        sendMessage();
      }
    });
  });
  
  // 페이지 나갈 때 퇴장 메시지
  window.addEventListener('beforeunload', function() {
    if (stompClient) {
      const leaveMessage = {
        type: 'LEAVE',
        sender: '${me.username}' || '사용자',
        content: '님이 퇴장하셨습니다.'
      };
      stompClient.send("/app/chat.send", {}, JSON.stringify(leaveMessage));
    }
  });
</script>

</body>
</html>