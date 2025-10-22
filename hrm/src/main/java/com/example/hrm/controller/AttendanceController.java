package com.example.hrm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.hrm.config.service.AttendanceService;
import com.example.hrm.config.service.DepartmentService;
import com.example.hrm.config.service.UseracService;
import com.example.hrm.config.service.VacationService;
import com.example.hrm.dto.AttendanceDto;
import com.example.hrm.dto.DepartmentDto;
import com.example.hrm.dto.UserDto;
import com.example.hrm.dto.UseracDto;
import com.example.hrm.dto.VacationDto;
import com.example.hrm.mapper.LoginMapper;

import lombok.RequiredArgsConstructor;
@Controller
@RequiredArgsConstructor
public class AttendanceController {

	private final AttendanceService service;
	private final VacationService vacationService;
	private final DepartmentService departmentService;
	private final UseracService useracService;
	private final LoginMapper loginMapper;
	
	@GetMapping("/attendance/view")
	public String viewAttendancePage() {
	    return "/hrm/attendance"; // /WEB-INF/views/attendance.jsp
	}

	@GetMapping("/vacation/page")
	public String vacationPage(@AuthenticationPrincipal UserDetails user, Model model) {
        if (user == null) {
            return "redirect:/login";
        }

        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());

        // 본인 또는 전체 목록
        List<VacationDto> vacations = (deptId == 1)
                ? vacationService.getAllVacations() // 관리자: 전체 휴가 조회
                : vacationService.getVacationList(employeeId); // 일반직원: 본인만

        model.addAttribute("employeeId", employeeId);
        model.addAttribute("deptId", deptId);
        model.addAttribute("vacations", vacations);
        model.addAttribute("username", userInfo.getUsername());

        return "/hrm/vacation"; // JSP
    }
	// 휴가 등록 처리
    @PostMapping("/vacation/save")
    public String saveVacation(@AuthenticationPrincipal UserDetails user, VacationDto vacation) {
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());

        // ⚠️ 일반직원은 자기 아이디로만 저장되도록 강제
        if (deptId != 1) {
            vacation.setEmployeeId(employeeId);
        }

        vacationService.insertVacation(vacation);
        return "redirect:/vacation/page";
    }
    @PostMapping("/vacation/approve")
    public String approveVacation(@RequestParam("leaveId") int leaveId) {
        vacationService.updateVacationStatus(leaveId, "승인");
        return "redirect:/vacation/page";
    }
    @PostMapping("/vacation/reject")
    public String rejectVacation(@RequestParam("leaveId") int leaveId) {
        vacationService.updateVacationStatus(leaveId, "반려");
        return "redirect:/vacation/page";
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

		List<AttendanceDto> attendanceList = (employeeId != null)
                ? service.getAttendance(employeeId)
                : service.getAllAttendance();
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

        List<VacationDto> vList = vacationService.getVacationList(0);
        for (VacationDto v : vList) {
            Map<String, Object> e = new HashMap<>();
            e.put("title", v.getLeaveType());
            e.put("start", v.getStartDate().toString());
            e.put("end", v.getEndDate().toString());
            events.add(e);
        }
        return events;

    }
	/** 출퇴근 페이지 (로그인 유저 기반) */
    @GetMapping("/attendance/page")
    public String attendancePage(@AuthenticationPrincipal UserDetails user, Model model) {
        if (user == null) {
            return "redirect:/login";
        }

        // 로그인된 사용자 정보 조회
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        System.out.println("✅ 로그인된 사원 코드: " + user.getUsername());
        System.out.println("✅ DB 조회 결과 employeeId: " + userInfo.getEmployeeId());
        System.out.println("✅ DB 조회 결과 deptId: " + userInfo.getDeptId());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());

        // 근태 기록 불러오기
        List<AttendanceDto> attendanceList = service.getAttendance(employeeId);
        model.addAttribute("attendanceList", attendanceList);
        model.addAttribute("employeeId", employeeId);
        model.addAttribute("deptId", deptId);
        model.addAttribute("username", userInfo.getUsername());

        return "/hrm/check"; // JSP 경로
    }

    /** 출근 버튼 */
    @PostMapping("/attendance/checkin")
    public String checkIn(@AuthenticationPrincipal UserDetails user) {
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());
        service.checkIn(employeeId, deptId);
        return "redirect:/attendance/page";
    }

    @PostMapping("/attendance/checkout")
    public String checkOut(@AuthenticationPrincipal UserDetails user) {
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        service.checkOut(employeeId);
        return "redirect:/attendance/page";
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
