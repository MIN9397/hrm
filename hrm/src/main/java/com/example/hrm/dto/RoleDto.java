package com.example.hrm.dto;

import org.springframework.security.core.GrantedAuthority;

import lombok.Data;

@Data
public class RoleDto implements GrantedAuthority {
    private String roleId;
    private String roleName;

    @Override
    public String getAuthority() {
        return roleName; // 예: "ROLE_ADMIN"
    }
}