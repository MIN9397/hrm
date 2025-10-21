package com.example.hrm.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.hrm.dto.AttendanceDto;


@Mapper
public interface AttendanceMapper {

	int insertCheckIn(AttendanceDto dto);
    int updateCheckOut(AttendanceDto dto);
	List<AttendanceDto> getAttendanceByEmployeeId(Integer employeeId);
	
	
	
	List<AttendanceDto> getAllAttendance();
	
	
}
