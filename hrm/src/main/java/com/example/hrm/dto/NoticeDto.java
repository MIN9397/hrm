package com.example.hrm.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NoticeDto {

	private int notice_id   ;
	private int view_count  ;
	private String title       ;
	private String content     ;
	private String writer      ;
	private String created_at  ;
	
	
	
}
