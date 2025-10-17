package com.example.hrm.dto;

import lombok.Data;

import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class DepartmentDto {

	private int deptId;
	private String deptName;
	private Integer parentId;
}
	


