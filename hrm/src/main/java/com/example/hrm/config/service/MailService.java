package com.example.hrm.config.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import jakarta.mail.internet.MimeMessage;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.web.multipart.MultipartFile;

@Service
public class MailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendEmployeeRegisterMail(String toEmail, String employeeCode, String password) {
        String subject = "[HRM 시스템] 사원 등록 안내";
        String content = String.format("""
안녕하세요. 내맘대로 HRD시스템입니다.

사원 등록이 완료되었습니다.

▶ 사번: %s
▶ 초기 비밀번호: %s

로그인 후 비밀번호를 변경해주세요.

감사합니다.
""", employeeCode, password);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject(subject);
        message.setText(content);

        mailSender.send(message);
    }

    // 일반 메일 전송 (발신자 지정, 첨부파일 가능)
    public void sendMail(String fromEmail, String toEmail, String subject, String content, MultipartFile[] attachments) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            // multipart=true 로 생성해야 첨부파일이 포함됨
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject(subject != null && !subject.isBlank() ? subject : "HRM 메일");
            helper.setText(content, false); // plain text

            // 첨부파일 추가
            if (attachments != null) {
                for (MultipartFile file : attachments) {
                    if (file == null || file.isEmpty()) continue;
                    String original = file.getOriginalFilename();
                    // 파일명에서 경로문자 제거하여 보안 강화
                    String safeName = (original != null) ? original.replaceAll("[\\\\/]+", "_") : "attachment";
                    helper.addAttachment(safeName, file);
                }
            }

            mailSender.send(mimeMessage);
        } catch (Exception e) {
            throw new RuntimeException("메일 전송 실패", e);
        }
    }
}
