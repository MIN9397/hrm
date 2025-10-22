package com.example.hrm.config.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.hrm.dto.DepartmentDto;
import com.example.hrm.dto.EmployeeDto;
import com.example.hrm.dto.JobDto;
import com.example.hrm.mapper.EmployeeMapper;
import com.example.hrm.mapper.JobDepartmentMapper;

@Service
@Transactional
public class EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Autowired
    private JobDepartmentMapper jobDepartmentMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MailService mailService;

    public List<EmployeeDto> getEmployees() {
        return employeeMapper.findAllEmployees();
    }

    public List<JobDto> getJobs() {
        return jobDepartmentMapper.listJobs();
    }

    public List<DepartmentDto> getDepartments() {
        return jobDepartmentMapper.listDepartments();
    }

    public void registerEmployee(EmployeeDto dto) {
        // 사번(코드) 생성: 부서 코드 + 3자리 일련번호 -> employee_code로 저장
        String employeeCode = employeeMapper.generateEmployeeCode(dto.getDeptId());

        // 비밀번호는 고정값 "1234"를 암호화하여 저장
        String rawPassword = "1234";
        String encoded = passwordEncoder.encode(rawPassword);

        // 부서가 1이면 ROLE_ID는 2(HR), 그 외에는 기본 1
        String roleIdToUse = "1";
        if ("1".equals(dto.getDeptId())) {
            roleIdToUse = "2";
        }

        java.sql.Date sDate = dto.getHireDate() != null ? java.sql.Date.valueOf(dto.getHireDate()) : null;

        employeeMapper.insertEmployee(
            employeeCode,
            dto.getUsername(),
            encoded,
            dto.getJobId(),
            dto.getDeptId(),
            roleIdToUse,
            dto.getSalaryYear(),
            sDate,
            dto.getDependents(),
            dto.getChildren(),
            dto.getEmail()
        );
        // 이메일 발송 (등록 완료 안내)
        if (dto.getEmail() != null && !dto.getEmail().isEmpty()) {
            mailService.sendEmployeeRegisterMail(dto.getEmail(), employeeCode, rawPassword);
        }
    }

    public void toggleEnabled(String employeeId) {
        employeeMapper.toggleEnabled(employeeId);
    }

        public EmployeeDto getEmployeeById(String employeeId) {
            return employeeMapper.findEmployeeById(employeeId);
        }

        public void updateMyEmail(String employeeId, String email) {
            employeeMapper.updateEmail(employeeId, email);
        }

        public void updateMyPassword(String employeeId, String rawPassword) {
            String encoded = passwordEncoder.encode(rawPassword);
            employeeMapper.updatePassword(employeeId, encoded);
        }

        public void resignEmployee(String employeeId) {
            employeeMapper.resignEmployee(employeeId);
        }

    public void updateEmployee(EmployeeDto dto) {
        java.sql.Date sDate = dto.getHireDate() != null ? java.sql.Date.valueOf(dto.getHireDate()) : null;
        employeeMapper.updateEmployee(
            dto.getEmployeeId(),
            dto.getUsername(),
            dto.getJobId(),
            dto.getDeptId(),
            dto.getSalaryYear(),
            sDate,
            dto.getDependents(),
            dto.getChildren(),
            dto.getEmail()
        );
    }

    public byte[] getProfileImage(String employeeId) {
        return employeeMapper.getProfileImage(employeeId);
    }

    public void updateMyImage(String employeeId, byte[] img) {
        employeeMapper.updateProfileImage(employeeId, img);
    }
}
