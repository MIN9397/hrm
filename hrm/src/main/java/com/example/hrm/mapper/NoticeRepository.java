package com.example.hrm.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class NoticeRepository {

    private final JdbcTemplate jdbc;

    // notice 테이블에서 title 목록 조회 (기본 상위 N개)
    public List<String> findRecentTitles(int limit) {
        String sql = "SELECT title FROM notice LIMIT ?";
        return jdbc.query(sql, (rs, i) -> rs.getString("title"), limit);
    }
}
