package com.example.hrm.mapper;

import com.example.hrm.dto.ChatMessageDto;
import com.example.hrm.dto.ChatRoomDto;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ChatRepository {

    private final JdbcTemplate jdbc;

    // 채팅방 생성
    public int insertRoom(String roomName, Long createdBy) {
        String sql = "INSERT INTO chat_rooms (room_name, created_by, created_at, updated_at) VALUES (?, ?, NOW(), NOW())";
        jdbc.update(sql, roomName, createdBy);
        return jdbc.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
    }

    // 멤버 추가
    public void insertMember(Integer roomId, Long employeeId) {
        String sql = "INSERT INTO chat_members (room_id, employee_id, joined_at) VALUES (?, ?, NOW())";
        jdbc.update(sql, roomId, employeeId);
    }

    // 사원이 속한 채팅방 목록
    public List<ChatRoomDto> findRoomsByEmployee(Long employeeId) {
        String sql = """
            SELECT r.room_id, r.room_name, r.created_by, r.created_at, r.updated_at
            FROM chat_rooms r
            JOIN chat_members m ON r.room_id = m.room_id
            WHERE m.employee_id = ?
            ORDER BY r.updated_at DESC
        """;
        return jdbc.query(sql, (rs, rowNum) -> {
            ChatRoomDto dto = new ChatRoomDto();
            dto.setRoomId(rs.getInt("room_id"));
            dto.setRoomName(rs.getString("room_name"));
            dto.setCreatedBy(rs.getLong("created_by"));
            dto.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            dto.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return dto;
        }, employeeId);
    }

    // 마지막 메시지 조회
    public String findLastMessage(Integer roomId) {
        String sql = "SELECT message FROM chat_messages WHERE room_id = ? ORDER BY created_at DESC LIMIT 1";
        List<String> list = jdbc.queryForList(sql, String.class, roomId);
        return list.isEmpty() ? "" : list.get(0);
    }

    // 메시지 저장
    public void insertMessage(ChatMessageDto message) {
        String sql = "INSERT INTO chat_messages (room_id, sender_id, message, created_at) VALUES (?, ?, ?, ?)";
        jdbc.update(sql, message.getRoomId(), message.getSenderId(), message.getMessage(), Timestamp.valueOf(message.getCreatedAt()));
    }


    // 채팅방 이름 변경
    public void updateRoomName(Integer roomId, String roomName) {
        String sql = "UPDATE chat_rooms SET room_name = ?, updated_at = NOW() WHERE room_id = ?";
        jdbc.update(sql, roomName, roomId);
    }

    // 특정 방의 메시지 목록 조회 (오래된 순)
    public List<ChatMessageDto> findMessagesByRoom(Integer roomId, int limit) {
        String sql = "SELECT message_id, room_id, sender_id, message, created_at " +
                     "FROM chat_messages WHERE room_id = ? ORDER BY created_at ASC LIMIT ?";
        return jdbc.query(sql, (rs, rowNum) -> {
            ChatMessageDto dto = new ChatMessageDto();
            dto.setMessageId(rs.getInt("message_id"));
            dto.setRoomId(rs.getInt("room_id"));
            dto.setSenderId(rs.getLong("sender_id"));
            dto.setMessage(rs.getString("message"));
            dto.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            return dto;
        }, roomId, limit);
    }

    public List<ChatMessageDto> findMessagesByRoom(Integer roomId) {
        return findMessagesByRoom(roomId, 200); // 기본 200개
    }

    // room_id로 채팅방 조회
    public ChatRoomDto findRoomById(Integer roomId) {
        String sql = "SELECT room_id, room_name, created_by, created_at, updated_at FROM chat_rooms WHERE room_id = ?";
        List<ChatRoomDto> list = jdbc.query(sql, (rs, rowNum) -> {
            ChatRoomDto dto = new ChatRoomDto();
            dto.setRoomId(rs.getInt("room_id"));
            dto.setRoomName(rs.getString("room_name"));
            dto.setCreatedBy(rs.getLong("created_by"));
            dto.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            dto.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return dto;
        }, roomId);
        return list.isEmpty() ? null : list.get(0);
    }
}
