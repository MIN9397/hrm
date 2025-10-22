package com.example.hrm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.hrm.dto.NoticeDto;
import com.example.hrm.mapper.NoticeMapper;


@Controller
public class NoticeController {
	@Autowired
	NoticeMapper noticeMapper;
	
	@GetMapping("/notice")
	public String getMethodName(Model model) {
		List<NoticeDto> list= noticeMapper.getList();
		model.addAttribute("list", list);
		// 공지사항 목록 조회
		return "/hrm/notice";
				
	}
	@GetMapping("/notice/detail")
	public String detail(Model model, NoticeDto noticeDto) {
		NoticeDto dto= noticeMapper.get(noticeDto.getNoticeId());
		model.addAttribute("dto", dto);
		// 공지사항 목록 조회
		return "/hrm/notice_detail";
				
	}
	@GetMapping("/notice/insert")
	public String insert(Model model) {
		
		// 공 지사항 목록 조회
		return "/hrm/notice_insert";
				
	}
	
	@PostMapping("/notice/save")
	public String insertAction(Model model, NoticeDto noticeDto) {
		noticeMapper.insert(noticeDto.getTitle(),noticeDto.getContent());
		// 공지사항 목록 조회
		return "redirect:/notice";
				
	}
}
