package com.example.hrm.config.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.hrm.dto.VacationDto;
import com.example.hrm.mapper.VacationMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VacationService {
    private final VacationMapper vacationMapper;

    public List<VacationDto> getVacationList(int employeeId) {
        return vacationMapper.getVacation(employeeId);
    }

    public void insertVacation(VacationDto dto) {
        vacationMapper.insertVacation(dto);
    }
    
    public void updateVacationStatus(int leaveId, String status) {
        Map<String, Object> param = new HashMap<>();
        param.put("leaveId", leaveId);
        param.put("status", status);
        vacationMapper.updateVacationStatus(param);
    }
    
    public void deleteVacation(int leaveId) {
        vacationMapper.deleteVacation(leaveId);
    }
    
    public List<VacationDto> getAllVacations() {
        return vacationMapper.getAllVacations(null);
    }

}

