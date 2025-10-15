package com.example.hrm.config.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

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
	
	public void saveVacation(VacationDto dto) {
        mapper.insertVacation(dto);
    }

    public List<VacationDto> getVacationList(int employeeId) {
        return mapper.selectVacationByEmployeeId(employeeId);
        

    }
	public List<AttendanceDto> getAllAttendance() {
        return mapper.getAllAttendance();
    }
	

}
