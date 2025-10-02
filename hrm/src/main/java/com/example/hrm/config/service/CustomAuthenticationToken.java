package com.example.hrm.config.service;

import java.util.Collection;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

public class CustomAuthenticationToken extends UsernamePasswordAuthenticationToken {
    
    private final String empno; // 사번
    
    public CustomAuthenticationToken(String username, String password, String empno) {
        super(username, password);
        this.empno = empno;
    }
    
    public CustomAuthenticationToken(String username, String password, String empno,
                                     Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
        this.empno = empno;
    }
    
    public String getEmployeeNumber() {
        return empno;
    }
}
