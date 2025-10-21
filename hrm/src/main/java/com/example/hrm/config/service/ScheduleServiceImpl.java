package com.example.hrm.config.service;

import com.example.hrm.dto.ScheduleVO;
import com.example.hrm.mapper.IScheduleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ScheduleServiceImpl implements IScheduleService{
    @Autowired
    private IScheduleMapper mapper;

    @Override
    public List<ScheduleVO> selectScheduleList(int employeeId){
        List<ScheduleVO> list = mapper.selectScheduleList(employeeId);
        changeAllDayStatus(list);
        return list;
    }

    @Override
    public void insertSchedule(ScheduleVO vo){
        mapper.insertSchedule(vo);
    }

    @Override
    public void updateSchedule(ScheduleVO vo) {
        mapper.updateSchedule(vo);
    }

    @Override
    public void deleteSchedule(int no, int employeeId) {
        mapper.deleteSchedule(no, employeeId);
    }

    public void changeAllDayStatus(List<ScheduleVO> list){
        //일정 목록에서 일정 꺼내기
        for (ScheduleVO schedule : list) {
            String status = schedule.getAllDayStatus(); //하루종일 상태 값 꺼내기
            if (status.equals("FALSE")) {
                schedule.setAllDay(false);
                continue;
            }
            schedule.setAllDay(true);
        }
    }
}
