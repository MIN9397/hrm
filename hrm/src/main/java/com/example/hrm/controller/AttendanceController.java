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

	@GetMapping("/vacation")
	public String vacationPage(
            @AuthenticationPrincipal UserDetails user,
            @RequestParam(value = "employeeId", required = false) Integer employeeId,
            Model model) {

        if (user == null) return "redirect:/login";

        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int loginEmployeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());

        List<VacationDto> vacations = new ArrayList<>();

        // ✅ 관리자면: 검색용 employeeId가 있으면 해당 직원 조회, 없으면 전체
        if (deptId == 1) {
            if (employeeId != null) {
                vacations = vacationService.getVacationList(employeeId);
            } else {
                vacations = vacationService.getAllVacations();
            }
        }
        // ✅ 일반직원이면: 자기 것만 조회
        else {
            employeeId = loginEmployeeId;
            vacations = vacationService.getVacationList(loginEmployeeId);
        }

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
        return "redirect:/vacation";
    }
    @PostMapping("/vacation/approve")
    public String approveVacation(@RequestParam("leaveId") int leaveId) {
        vacationService.updateVacationStatus(leaveId, "승인");
        return "redirect:/vacation";
    }
    @PostMapping("/vacation/reject")
    public String rejectVacation(@RequestParam("leaveId") int leaveId) {
        vacationService.updateVacationStatus(leaveId, "반려");
        return "redirect:/vacation";
    }
    @PostMapping("/vacation/delete")
    public String deleteVacation(
            @RequestParam("leaveId") int leaveId,
            @AuthenticationPrincipal UserDetails user) {

        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());

        // ✅ 관리자면 전체 삭제 가능, 일반직원은 본인 것만 삭제 가능
        if (deptId == 1) {
            vacationService.deleteVacation(leaveId);
        } else {
            // 본인 소유 휴가만 삭제하도록 검증
            VacationDto vacation = vacationService.getVacationById(leaveId);
            if (vacation != null && vacation.getEmployeeId() == employeeId) {
                vacationService.deleteVacation(leaveId);
            } else {
                throw new IllegalStateException("권한이 없습니다.");
            }
        }

        return "redirect:/vacation";
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
	public String getAttendanceForJsp(
			@AuthenticationPrincipal UserDetails user,
			@RequestParam(value = "employeeId", required = false) Integer employeeId, Model model) {
		// ✅ 로그인 정보 가져오기
	    UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
	    int loginEmployeeId = Integer.parseInt(userInfo.getEmployeeId());
	    int deptId = Integer.parseInt(userInfo.getDeptId());

	    // ✅ 관리자(deptId == 1)는 선택한 직원ID 조회 가능, 아니면 본인 ID 고정
	    if (deptId != 1) {
	        employeeId = loginEmployeeId;
	    } else if (employeeId == null) {
	        // 관리자가 처음 접속했을 때는 자신의 ID로 기본 표시
	        employeeId = loginEmployeeId;
	    }

	    // ✅ 근태 정보 조회
	    List<AttendanceDto> attendanceList = service.getAttendance(employeeId);

	    // ✅ JSP로 값 전달
	    model.addAttribute("employeeId", employeeId);
	    model.addAttribute("deptId", deptId);
	    model.addAttribute("username", userInfo.getUsername());
	    model.addAttribute("attendanceList", attendanceList);

	    System.out.println("✅ 로그인 사용자 employeeId = " + loginEmployeeId);
	    System.out.println("✅ 로그인 사용자 deptId = " + deptId);
	    System.out.println("✅ 조회할 employeeId = " + employeeId);

	    return "/hrm/attendance"; // JSP
	}
	@ResponseBody
    @GetMapping("/api/attendance/list")
    public List<Map<String, Object>> getAttendanceList(
    		@AuthenticationPrincipal UserDetails user,
    		@RequestParam(required = false) Integer employeeId) {

		UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
	    int loginEmployeeId = Integer.parseInt(userInfo.getEmployeeId());
	    int deptId = Integer.parseInt(userInfo.getDeptId());

	    // ✅ 일반직원은 자기 것만 볼 수 있음
	    if (deptId != 1) {
	        employeeId = loginEmployeeId;
	    }
		
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
     // ✅ 휴가 일정 추가 (자기 휴가만)
        List<VacationDto> vacationList = vacationService.getVacationList(employeeId);
        for (VacationDto v : vacationList) {
            Map<String, Object> e = new HashMap<>();
            e.put("title", v.getLeaveType() + " (" + v.getStatus() + ")"); // ✅ 상태(승인/반려/대기) 표시
            e.put("start", v.getStartDate());
            e.put("end", v.getEndDate());
            e.put("color", "#2196F3");
            events.add(e);
        }
        return events;

    }
	/** 출퇴근 페이지 (로그인 유저 기반) */
    @GetMapping("/check")
    public String attendancePage(@AuthenticationPrincipal UserDetails user, @RequestParam(value = "employeeId", required = false) Integer employeeId,
            Model model) {
        if (user == null) {
            return "redirect:/login";
        }

        // 로그인된 사용자 정보 조회
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        System.out.println("✅ 로그인된 사원 코드: " + user.getUsername());
        System.out.println("✅ DB 조회 결과 employeeId: " + userInfo.getEmployeeId());
        System.out.println("✅ DB 조회 결과 deptId: " + userInfo.getDeptId());
        int loginEmployeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());

        // 근태 기록 불러오기
        List<AttendanceDto> attendanceList = new ArrayList<>();

        // ✅ 관리자면 모든 직원 근태 즉시 조회
        if (deptId == 1) {
            if (employeeId != null) {
                attendanceList = service.getAttendance(employeeId);
            } else {
                attendanceList = service.getAllAttendance(); // 전체 조회
            }
        } 
        // ✅ 일반 직원이면 본인 것만 조회
        else {
            employeeId = loginEmployeeId;
            attendanceList = service.getAttendance(loginEmployeeId);
        }

        model.addAttribute("attendanceList", attendanceList);
        model.addAttribute("employeeId", employeeId);
        model.addAttribute("deptId", deptId);
        model.addAttribute("username", userInfo.getUsername());

        return "/hrm/check"; // JSP
    }

    /** 출근 버튼 */
    @PostMapping("/attendance/checkin")
    public String checkIn(@AuthenticationPrincipal UserDetails user) {
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        int deptId = Integer.parseInt(userInfo.getDeptId());
        service.checkIn(employeeId, deptId);
        return "redirect:/check";
    }

    @PostMapping("/attendance/checkout")
    public String checkOut(@AuthenticationPrincipal UserDetails user) {
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int employeeId = Integer.parseInt(userInfo.getEmployeeId());
        service.checkOut(employeeId);
        return "redirect:/check";
    }
    
    @PostMapping("/attendance/update")
    public String updateAttendance(@AuthenticationPrincipal UserDetails user, AttendanceDto dto) {
        UserDto userInfo = loginMapper.findByEmployeeCode(user.getUsername());
        int deptId = Integer.parseInt(userInfo.getDeptId());

        if (deptId != 1) {
            throw new IllegalStateException("관리자 권한이 없습니다.");
        }

        service.updateAttendance(dto);
        return "redirect:/check";
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
