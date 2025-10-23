package com.example.hrm.config.service;

import com.example.hrm.mapper.NoticeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NoticeRepository noticeRepository;

    // 최근 공지 제목 리스트 조회 (limit는 1~50 범위로 제한)
    public List<String> getRecentTitles(int limit) {
        int lim = (limit <= 0 || limit > 50) ? 5 : limit;
        return noticeRepository.findRecentTitles(lim);
    }
}
