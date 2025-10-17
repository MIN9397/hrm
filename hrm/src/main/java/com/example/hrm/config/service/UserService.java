package com.example.hrm.config.service;

import com.example.hrm.dto.UserDto;
import com.example.hrm.mapper.LoginMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private LoginMapper mapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // 회원 등록
    public void registerUser(String username, String rawPassword, Long roleId) {
        // 비밀번호 암호화
        String encodedPw = passwordEncoder.encode(rawPassword);

        UserDto user = new UserDto();
        user.setUsername(username);
        user.setPassword(encodedPw);

    }
}
