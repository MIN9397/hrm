package com.example.hrm.config.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.hrm.dto.UseracDto;
import com.example.hrm.mapper.UseracMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UseracService {

	private final UseracMapper mapper;
	
	public List<UseracDto>getAllUserac(){
		return mapper.findAllUserac();
	}
}
