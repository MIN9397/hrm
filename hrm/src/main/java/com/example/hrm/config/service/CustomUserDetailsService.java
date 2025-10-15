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
		System.out.println("============ 로그인 : " + id );
		// 사번|id로 전달된 파라메터를 분리
		String[] userInfo = id.split("\\|");
		
		String emp_id = userInfo[0];
		String user_id = userInfo[1];
		System.out.println("============ emp_id " + emp_id );
		System.out.println("============ user_id " + user_id );
		
		// 데이터 베이스로 부터 사용자의 정보를 조회
		UserDto u = mapper.findById(emp_id, user_id);
		u.setId(id);
		// 사용자 권한 조회
		List<RoleDto> roles = mapper.findAuthoritiesByUsername(emp_id);
		// 사용자 권한 세팅
		u.setRoles(roles);
		
		System.out.println("============ 로그인사용자 : " + u);
		
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
