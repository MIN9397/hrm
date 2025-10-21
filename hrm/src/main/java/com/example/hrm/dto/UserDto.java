package com.example.hrm.dto;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.CredentialsContainer;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.Data;

@Data
public class UserDto implements UserDetails, CredentialsContainer {
    private String employee_id;    // 내부 식별용 (기존)
    private String employee_code;  // 로그인 ID
    private String username;       // 표시용 이름
    private String email;          // 사용자 이메일 (발신자 주소로 사용)
    private String password;
    private boolean enabled;
    private String job_id;
    private String dept_id;
    private String role_id;

	private List<RoleDto> roles;

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return roles != null ? roles : java.util.Collections.emptyList();
	}

	@Override
	public String getPassword() {
		return password;
	}

	@Override
	public String getUsername() {
		// 인증에 사용하는 식별자
		return employee_code;
	}

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return enabled;
    }

	@Override
	public void eraseCredentials() {
		this.password = "";
	}
}
