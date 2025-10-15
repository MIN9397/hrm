package com.example.hrm.dto;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.CredentialsContainer;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.Data;

@Data
public class UserDto implements UserDetails, CredentialsContainer {
	private String id;
	private String user_id;
	private String password;
	private String employee_id;
	
	private int enable;
	
	private List<RoleDto> roles;
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return roles;
	}

	@Override
	public String getPassword() {
		// TODO Auto-generated method stub
		return password;
	}

	@Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return id;
	}


	// CredentialsContainer를 구현 함으로써 사용자의 민감한 정보를 제거 할수 있다!
	@Override
	public void eraseCredentials() {
		this.password = "";
		
	}

}
