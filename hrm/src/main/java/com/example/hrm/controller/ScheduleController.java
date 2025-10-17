package com.example.hrm.controller;

import com.example.hrm.config.service.IScheduleService;
import com.example.hrm.dto.ScheduleVO;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class ScheduleController {

    @Autowired
    private IScheduleService service;

    @GetMapping("/schedule.do")
    public String schedulePage() {
        return "schedule";
    }

    @ResponseBody
    @GetMapping("/scheduleList.do")
    public List<ScheduleVO> scheduleList() {
        return service.selectScheduleList();
    }

    @ResponseBody
    @PostMapping("/scheduleInsert.do")
    public ResponseEntity<String> insertSchedule(@RequestBody ScheduleVO vo){
        service.insertSchedule(vo);
        return new ResponseEntity<>("success", HttpStatus.OK);
    }
}
