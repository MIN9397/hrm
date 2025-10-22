package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hrm.dto.NoticeDto;

public interface NoticeMapper {

	@Insert("insert into notice(title, content, writer, issueDate2) values (#{title}, #{content}, '인사부', now())")
	int insert(@RequestParam String title, @RequestParam String content);
	
	@Select("SELECT * FROM  notice where notice_id = #{noticeId}")
	NoticeDto get(int noticeId);
	
    // 전체 리스트 조회 (페이징 적용)
    @Select("SELECT * " +
            "FROM notice " +
            "ORDER BY notice_id DESC " +
            "LIMIT #{start}, #{end}")
    List<NoticeDto> getList(@Param("start") int start, @Param("end") int end);
	
	
    // 전체 데이터 개수
    @Select("SELECT COUNT(*) FROM notice")
    int getTotalCount();

	
}
