package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.hrm.dto.UseracDto;

@Mapper
public interface UseracMapper {

	List<UseracDto> findAllUserac();
}
