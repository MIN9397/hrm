package com.example.hrm.config.service;

import com.example.hrm.dto.ScheduleVO;

import java.util.List;

public interface IScheduleService {
    List<ScheduleVO> selectScheduleList();
    void insertSchedule(ScheduleVO vo);
}
