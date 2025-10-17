package com.example.hrm.controller;

import com.example.hrm.config.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    // 회원가입 API (테스트용)
    @PostMapping("/register")
    public String register(
            @RequestParam String username,
            @RequestParam String password
    ) {
        // 기본 ROLE_USER만 부여되도록 서버 측에서 고정
        userService.registerUser(username, password, 1L);
        return "회원가입 성공";
    }
}
