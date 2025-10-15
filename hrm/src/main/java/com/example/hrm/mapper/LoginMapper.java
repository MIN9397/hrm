package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.hrm.dto.RoleDto;
import com.example.hrm.dto.UserDto;

public interface LoginMapper {
	@Select("select user_id, password, employee_id, enabled from user_account where employee_id=#{employee_id} and user_id = #{user_id}")
	UserDto findById(@Param(value = "employee_id") String employee_id,@Param(value = "user_id")  String user_id);

	@Select("select ur.role_id, role_name from user_role ur, role r where ur.role_id = r.role_id and  employee_id = 1")
	List<RoleDto> findAuthoritiesByUsername(String username);
	
	@Insert("insert into users values (#{username}, #{password}, #{enable})")
	int insert(UserDto user);
}
