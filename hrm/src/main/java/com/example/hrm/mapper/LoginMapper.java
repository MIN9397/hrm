package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.hrm.dto.RoleDto;
import com.example.hrm.dto.UserDto;

@Mapper
public interface LoginMapper {

    @Select("""
        SELECT employee_id, employee_code, username, email, password, enabled, job_id, dept_id, role_id
        FROM user_account
        WHERE employee_code = #{employee_code}
    """)
    UserDto findByEmployeeCode(@Param("employee_code") String employee_code);

    @Select("""
        SELECT r.role_id, r.role_name
        FROM role r
        JOIN user_account ur ON ur.role_id = r.role_id
        WHERE ur.employee_code = #{employee_code}
    """)
    List<RoleDto> findAuthoritiesByEmployeeCode(@Param("employee_code") String employee_code);
}
