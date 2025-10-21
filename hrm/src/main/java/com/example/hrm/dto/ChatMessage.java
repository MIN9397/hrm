package com.example.hrm.dto;

import lombok.Data;

@Data
public class ChatMessage {
    private String type;     // CHAT, JOIN, LEAVE 등
    private String sender;   // 보낸 사람
    private String content;  // 내용
    private String timestamp; // ISO 문자열
}
