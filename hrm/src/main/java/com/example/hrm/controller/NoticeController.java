package com.example.hrm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hrm.dto.NoticeDto;
import com.example.hrm.mapper.NoticeMapper;


@Controller
public class NoticeController {
	@Autowired
	NoticeMapper noticeMapper;
	
	@GetMapping("/notice")
    public String list(@RequestParam(defaultValue = "1") int page, Model model) {
        int pageSize = 10; // 한 페이지에 보여줄 개수
        int start = (page - 1) * pageSize;
        int end = page * pageSize;

        List<NoticeDto> list = noticeMapper.getList(start, end);
        System.out.println(list); // 상세 출력
        // ✅ 리스트 사이즈 출력 (여기!)
        System.out.println("list size = " + list.size());
        for (NoticeDto dto : list) {
            System.out.println(dto); // 상세 출력
        }
        
        int totalCount = noticeMapper.getTotalCount();
        int totalPages = (int)Math.ceil((double)totalCount / pageSize);

        model.addAttribute("list", list);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
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
