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
        String encoded = passwordEncoder.encode("1234");

        // 기본 ROLE_ID는 1, enabled는 1로 저장
        String defaultRoleId = "1";

        java.sql.Date sDate = dto.getHireDate() != null ? java.sql.Date.valueOf(dto.getHireDate()) : null;

        employeeMapper.insertEmployee(
            employeeCode,
            dto.getUsername(),
            encoded,
            dto.getJobId(),
            dto.getDeptId(),
            defaultRoleId,
            dto.getSalaryYear(),
            sDate,
            dto.getDependents(),
            dto.getChildren()
        );
    }

    public void toggleEnabled(String employeeId) {
        employeeMapper.toggleEnabled(employeeId);
    }
}
