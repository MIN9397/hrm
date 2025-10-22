package com.example.hrm.dto;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NoticeDto {

	private int noticeId   ;
	private int view_count  ;
	private String title       ;
	private String content     ;
	private String writer      ;
	private String created_at  ;
	private LocalDate issueDate2;
	
	
	
}
