package com.example.hrm.config.service;

import com.example.hrm.dto.ScheduleVO;

import java.util.List;

public interface IScheduleService {
    List<ScheduleVO> selectScheduleList(int employeeId);
    void insertSchedule(ScheduleVO vo);
    void updateSchedule(ScheduleVO vo);
    void deleteSchedule(int no, int employeeId);
}
