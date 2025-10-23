package com.example.hrm.controller;

import com.example.hrm.config.service.MailService;
import com.example.hrm.dto.UserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class MailController {

    private final MailService mailService;

    @Autowired
    public MailController(MailService mailService) {
        this.mailService = mailService;
    }

    // 메일 작성 화면
    @GetMapping("/mail/compose")
    public String compose() {
        return "/hrm/mail/compose";
    }

    // 메일 전송 처리
    @PostMapping("/mail/send")
    public String send(
            @RequestParam("toEmail") String toEmail,
            @RequestParam(value = "subject", required = false) String subject,
            @RequestParam("content") String content,
            @RequestParam(value = "attachments", required = false) MultipartFile[] attachments,
            Authentication auth,
            RedirectAttributes ra
    ) {
        String fromEmail = null;
        if (auth != null && auth.getPrincipal() instanceof UserDto user) {
            fromEmail = user.getEmail();
        }

        if (fromEmail == null || fromEmail.isBlank()) {
            ra.addFlashAttribute("error", "로그인한 사용자의 이메일이 없습니다. 프로필에서 이메일을 먼저 등록해주세요.");
            return "redirect:/mail/compose";
        }

        try {
            mailService.sendMail(fromEmail, toEmail, subject, content, attachments);
            ra.addFlashAttribute("success", "메일을 성공적으로 전송했습니다.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "메일 전송에 실패했습니다: " + e.getMessage());
        }
        return "redirect:/mail/compose";
    }
}
