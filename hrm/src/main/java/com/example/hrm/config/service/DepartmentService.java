package com.example.hrm.config.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.hrm.dto.DepartmentDto;
import com.example.hrm.mapper.DepartmentMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DepartmentService {
	private final DepartmentMapper departmentMapper;

   /* public DepartmentService(DepartmentMapper departmentMapper) {
        this.departmentMapper = departmentMapper;
    }*/

    public List<DepartmentDto> getAllDepartments() {
        return departmentMapper.findAllDepartments();
    }
}
