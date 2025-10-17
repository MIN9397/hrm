package com.example.hrm.mapper;

import com.example.hrm.dto.ScheduleVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IScheduleMapper {
    List<ScheduleVO> selectScheduleList();
    void insertSchedule(ScheduleVO vo);
}
