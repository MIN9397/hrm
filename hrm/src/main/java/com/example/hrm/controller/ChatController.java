package com.example.hrm.controller;

import com.example.hrm.dto.ChatMessage;
import com.example.hrm.dto.UserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.time.LocalDateTime;

@Controller
public class ChatController {

    private final SimpMessagingTemplate template;

    @Autowired
    public ChatController(SimpMessagingTemplate template) {
        this.template = template;
    }

    // 채팅 목록 페이지
    @GetMapping("/chat/list")
    public String chatList() {
        return "/hrm/chat/list";
    }

    // 채팅방 페이지
    @GetMapping("/chat/room/{roomId}")
    public String chatRoom(@PathVariable String roomId, Model model) {
        model.addAttribute("roomId", roomId);
        return "/hrm/chat/room";
    }
    
    // 새 채팅 시작 페이지 (임시로 목록으로 리다이렉트)
    @GetMapping("/chat/new")
    public String chatNew() {
        return "redirect:/chat/list";
    }

    @MessageMapping("/chat.send")
    public void send(ChatMessage message, Authentication auth) {
        if (message == null) return;

        // 보낸이 값이 없으면 로그인 사용자로 설정
        if ((message.getSender() == null || message.getSender().isBlank()) && auth != null) {
            Object principal = auth.getPrincipal();
            if (principal instanceof UserDto user) {
                String fallback = user.getUsername() != null && !user.getUsername().isBlank()
                        ? user.getUsername()
                        : user.getEmployeeCode();
                message.setSender(fallback);
            }
        }

        message.setTimestamp(LocalDateTime.now().toString());
        template.convertAndSend("/topic/chat", message);
    }
}
