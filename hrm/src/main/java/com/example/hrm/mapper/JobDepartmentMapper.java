package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.hrm.dto.JobDto;
import com.example.hrm.dto.DepartmentDto;

@Mapper
public interface JobDepartmentMapper {

    @Select("""
        SELECT job_id AS jobId, job_title AS jobTitle
        FROM job
        ORDER BY job_title
    """)
    List<JobDto> listJobs();

    @Select("""
        SELECT dept_id AS deptId, dept_name AS deptName
        FROM department
        ORDER BY dept_name
    """)
    List<DepartmentDto> listDepartments();
}
