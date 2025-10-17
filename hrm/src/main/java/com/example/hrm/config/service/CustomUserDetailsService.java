package com.example.hrm.config.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.example.hrm.dto.RoleDto;
import com.example.hrm.dto.UserDto;
import com.example.hrm.mapper.LoginMapper;


public class CustomUserDetailsService implements UserDetailsService{

	@Autowired
	LoginMapper mapper;
	
	@Override
	public UserDetails loadUserByUsername(String employee_code) throws UsernameNotFoundException {
        System.out.println("로그인 시도:"+employee_code);

        UserDto user= mapper.findByEmployeeCode(employee_code);
        if(user==null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다:"+employee_code);
        }

        if (!user.isEnabled()) {
            // ✅ 비활성화된 계정
            throw new org.springframework.security.authentication.DisabledException("계정이 비활성화되었습니다: " + employee_code);
        }

		// 사용자 권한 조회
		List<RoleDto> roles = mapper.findAuthoritiesByEmployeeCode(employee_code);
		if (roles == null) {
			roles = java.util.Collections.emptyList();
		}
		// 사용자 권한 세팅
		user.setRoles(roles);
		
		System.out.println("============ 로그인사용자 : " + user);
		return user;
		
	}

}
