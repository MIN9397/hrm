package com.example.hrm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.hrm.config.service.AttendanceService;
import com.example.hrm.config.service.DepartmentService;
import com.example.hrm.config.service.UseracService;
import com.example.hrm.config.service.VacationService;
import com.example.hrm.dto.AttendanceDto;
import com.example.hrm.dto.DepartmentDto;
import com.example.hrm.dto.UseracDto;
import com.example.hrm.dto.VacationDto;


import lombok.RequiredArgsConstructor;
@Controller
@RequiredArgsConstructor
public class AttendanceController {

	private final AttendanceService service;
	private final VacationService vacationService;
	private final DepartmentService departmentService;
	private final UseracService useracService;
	
	@GetMapping("/attendance/view")
	public String viewAttendancePage() {
	    return "/hrm/attendance"; // /WEB-INF/views/attendance.jsp
	}

	@GetMapping("/vacation/page")
    public String showVacationCalendarPage(Model model) {
		
        return "/hrm/vacation";
    }
	
	
	// 휴가 등록 처리
    @PostMapping("/vacation/save")
    public String saveVacation(@ModelAttribute VacationDto dto, Model model) {
        vacationService.saveVacation(dto);
        List<VacationDto> vacations = vacationService.getVacationList(dto.getEmployeeId());
        model.addAttribute("vacations", vacations);
        model.addAttribute("employeeId", dto.getEmployeeId());
        return "/hrm/vacation";
    }
    
    @PostMapping("/vacation/delete")
    public String deleteVacation(@RequestParam("leaveId") int leaveId,
                                 @RequestParam("employeeId") int employeeId,
                                 Model model) {

        vacationService.deleteVacation(leaveId);

        // 삭제 후 다시 리스트 조회
        List<VacationDto> vacations = vacationService.getVacationList(employeeId);
        model.addAttribute("vacations", vacations);
        model.addAttribute("employeeId", employeeId);

        return "/hrm/vacation";
    }


    /* 휴가 목록 조회
    
    @GetMapping("/api/vacation/list")
    @ResponseBody
    public List<Map<String, Object>> getVacationList(@RequestParam(required = false) Integer employeeId) {
        if (employeeId == null) return new ArrayList<>();
        return service.getVacationList(employeeId);
    }
    */
	
	@GetMapping("/api/attendance/jsp")
	public String getAttendanceForJsp(@RequestParam(value = "employeeId", required = false) Integer employeeId, Model model) {
	    List<AttendanceDto> attendanceList = new ArrayList<>();
	    
	    if(employeeId != null) {
	    		attendanceList = service.getAttendance(employeeId);
	    
	    for (AttendanceDto att : attendanceList) {
	    	if (att != null) {
	        System.out.println("날짜: " + att.getWorkDate());
	        System.out.println("출근: " + att.getCheckInTime());
	        System.out.println("퇴근: " + att.getCheckOutTime());
	        System.out.println("부서: " + att.getDeptId());
	    }else {
	    	System.out.println("att is null");
	    }
	    }
	    }else {
	        System.out.println("⚠ employeeId가 전달되지 않았습니다. 전체 조회 또는 빈 리스트 반환합니다.");
	    }
	    
	    model.addAttribute("employeeId", employeeId); // 추가
	    model.addAttribute("attendanceList", attendanceList);
	  
	    return "/hrm/attendance"; // JSP 렌더링
	}
	@ResponseBody
    @GetMapping("/api/attendance/list")
    public List<Map<String, Object>> getAttendanceList(@RequestParam(required = false) Integer employeeId) {

        List<AttendanceDto> attendanceList;

        if (employeeId != null) {
            attendanceList = service.getAttendance(employeeId);
        } else {
            // employeeId가 없을 경우 전체 조회
            attendanceList = service.getAllAttendance();
        }

        List<Map<String, Object>> events = new ArrayList<>();

        for (AttendanceDto att : attendanceList) {
            if (att.getCheckInTime() != null) {
                Map<String, Object> checkIn = new HashMap<>();
                checkIn.put("title", "출근");
                checkIn.put("start", att.getWorkDate() + "T" + att.getCheckInTime());
                checkIn.put("color", "#4CAF50");
                events.add(checkIn);
            }

            if (att.getCheckOutTime() != null) {
                Map<String, Object> checkOut = new HashMap<>();
                checkOut.put("title", "퇴근");
                checkOut.put("start", att.getWorkDate() + "T" + att.getCheckOutTime());
                checkOut.put("color", "#F44336");
                events.add(checkOut);
            }
        }

        List<VacationDto> vList = service.getVacationList(employeeId);
        for (VacationDto v : vList) {
            Map<String, Object> e = new HashMap<>();
            e.put("title", v.getLeaveType());
            e.put("start", v.getStartDate().toString());
            e.put("end", v.getEndDate().toString());
            events.add(e);
        }
        return events;

    }
	@GetMapping("/vacation/list")
	public String viewVacationList(@RequestParam(required = false) Integer employeeId, Model model) {

	    // 값이 없을 경우 대비
	    if (employeeId == null) {
	        model.addAttribute("error", "직원 ID가 입력되지 않았습니다.");
	        return "/hrm/vacation";
	    }

	    List<VacationDto> vacations = vacationService.getVacationList(employeeId);
	    model.addAttribute("employeeId", employeeId);
	    model.addAttribute("vacations", vacations);
	    return "/hrm/vacation";
	}

	
	

    @GetMapping("/api/departments")
    @ResponseBody
    public List<DepartmentDto> getDepartments() {
    	System.out.println("test:"+departmentService.getAllDepartments());
        return departmentService.getAllDepartments();  // or mock data for now
    }
    @GetMapping("/api/userac")
    @ResponseBody
    public List<UseracDto> getUserac(){
    	System.out.println("test:" + useracService.getAllUserac());
    	return useracService.getAllUserac();
    }
	


	
}
