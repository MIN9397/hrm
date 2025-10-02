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
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		System.out.println(id);
		// 데이터 베이스로 부터 사용자의 정보를 조회
		UserDto u = mapper.findById(id);
		// 사용자 권한 조회
		List<RoleDto> authorities = mapper.findAuthoritiesByUsername(id);
		// 사용자 권한 세팅
		u.setAuthorities(authorities);
		
		System.out.println("=================" + u);
		
		/*
		UserDetails userDetails = User.builder()
				.username(username)
				// 사용자가 입력한 username에 해당하는 정보를 조회
				.password("$2a$10$3MK8N58SDf4DsDYvE583NOaWwbvtf2.WMfeRHn79TvvqtNXTuN8Ey")
				.roles("USER")
				.build();
		*/
		return u;
		
	}

}
