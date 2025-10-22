package com.example.hrm.config.service;

import com.example.hrm.dto.ChatMessageDto;
import com.example.hrm.dto.ChatRoomDto;
import com.example.hrm.mapper.ChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository chatRepo;

    // 1:1 DM 채팅방 생성
    public Integer createRoom(Long myId, Long targetId) {
        // 이미 존재하는 DM 방 체크 (생략 가능)
        String roomName = "DM " + Math.min(myId, targetId) + "-" + Math.max(myId, targetId);
        int roomId = chatRepo.insertRoom(roomName, myId);
        chatRepo.insertMember(roomId, myId);
        chatRepo.insertMember(roomId, targetId);
        return roomId;
    }

    // 사원이 속한 방 목록
    public List<Map<String, Object>> getRoomList(Long employeeId) {
        List<ChatRoomDto> rooms = chatRepo.findRoomsByEmployee(employeeId);
        return rooms.stream().map(r -> {
            Map<String, Object> map = new HashMap<>();
            map.put("roomId", r.getRoomId());
            map.put("roomName", r.getRoomName());
            map.put("lastMessage", Optional.ofNullable(chatRepo.findLastMessage(r.getRoomId())).orElse(""));
            map.put("updatedAt", r.getUpdatedAt());
            return map;
        }).toList();
    }

    // 메시지 저장
    public void saveMessage(ChatMessageDto message) {
        if (message == null) {
            throw new IllegalArgumentException("메시지 객체가 null입니다.");
        }
        if (message.getMessage() == null || message.getMessage().trim().isEmpty()) {
            throw new IllegalArgumentException("메시지 내용이 비어있습니다.");
        }
        if (message.getRoomId() == null) {
            throw new IllegalArgumentException("채팅방 ID가 없습니다.");
        }
        if (message.getSenderId() == null) {
            throw new IllegalArgumentException("발신자 ID가 없습니다.");
        }

        chatRepo.insertMessage(message);
    }

    // 채팅방 이름 변경
    public void updateRoomName(Integer roomId, String roomName) {
        if (roomId == null) {
            throw new IllegalArgumentException("채팅방 ID가 없습니다.");
        }
        if (roomName == null || roomName.trim().isEmpty()) {
            throw new IllegalArgumentException("채팅방 이름이 비어있습니다.");
        }
        chatRepo.updateRoomName(roomId, roomName.trim());
    }

    // 채팅방 메시지 목록 조회
    public List<ChatMessageDto> getMessages(Integer roomId) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("유효하지 않은 채팅방 ID입니다.");
        }
        return chatRepo.findMessagesByRoom(roomId);
    }

    // 채팅방 이름 조회
    public String getRoomName(Integer roomId) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("유효하지 않은 채팅방 ID입니다.");
        }
        ChatRoomDto room = chatRepo.findRoomById(roomId);
        return (room != null) ? room.getRoomName() : null;
    }
}
