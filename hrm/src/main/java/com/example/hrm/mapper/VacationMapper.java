package com.example.hrm.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.hrm.dto.VacationDto;

@Mapper
public interface VacationMapper {
	void insertVacation(VacationDto dto);

    // 직원별 휴가 목록 조회
    List<VacationDto> getVacation(Integer employeeId);
 // 휴가 삭제
 	void deleteVacation(@Param("leaveId") int leaveId);
 	void updateVacationStatus(Map<String, Object> param);

	List<VacationDto> getAllVacations(Integer employeeId);
}
