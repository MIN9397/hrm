package com.example.hrm.mapper;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.hrm.dto.EmployeeDto;

@Mapper
public interface EmployeeMapper {

    // user_account를 기준으로 job, department 조인하여 직급/부서명과 날짜/가족/활성화 여부를 함께 조회
    @Select("""
        SELECT
            ua.employee_id AS employeeId,
            ua.username,
            ua.job_id AS jobId,
            ua.dept_id AS deptId,
            j.job_title AS jobTitle,
            d.dept_name AS deptName,
            ua.email     AS email,
            ua.s_date     AS hireDate,
            ua.f_date     AS retireDate,
            ua.dependents AS dependents,
            ua.children   AS children,
            ua.enabled    AS enabled
        FROM user_account ua
        LEFT JOIN job j ON j.job_id = ua.job_id
        LEFT JOIN department d ON d.dept_id = ua.dept_id
        ORDER BY ua.employee_id
    """)
    List<EmployeeDto> findAllEmployees();

    // 선택한 부서에 대해 다음 사번(코드) 생성 (예: HR-001, HR-002 ...)
    @Select("""
        SELECT CONCAT(d.dept_code, '-', LPAD(COALESCE(MAX(CAST(SUBSTRING_INDEX(ua.employee_code,'-',-1) AS UNSIGNED)),0)+1, 3, '0'))
        FROM department d
        LEFT JOIN user_account ua ON ua.dept_id = d.dept_id
        WHERE d.dept_id = #{deptId}
    """)
    String generateEmployeeCode(@Param("deptId") String deptId);

    @Insert("""
        INSERT INTO user_account (
            employee_code, username, password, enabled,
            job_id, dept_id, role_id,
            salary_year, s_date, dependents, children, email
        ) VALUES (
            #{employeeCode}, #{username}, #{encodedPassword}, 1,
            #{jobId}, #{deptId}, #{roleId},
            #{salaryYear}, #{sDate}, #{dependents}, #{children}, #{email}
        )
    """)
    int insertEmployee(
        @Param("employeeCode") String employeeCode,
        @Param("username") String username,
        @Param("encodedPassword") String encodedPassword,
        @Param("jobId") String jobId,
        @Param("deptId") String deptId,
        @Param("roleId") String roleId,
        @Param("salaryYear") Integer salaryYear,
        @Param("sDate") Date sDate,
        @Param("dependents") Integer dependents,
        @Param("children") Integer children,
        @Param("email") String email);

    @Update("""
        UPDATE user_account
        SET enabled = CASE WHEN enabled = 1 THEN 0 ELSE 1 END
        WHERE employee_id = #{employeeId}
    """)
    int toggleEnabled(@Param("employeeId") String employeeId);

        @Update("""
            UPDATE user_account
            SET f_date = CURRENT_DATE, enabled = 0
            WHERE employee_id = #{employeeId}
        """)
        int resignEmployee(@Param("employeeId") String employeeId);

        @Select("""
            SELECT
                ua.employee_id AS employeeId,
                ua.username,
                ua.job_id AS jobId,
                ua.dept_id AS deptId,
                ua.salary_year AS salaryYear,
                ua.s_date AS hireDate,
                ua.f_date AS retireDate,
                ua.dependents AS dependents,
                ua.children AS children,
                ua.enabled AS enabled,
                ua.email AS email,
                j.job_title AS jobTitle,
                d.dept_name AS deptName
            FROM user_account ua
            LEFT JOIN job j ON j.job_id = ua.job_id
            LEFT JOIN department d ON d.dept_id = ua.dept_id
            WHERE ua.employee_id = #{employeeId}
        """)
        EmployeeDto findEmployeeById(@Param("employeeId") String employeeId);

        @Update("""
            UPDATE user_account
            SET email = #{email}
            WHERE employee_id = #{employeeId}
        """)
        int updateEmail(@Param("employeeId") String employeeId, @Param("email") String email);

        @Update("""
            UPDATE user_account
            SET password = #{encodedPassword}
            WHERE employee_id = #{employeeId}
        """)
        int updatePassword(@Param("employeeId") String employeeId, @Param("encodedPassword") String encodedPassword);


    @Update("""
        UPDATE user_account SET
            username = #{username},
            job_id = #{jobId},
            dept_id = #{deptId},
            salary_year = #{salaryYear},
            s_date = #{sDate},
            dependents = #{dependents},
            children = #{children},
            email = #{email}
        WHERE employee_id = #{employeeId}
    """)
    int updateEmployee(
        @Param("employeeId") String employeeId,
        @Param("username") String username,
        @Param("jobId") String jobId,
        @Param("deptId") String deptId,
        @Param("salaryYear") Integer salaryYear,
        @Param("sDate") Date sDate,
        @Param("dependents") Integer dependents,
        @Param("children") Integer children,
        @Param("email") String email
    );

    @Select("""
        SELECT img FROM user_account WHERE employee_id = #{employeeId}
    """)
    byte[] getProfileImage(@Param("employeeId") String employeeId);

    @Update("""
        UPDATE user_account
        SET img = #{img}
        WHERE employee_id = #{employeeId}
    """)
    int updateProfileImage(@Param("employeeId") String employeeId, @Param("img") byte[] img);
}
