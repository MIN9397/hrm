package com.example.hrm.config.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;
import jakarta.mail.internet.MimeMessage;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.web.multipart.MultipartFile;

import java.util.Properties;

@Service
public class MailService {

    @Autowired
    private JavaMailSender mailSender; // application.properties 계정 사용

    // 사원 등록 메일 (공식 계정으로 발송)
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
        message.setFrom("official@company.com"); // application.properties 계정
        message.setTo(toEmail);
        message.setSubject(subject);
        message.setText(content);

        mailSender.send(message);
    }

    // 일반 메일 (공식 계정 발송 + Reply-To 로그인 사용자)
    public void sendMail(String userEmail, String toEmail, String subject, String content, MultipartFile[] attachments) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            helper.setFrom("official@company.com"); // 발송은 공식 계정
            helper.setReplyTo(userEmail);           // 로그인 사용자 이메일로 회신 가능
            helper.setTo(toEmail);
            helper.setSubject(subject != null && !subject.isBlank() ? subject : "HRM 메일");
            helper.setText(content, false); // plain text

            // 첨부파일 처리
            if (attachments != null) {
                for (MultipartFile file : attachments) {
                    if (file == null || file.isEmpty()) continue;
                    String safeName = file.getOriginalFilename().replaceAll("[\\\\/]+", "_");
                    helper.addAttachment(safeName, file);
                }
            }

            mailSender.send(mimeMessage);
        } catch (Exception e) {
            throw new RuntimeException("메일 전송 실패", e);
        }
    }
}
