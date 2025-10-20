package com.example.hrm.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UploadDto {

	private int file_id      ;
	private String board_id  ;
	private int board_seq    ;
	private int attach_idx   ;
	private String orig_name    ;
	private String stored_name  ;
	private String rel_path     ;
	private String content_type ;
	private long file_size    	;
	private String user_id      ;
	private String created_at   ;
	
}
