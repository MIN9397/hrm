package com.example.hrm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HelloController {
	@GetMapping("/")
	private String index() {
		System.out.println("=======================test");
		return "/main";
	}
}
