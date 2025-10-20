package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.hrm.dto.UploadDto;




public interface UploadMapper {
	
	int insertUpload(UploadDto dto);
	
	// 매개변수가 2개 이상인경우 @param 속성을 지정 해야함!
	//List<UploadDto> selectList(SearchDto search);

	//int getTotalCnt(SearchDto search);

	UploadDto getFile(UploadDto dto);
	
	int getSeq();
	
	
	
	@Update("""
			 UPDATE my_sequence
			 SET current_value = LAST_INSERT_ID(current_value + 1)
			 WHERE name = 'seq_test'
    """)
	int updateSeq();
	
	
    @Select("SELECT LAST_INSERT_ID()")
    int selectSeq();
	

}
