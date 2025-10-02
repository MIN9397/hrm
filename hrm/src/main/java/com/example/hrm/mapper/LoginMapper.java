package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.example.hrm.dto.RoleDto;
import com.example.hrm.dto.UserDto;

public interface LoginMapper {
	@Select("select username id, password pw, enabled enable from users where username = #{username}")
	UserDto findById(String username);

	@Select("select authority from authorities where username = #{username}")
	List<RoleDto> findAuthoritiesByUsername(String username);
	
	@Insert("insert into users values (#{username}, #{password}, #{enable})")
	int insert(UserDto user);
}
