package com.example.hrm.config.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.hrm.dto.VacationDto;
import com.example.hrm.mapper.AttendanceMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VacationService {
    private final AttendanceMapper vacationMapper;

    public List<VacationDto> getVacationList(Integer employeeId) {
    	if (employeeId == null) { return new ArrayList<>();}
        return vacationMapper.selectVacationByEmployeeId(employeeId);
    }

    public void saveVacation(VacationDto dto) {
        vacationMapper.insertVacation(dto);
    }
    public void deleteVacation(int leaveId) {
        vacationMapper.deleteVacation(leaveId);
    }

}

