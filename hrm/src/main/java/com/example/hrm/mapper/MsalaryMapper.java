package com.example.hrm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.hrm.dto.CertificateUserDTO;
import com.example.hrm.dto.SalaryDetailDTO;

@Mapper
public interface MsalaryMapper {
	
	@Select("CALL generate_monthly_salary(#{year}, #{month})")
	void callSalaryProcedure(@Param("year") int year, @Param("month") int month);

	
    // 전체 리스트 조회 (페이징 적용)
    @Select("SELECT * " +
            "FROM pay_detail " +
            "ORDER BY pay_id DESC " +
            "LIMIT #{start}, #{end}")
    List<SalaryDetailDTO> getList(@Param("start") int start, @Param("end") int end);
    
    // 전체 데이터 개수
    @Select("SELECT COUNT(*) FROM pay_detail")
    int getTotalCount();
    
    @Select("SELECT * FROM pay_detail WHERE pay_id = #{pay_id}")
    SalaryDetailDTO selectSalaryDetailById(int pay_id);
    
    
    @Select("SELECT * "
    		+ "FROM user_account u, department d, job j "
    		+ "WHERE u.dept_id = d.dept_id and u.job_id = j.job_id and employee_id = #{employee_id}")
    CertificateUserDTO selectCeUserById(int employee_id);

}
