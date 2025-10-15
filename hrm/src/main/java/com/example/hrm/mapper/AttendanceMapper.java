package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.hrm.dto.AttendanceDto;
import com.example.hrm.dto.VacationDto;


@Mapper
public interface AttendanceMapper {

	List<AttendanceDto> getAttendanceByEmployeeId(int employeeId);
	
	void insertVacation(VacationDto dto);

    // 직원별 휴가 목록 조회
    List<VacationDto> selectVacationByEmployeeId(int employeeId);
	
	List<AttendanceDto> getAllAttendance();
	
	// 휴가 삭제
	void deleteVacation(@Param("leaveId") int leaveId);
}
