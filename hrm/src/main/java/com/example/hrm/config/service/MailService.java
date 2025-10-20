package com.example.hrm.config.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

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
}
