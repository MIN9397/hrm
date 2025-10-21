package com.example.hrm.mapper;

import com.example.hrm.dto.ScheduleVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IScheduleMapper {
    List<ScheduleVO> selectScheduleList(@Param("employeeId") int employeeId);
    void insertSchedule(ScheduleVO vo);
    void updateSchedule(ScheduleVO vo);
    int deleteSchedule(@Param("no") int no, @Param("employeeId") int employeeId);
}
