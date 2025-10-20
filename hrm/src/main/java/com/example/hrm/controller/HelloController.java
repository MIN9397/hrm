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

	@GetMapping("/")
	private String index() {
		System.out.println("=======================test");
		return "/hrm/login";
	}
	
	@GetMapping("/test1")
	private String test1() {
		return "/hrm/test1";
	}
	
	@GetMapping("/main")
	private String main(org.springframework.security.core.Authentication auth, org.springframework.ui.Model model) {
		if (auth != null && auth.getPrincipal() instanceof com.example.hrm.dto.UserDto u) {
			String employeeId = u.getEmployee_id();
			if (employeeId != null) {
				com.example.hrm.dto.EmployeeDto me = employeeService.getEmployeeById(employeeId);
				if (me != null) {
					model.addAttribute("me", me);
					model.addAttribute("imgVersion", System.currentTimeMillis());
				}
			}
		}
		return "/hrm/main";
	}
	
	@GetMapping("/login")
	private String login() {
		System.out.println("=======================test");
		return "/hrm/login";
	}
	
	// 로그인 성공시 세션에 로그인 정보를 저장
	@GetMapping("/login-success")
	private String loginsuccess(@AuthenticationPrincipal UserDetails user, HttpSession session) {
		System.out.println("user : " + user);
		session.setAttribute("user", user);
		return "redirect:/main";
	}
	
}
