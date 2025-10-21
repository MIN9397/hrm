<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
</style>
</head>
<body>

<%@include file="/hrm/side.jsp" %>

<div class="main-content">
  <div class="chat-list-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2><i class="bi bi-chat-dots"></i> 채팅 목록</h2>
      <a href="/chat/new" class="btn btn-primary">
        <i class="bi bi-plus-circle"></i> 새 채팅 시작
      </a>
    </div>
    
    <!-- 채팅방 목록 -->
    <div class="chat-item" onclick="location.href='/chat/room/1'">
      <div class="chat-info">
        <div class="chat-title"><i class="bi bi-megaphone"></i> 전체 공지방</div>
        <div class="chat-preview">회의는 3시에 시작합니다.</div>
      </div>
      <div class="chat-meta">
        <div class="chat-time">오후 2:30</div>
        <span class="unread-badge">3</span>
      </div>
    </div>
    
    <div class="chat-item" onclick="location.href='/chat/room/2'">
      <div class="chat-info">
        <div class="chat-title"><i class="bi bi-people"></i> 개발팀 채팅방</div>
        <div class="chat-preview">오늘 배포 일정 확인 부탁드립니다.</div>
      </div>
      <div class="chat-meta">
        <div class="chat-time">오후 1:15</div>
        <span class="unread-badge">7</span>
      </div>
    </div>
    
    <div class="chat-item" onclick="location.href='/chat/room/3'">
      <div class="chat-info">
        <div class="chat-title"><i class="bi bi-people"></i> 인사팀 채팅방</div>
        <div class="chat-preview">신입사원 교육 자료 공유드립니다.</div>
      </div>
      <div class="chat-meta">
        <div class="chat-time">오전 11:20</div>
        <span class="unread-badge">1</span>
      </div>
    </div>
    
    <div class="chat-item" onclick="location.href='/chat/room/4'">
      <div class="chat-info">
        <div class="chat-title"><i class="bi bi-folder"></i> 프로젝트 A팀</div>
        <div class="chat-preview">일정 조율이 필요합니다.</div>
      </div>
      <div class="chat-meta">
        <div class="chat-time">오전 9:00</div>
      </div>
    </div>
    
    <div class="chat-item" onclick="location.href='/chat/room/5'">
      <div class="chat-info">
        <div class="chat-title"><i class="bi bi-people"></i> 마케팅팀</div>
        <div class="chat-preview">다음주 캠페인 관련 회의 일정입니다.</div>
      </div>
      <div class="chat-meta">
        <div class="chat-time">어제</div>
      </div>
    </div>
  </div>
</div>

</body>
</html>