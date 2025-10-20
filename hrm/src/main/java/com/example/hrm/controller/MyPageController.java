package com.example.hrm.controller;

import com.example.hrm.config.service.EmployeeService;
import com.example.hrm.dto.EmployeeDto;
import com.example.hrm.dto.UserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.security.core.Authentication;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class MyPageController {

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final Path profileDir = Paths.get(System.getProperty("user.home"), "hrm-uploads", "profiles");

    private String getEmployeeId(Authentication auth) {
        if (auth == null || auth.getPrincipal() == null) return null;
        Object p = auth.getPrincipal();
        if (p instanceof UserDto u) {
            return u.getEmployeeId();
        }
        return null;
    }

    @GetMapping("/mypage")
    public String mypage(Authentication auth, Model model) {
        String employeeId = getEmployeeId(auth);
        if (employeeId == null) {
            return "redirect:/main";
        }
        EmployeeDto me = employeeService.getEmployeeById(employeeId);
        model.addAttribute("me", me);
        model.addAttribute("imgVersion", System.currentTimeMillis());
        return "/hrm/mypage";
    }

    @PostMapping("/mypage/update")
    public String updateMyPage(
            Authentication auth,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam(value = "passwordConfirm", required = false) String passwordConfirm,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage
    ) throws IOException {
        String employeeId = getEmployeeId(auth);
        if (employeeId == null) {
            return "redirect:/main";
        }

        // 이메일 업데이트
        if (email != null && !email.isBlank()) {
            employeeService.updateMyEmail(employeeId, email.trim());
        }

        // 비밀번호 업데이트
        if (password != null && !password.isBlank()) {
            if (!password.equals(passwordConfirm)) {
                return "redirect:/mypage?error=pw_mismatch";
            }
            employeeService.updateMyPassword(employeeId, password);
        }

        // 프로필 이미지 저장 (DB: user_account.img)
        if (profileImage != null && !profileImage.isEmpty()) {
            byte[] imgBytes = profileImage.getBytes();
            jdbcTemplate.update(
                    "UPDATE user_account SET img = ? WHERE employee_id = ?",
                    imgBytes, employeeId
            );
        }

        return "redirect:/mypage?success=1";
    }

    @GetMapping("/mypage/profile-image")
    public ResponseEntity<byte[]> profileImage(
            Authentication auth,
            @RequestParam(value = "employeeId", required = false) String employeeIdParam
    ) throws IOException {
        String employeeId = (employeeIdParam != null && !employeeIdParam.isBlank()) ? employeeIdParam : getEmployeeId(auth);
        if (employeeId == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        byte[] bytes;
        try {
            bytes = jdbcTemplate.queryForObject(
                    "SELECT img FROM user_account WHERE employee_id = ?",
                    (rs, rowNum) -> rs.getBytes("img"),
                    employeeId
            );
        } catch (EmptyResultDataAccessException e) {
            bytes = null;
        }
        if (bytes == null || bytes.length == 0) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        // 간단한 시그니처 기반 컨텐츠 타입 추정 (PNG/JPEG)
        String contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
        System.out.println("img : " + bytes.toString());
        if (bytes.length >= 8
                && (bytes[0] & 0xFF) == 0x89 && (bytes[1] & 0xFF) == 0x50
                && (bytes[2] & 0xFF) == 0x4E && (bytes[3] & 0xFF) == 0x47) {
            contentType = MediaType.IMAGE_PNG_VALUE;
        } else if (bytes.length >= 2
                && (bytes[0] & 0xFF) == 0xFF && (bytes[1] & 0xFF) == 0xD8) {
            contentType = MediaType.IMAGE_JPEG_VALUE;
        }

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_TYPE, contentType)
                .body(bytes);
    }
}
