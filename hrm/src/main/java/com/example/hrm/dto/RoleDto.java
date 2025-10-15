package com.example.hrm.dto;

import org.springframework.security.core.GrantedAuthority;

import lombok.Data;

@Data
public class RoleDto implements GrantedAuthority{

	private String role_id;
	private String role_name;
	
	@Override
	public String getAuthority() {
		return role_name;
	}

}
