package com.example.hrm.controller;

import com.example.hrm.config.service.ChatService;
import com.example.hrm.config.service.EmployeeService;
import com.example.hrm.dto.ChatMessageDto;
import com.example.hrm.dto.EmployeeDto;
import com.example.hrm.dto.UserDto;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate template;
    private final ChatService chatService;
    private final EmployeeService employeeService;

    // 채팅 목록 페이지
    @GetMapping("/chat/list")
    public String chatList() { return "/hrm/chat/list"; }

    // 채팅방 페이지
    @GetMapping("/chat/room/{roomId}")
    public String chatRoom(@PathVariable Integer roomId, Model model, Authentication auth) {
        model.addAttribute("roomId", roomId);

        Long myEmployeeId = null;
        if (auth != null && auth.getPrincipal() instanceof UserDto user) {
            myEmployeeId = Long.valueOf(user.getEmployee_id());
            model.addAttribute("me", user);
        }
        
        // 채팅방 상세 정보 조회 (상대방 이름 포함)
        Map<String, Object> roomDetail = chatService.getRoomDetail(roomId, myEmployeeId);
        
        // 기본 표시 이름
        String displayName = "채팅방";
        if (roomDetail != null && roomDetail.get("partnerName") != null) {
            displayName = (String) roomDetail.get("partnerName");
        }

        // 부서 채팅방이면 room_name에서 접두어 제거 후 부서명만 표시
        String rawRoomName = chatService.getRoomName(roomId);
        if (rawRoomName != null && rawRoomName.startsWith("DEPT-")) {
            int idx = rawRoomName.indexOf(':');
            displayName = (idx > -1) ? rawRoomName.substring(idx + 1).trim() : rawRoomName;
        }
        
        model.addAttribute("roomName", displayName);
        model.addAttribute("partnerName", displayName);
        
        return "/hrm/chat/room";
    }

    // 사원 목록 조회
    @GetMapping("/chat/employees")
    @ResponseBody
    public List<Map<String, String>> employees() {
        List<EmployeeDto> list = employeeService.getEmployees();
        return list.stream().map(e -> {
            Map<String, String> m = new HashMap<>();
            m.put("employeeId", String.valueOf(e.getEmployeeId()));
            m.put("username", e.getUsername());
            m.put("deptName", e.getDeptName());
            return m;
        }).toList();
    }

    // 새 채팅방 생성
    @PostMapping("/chat/room/new")
    @ResponseBody
    public Map<String, Object> createRoom(@RequestParam Long targetEmployeeId, Authentication auth) {
        Long myId = null;
        if (auth != null && auth.getPrincipal() instanceof UserDto user) {
            myId = Long.valueOf(user.getEmployee_id());
        }
        Integer roomId = chatService.createRoom(myId, targetEmployeeId);
        return Map.of("roomId", roomId);
    }

    // 부서 채팅방 생성/접속
    @PostMapping("/chat/room/dept/new")
    @ResponseBody
    public Map<String, Object> createDeptRoom(Authentication auth) {
        Long myId = null;
        if (auth != null && auth.getPrincipal() instanceof UserDto user) {
            myId = Long.valueOf(user.getEmployee_id());
        }
        if (myId == null) {
            return Map.of("error", "unauthorized");
        }
        Integer roomId = chatService.createDeptRoomFor(myId);
        return Map.of("roomId", roomId);
    }

    // 채팅방 목록 조회
    @GetMapping("/chat/rooms")
    @ResponseBody
    public List<Map<String, Object>> getRoomList(Authentication auth) {
        Long myId = null;
        if (auth != null && auth.getPrincipal() instanceof UserDto user) {
            myId = Long.valueOf(user.getEmployee_id());
        }
        
        if (myId == null) {
            // 인증 정보가 없을 경우 빈 리스트 반환
            return List.of();
        }
        
        List<Map<String, Object>> rooms = chatService.getRoomList(myId);
        
        // 디버깅용 로그 추가 (선택사항)
        System.out.println("채팅방 목록 조회 - 사용자 ID: " + myId + ", 채팅방 수: " + rooms.size());
        
        return rooms;
    }

    // 채팅방 메시지 목록 조회 (추가)
    @GetMapping("/chat/room/{roomId}/messages")
    @ResponseBody
    public List<ChatMessageDto> getMessages(@PathVariable Integer roomId) {
        return chatService.getMessages(roomId);
    }

    // 메시지 전송 (STOMP)
    @MessageMapping("/chat.send")
    public void send(ChatMessageDto message, Authentication auth) {
        if (message == null || message.getMessage() == null || message.getMessage().trim().isEmpty()) return;

        if (message.getSenderId() == null && auth != null && auth.getPrincipal() instanceof UserDto user) {
            message.setSenderId(Long.valueOf(user.getEmployee_id()));
        }

        message.setCreatedAt(LocalDateTime.now());
        chatService.saveMessage(message);
        template.convertAndSend("/topic/chat/" + message.getRoomId(), message);
    }


}
