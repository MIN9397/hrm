package com.example.hrm.controller;

import com.example.hrm.config.service.IScheduleService;
import com.example.hrm.dto.ScheduleVO;
import com.example.hrm.dto.UserDto;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
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
    public List<ScheduleVO> scheduleList(Authentication auth) {
        UserDto user = (UserDto) auth.getPrincipal();
        int employeeId = Integer.parseInt(user.getEmployee_id());
        return service.selectScheduleList(employeeId);
    }

    @ResponseBody
    @PostMapping("/scheduleInsert.do")
    public ResponseEntity<String> insertSchedule(@RequestBody ScheduleVO vo, Authentication auth){
        // 로그인한 사용자 정보에서 employeeId 가져오기
        UserDto user = (UserDto) auth.getPrincipal();
        vo.setEmployeeId(Integer.parseInt(user.getEmployee_id()));

        service.insertSchedule(vo);
        return new ResponseEntity<>("success", HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/scheduleUpdate.do")
    public ResponseEntity<String> updateSchedule(@RequestBody ScheduleVO vo, Authentication auth) {
        UserDto user = (UserDto) auth.getPrincipal();
        vo.setEmployeeId(Integer.parseInt(user.getEmployee_id()));
        service.updateSchedule(vo);
        return new ResponseEntity<>("success", HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/scheduleDelete.do")
    public ResponseEntity<String> deleteSchedule(@RequestBody Map<String, Integer> payload, Authentication auth) {
        UserDto user = (UserDto) auth.getPrincipal();
        int employeeId = Integer.parseInt(user.getEmployee_id());
        int no = payload.get("no");
        service.deleteSchedule(no, employeeId);
        return new ResponseEntity<>("success", HttpStatus.OK);
    }

}
