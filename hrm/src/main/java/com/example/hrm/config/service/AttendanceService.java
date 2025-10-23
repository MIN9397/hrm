package com.example.hrm.config.service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.hrm.dto.AttendanceDto;
import com.example.hrm.dto.VacationDto;
import com.example.hrm.mapper.AttendanceMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AttendanceService {

	private final AttendanceMapper mapper;
	
	public List<AttendanceDto> getAttendance(int employeeId) {
        return mapper.getAttendanceByEmployeeId(employeeId);
    }
	
	
    @Transactional
    public void checkIn(int employeeId, int deptId) {
        AttendanceDto dto = new AttendanceDto();
        dto.setEmployeeId(employeeId);
        dto.setDeptId(deptId);
        dto.setWorkDate(LocalDate.now().toString());
        dto.setCheckInTime(LocalTime.now().withNano(0).toString());
        mapper.insertCheckIn(dto);
    }

    @Transactional
    public void checkOut(int employeeId) {
        AttendanceDto dto = new AttendanceDto();
        dto.setEmployeeId(employeeId);
        dto.setWorkDate(LocalDate.now().toString());
        dto.setCheckOutTime(LocalTime.now().withNano(0).toString());
        mapper.updateCheckOut(dto);
    }
	public List<AttendanceDto> getAllAttendance() {
        return mapper.getAllAttendance();
    }
	
	public void updateAttendance(AttendanceDto dto) {
	    mapper.updateAttendance(dto);
	}

}
