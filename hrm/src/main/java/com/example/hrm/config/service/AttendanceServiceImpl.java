package com.example.hrm.config.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.hrm.dto.AttendanceDto;
import com.example.hrm.mapper.AttendanceMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AttendanceServiceImpl {
	private final AttendanceMapper mapper;

    public List<AttendanceDto> getAttendance(int employeeId) {
        return mapper.getAttendanceByEmployeeId(employeeId);
    }

    public List<AttendanceDto> getAllAttendance() {
        return mapper.getAllAttendance();
    }
}
