package com.example.hrm.dto;

import lombok.Data;

@Data
public class UseracDto {

	private String userName;
	private int jobId;
	private int deptId;
	private int roleId;
	private int managerId;
	private String img;
	private int employeeId;
	private String jobTitle;
}
