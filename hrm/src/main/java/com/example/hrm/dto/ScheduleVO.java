package com.example.hrm.dto;

import lombok.Data;

@Data
public class ScheduleVO {
    private int no;
    private String id;
    private String title;
    private String start;
    private String end;
    private String backgroundColor;
    private String textColor;
    private String allDayStatus;
    private boolean allDay;
}
