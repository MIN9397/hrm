package com.example.hrm.dto;

import java.time.LocalDate;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class VacationDto {

	private int employeeId;
    private String leaveType;
    private String startDate;
    private String endDate;
    private int leaveId;
}
