package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.hrm.dto.DepartmentDto;

@Mapper
public interface DepartmentMapper {
	List<DepartmentDto> findAllDepartments();
}
