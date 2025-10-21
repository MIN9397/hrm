package com.example.hrm.dto;

import lombok.Data;

import com.example.hrm.config.jackson.LocalDateTimeFlexDeserializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.time.LocalDateTime;

@Data
public class ScheduleVO {
    private int no;
    private int employeeId;
    private String title;

    @JsonDeserialize(using = LocalDateTimeFlexDeserializer.class)
    private LocalDateTime start; // 기존 LocalDate -> LocalDateTime

    @JsonDeserialize(using = LocalDateTimeFlexDeserializer.class)
    private LocalDateTime end;   // 기존 LocalDate -> LocalDateTime

    private String backgroundColor;
    private String textColor;
    private String allDayStatus;
    private boolean allDay;
}
