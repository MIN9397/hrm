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

        // DB에서 채팅방 이름 조회
        String roomName = null;
        try {
            roomName = chatService.getRoomName(roomId);
        } catch (IllegalArgumentException ignored) {
        }
        if (roomName == null || roomName.isBlank()) {
            roomName = "채팅방";
        }
        model.addAttribute("roomName", roomName);

        if (auth != null && auth.getPrincipal() instanceof UserDto user) {
            model.addAttribute("me", user);
        }
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
            myId = Long.valueOf(user.getEmployeeId());
        }
        Integer roomId = chatService.createRoom(myId, targetEmployeeId);
        return Map.of("roomId", roomId);
    }

    // 채팅방 목록 조회 (JSON)
    @GetMapping("/chat/rooms")
    @ResponseBody
    public List<Map<String, Object>> getRoomList(Authentication auth) {
        Long myId = null;
        if (auth != null && auth.getPrincipal() instanceof UserDto user) {
            myId = Long.valueOf(user.getEmployeeId());
        }
        return chatService.getRoomList(myId);
    }

    // 채팅방 메시지 목록 조회 (JSON)
    @GetMapping("/chat/room/{roomId}/messages")
    @ResponseBody
    public List<ChatMessageDto> getMessages(@PathVariable Integer roomId) {
        return chatService.getMessages(roomId);
    }

    // 채팅방 이름 변경
    @PostMapping("/chat/room/{roomId}/rename")
    @ResponseBody
    public Map<String, Object> renameRoom(@PathVariable Integer roomId, @RequestBody Map<String, String> body, Authentication auth) {
        String roomName = (body != null) ? body.get("roomName") : null;
        try {
            chatService.updateRoomName(roomId, roomName);
            return Map.of("success", true);
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        }
    }

    // 메시지 전송 (STOMP)
    @MessageMapping("/chat.send")
    public void send(ChatMessageDto message, Authentication auth) {
        if (message == null) return;

        // 메시지 내용이 비어있는 경우 처리
        if (message.getMessage() == null || message.getMessage().trim().isEmpty()) {
            System.err.println("메시지 내용이 비어있습니다.");
            return;
        }

        if (message.getSenderId() == null && auth != null && auth.getPrincipal() instanceof UserDto user) {
            message.setSenderId(Long.valueOf(user.getEmployeeId()));
        }

        message.setCreatedAt(LocalDateTime.now());

        // DB 저장
        try {
            chatService.saveMessage(message);
            // 방별 브로드캐스트
            template.convertAndSend("/topic/chat/" + message.getRoomId(), message);
        } catch (Exception e) {
            System.err.println("메시지 저장 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
