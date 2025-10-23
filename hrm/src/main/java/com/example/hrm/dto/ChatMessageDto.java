package com.example.hrm.dto;

import lombok.Data;

import java.sql.Timestamp;
import java.time.LocalDateTime;

@Data
public class ChatMessageDto {
    private Integer messageId;
    private Integer roomId;
    private Long senderId;
    private String message;
    private LocalDateTime createdAt;
}