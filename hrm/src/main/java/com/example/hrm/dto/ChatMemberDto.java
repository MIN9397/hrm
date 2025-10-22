package com.example.hrm.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatMemberDto {
    private Integer roomId;
    private Long employeeId;
    private LocalDateTime joinedAt;
}