package com.example.hrm.controller;

import java.net.Authenticator;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class HelloController {
	
	@org.springframework.beans.factory.annotation.Autowired
	private com.example.hrm.config.service.EmployeeService employeeService;

	@org.springframework.beans.factory.annotation.Autowired
	private com.example.hrm.config.service.NoticeService noticeService;

	@GetMapping("/")
	private String index() {
		System.out.println("=======================test");
		return "/hrm/login";
	}
	
	@GetMapping("/salarylist")
	private String salarylist() {
		return "/hrm/salarylist";
	}
	
	@GetMapping("/va")
	private String va() {
		return "/hrm/va";
	}
	
	@GetMapping("/test1")
	private String test1() {
		return "/hrm/test1";
	}
	
	@GetMapping("/main")
	private String main(org.springframework.security.core.Authentication auth, org.springframework.ui.Model model) {
		System.out.println("=======================auth :" + auth);
        System.out.println("=======================user :" + auth.getPrincipal());
        if (auth != null && auth.getPrincipal() instanceof com.example.hrm.dto.UserDto u) {
			String employeeId = String.valueOf(u.getEmployeeId());
			if (employeeId != null) {
				com.example.hrm.dto.EmployeeDto me = employeeService.getEmployeeById(employeeId);
				if (me != null) {
					model.addAttribute("me", me);
					model.addAttribute("imgVersion", System.currentTimeMillis());
				}
			}
		}
        else {
            return "redirect:/login";
        }
		// 공지사항 타이틀 목록 주입(충분히 많이 가져오고, 화면에서 박스 높이에 맞춰 출력)
		model.addAttribute("noticeTitles", noticeService.getRecentTitles(50));
		return "/hrm/main";
	}
	/*@GetMapping("/vacation")
	private String vacation() {
		return "/hrm/vacation";
	}*/
	@GetMapping("/attendance")
	private String attendance() {
		return "/hrm/attendance";
	}
	/*@GetMapping("/check")
	private String check() {
		return "/hrm/check";
	}*/
	@GetMapping("/department")
	private String department() {
		return "/hrm/department";
	}
	@GetMapping("/userac")
	private String user() {
		return "/hrm/userac";
	}
	

	
	@GetMapping("/login")
	private String login() {
		System.out.println("=======================test");
		return "/hrm/login";
	}
	

}
