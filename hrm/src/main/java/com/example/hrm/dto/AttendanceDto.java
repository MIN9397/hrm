package com.example.hrm.dto;

import java.time.LocalDate;
import java.time.LocalTime;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class AttendanceDto {
	private int employeeId;
    private int deptId;
    private String workDate;
    private String checkInTime;
    private String checkOutTime;
    private int attendanceId;
}
