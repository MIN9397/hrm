package com.example.hrm.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class EmployeeDto {
    private String employeeId;
    private String username;
    private String password; // 등록 시에만 사용
    private String jobId;
    private String deptId;
    private String email;

    // 조인으로 조회되는 표시용 필드
    private String jobTitle;
    private String deptName;

    // 아래 필드는 스키마에 없을 수 있으므로 조회 시 null일 수 있습니다.
    private LocalDate hireDate;   // user_account.s_date
    private LocalDate retireDate; // user_account.f_date
    private Integer dependents;   // user_account.dependents
    private Integer children;     // user_account.children
    private Integer salaryYear;   // user_account.salary_year

    // 활성화 여부 (1: 활성화, 0: 비활성화)
    private Integer enabled;
}
