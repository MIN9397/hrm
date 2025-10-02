package com.example.hrm.dto;

import org.springframework.security.core.GrantedAuthority;

import lombok.Data;

@Data
public class RoleDto implements GrantedAuthority{

	private String authority;
	
	@Override
	public String getAuthority() {
		return authority;
	}

}
