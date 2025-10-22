package com.example.hrm.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatRoomDto {
    private Integer roomId;
    private String roomName;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}