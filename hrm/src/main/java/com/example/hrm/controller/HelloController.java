package com.example.hrm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HelloController {
	
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
	private String login() {
		return "/hrm/main";
	}
	

	
}
