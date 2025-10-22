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
        String roomName = "DM " + Math.min(myId, targetId) + "-" + Math.max(myId, targetId);
        int roomId = chatRepo.insertRoom(roomName, myId);
        chatRepo.insertMember(roomId, myId);
        chatRepo.insertMember(roomId, targetId);
        return roomId;
    }

    // 사원이 속한 방 목록 (상대방 이름 포함)
    public List<Map<String, Object>> getRoomList(Long employeeId) {
        List<ChatRoomDto> rooms = chatRepo.findRoomsByEmployee(employeeId);
        return rooms.stream().map(r -> {
            Map<String, Object> map = new HashMap<>();
            map.put("roomId", r.getRoomId());
            map.put("roomName", r.getRoomName()); // DB room_name
            map.put("lastMessage", Optional.ofNullable(chatRepo.findLastMessage(r.getRoomId())).orElse(""));
            map.put("updatedAt", r.getUpdatedAt());

            // 상대방 정보 조회
            Map<String, Object> partner = chatRepo.findPartnerByRoom(r.getRoomId(), employeeId);
            if (partner != null) {
                map.put("partnerId", partner.get("employee_id"));
                String partnerName = (String) partner.get("username");
                if (partnerName == null || partnerName.isBlank()) {
                    partnerName = "사용자";
                }
                map.put("partnerName", partnerName);
                map.put("partnerUsername", partnerName); // JSP에서 사용
            } else {
                // 상대방 정보가 없을 경우 기본값 설정
                map.put("partnerName", "알 수 없음");
                map.put("partnerUsername", "알 수 없음");
            }

            // 현재 사용자 정보 추가
            map.put("meEmployeeId", employeeId);

            return map;
        }).toList();
    }

    // 메시지 저장
    public void saveMessage(ChatMessageDto message) {
        if (message == null || message.getMessage() == null || message.getMessage().trim().isEmpty()
                || message.getRoomId() == null || message.getSenderId() == null)
            throw new IllegalArgumentException("메시지 정보가 불완전합니다.");

        chatRepo.insertMessage(message);
    }

    // 채팅방 메시지 목록 조회
    public List<ChatMessageDto> getMessages(Integer roomId) {
        if (roomId == null || roomId <= 0)
            throw new IllegalArgumentException("유효하지 않은 채팅방 ID입니다.");
        return chatRepo.findMessagesByRoom(roomId);
    }

    // 채팅방 이름 조회
    public String getRoomName(Integer roomId) {
        if (roomId == null || roomId <= 0)
            throw new IllegalArgumentException("유효하지 않은 채팅방 ID입니다.");
        ChatRoomDto room = chatRepo.findRoomById(roomId);
        return (room != null) ? room.getRoomName() : null;
    }

    // 부서 채팅방 생성/재사용
    public Integer createDeptRoomFor(Long myEmployeeId) {
        if (myEmployeeId == null) throw new IllegalArgumentException("로그인 정보가 없습니다.");

        Map<String, Object> dept = chatRepo.findDeptInfoByEmployee(myEmployeeId);
        if (dept == null) throw new IllegalArgumentException("부서 정보를 찾을 수 없습니다.");

        Long deptId = ((Number) dept.get("dept_id")).longValue();
        String deptName = (String) dept.get("dept_name");

        Integer existing = chatRepo.findDeptRoomId(deptId);
        if (existing == null) {
            // 방 생성
            String roomName = "DEPT-" + deptId + ": " + deptName;
            int roomId = chatRepo.insertRoom(roomName, myEmployeeId);
            // 해당 부서 모든 사원 멤버로 추가
            List<Long> memberIds = chatRepo.findEmployeeIdsByDept(deptId);
            for (Long empId : memberIds) {
                chatRepo.insertMember(roomId, empId);
            }
            return roomId;
        } else {
            // 기존 방이 있다면 최소한 본인은 포함되도록
            chatRepo.insertMemberIfAbsent(existing, myEmployeeId);
            return existing;
        }
    }

    // 채팅방 상세 정보 조회 (상대방 이름 포함)
    public Map<String, Object> getRoomDetail(Integer roomId, Long myEmployeeId) {
        if (roomId == null || roomId <= 0)
            throw new IllegalArgumentException("유효하지 않은 채팅방 ID입니다.");
        
        ChatRoomDto room = chatRepo.findRoomById(roomId);
        if (room == null) return null;
        
        Map<String, Object> detail = new HashMap<>();
        detail.put("roomId", room.getRoomId());
        detail.put("roomName", room.getRoomName());
        
        // 상대방 정보 조회
        Map<String, Object> partner = chatRepo.findPartnerByRoom(roomId, myEmployeeId);
        if (partner != null) {
            String partnerName = (String) partner.get("username");
            if (partnerName == null || partnerName.isBlank()) {
                partnerName = "사용자";
            }
            detail.put("partnerName", partnerName);
            detail.put("partnerId", partner.get("employee_id"));
        } else {
            detail.put("partnerName", "채팅방");
        }
        
        return detail;
    }
}
