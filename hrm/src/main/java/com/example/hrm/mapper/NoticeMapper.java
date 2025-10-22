package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hrm.dto.NoticeDto;

public interface NoticeMapper {

	@Insert("insert into notice(title, content, writer) values (#{title}, #{content}, 'admin')")
	int insert(@RequestParam String title, @RequestParam String content);
	
	List<NoticeDto> get();
	
	@Select("SELECT * FROM  notice")
	public List<NoticeDto> getList();

	
}
