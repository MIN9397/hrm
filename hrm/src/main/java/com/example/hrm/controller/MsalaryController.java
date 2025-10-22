package com.example.hrm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hrm.dto.CertificateUserDTO;
import com.example.hrm.dto.SalaryDetailDTO;
import com.example.hrm.mapper.MsalaryMapper;

@Service
@Controller
public class MsalaryController {
	
	@Autowired
	MsalaryMapper msalary;
	
	@GetMapping("/salary")
	public String salaryDetail(@RequestParam("pay_id") int pay_id, Model model) {
	    SalaryDetailDTO detail = msalary.selectSalaryDetailById(pay_id);
	    System.out.println(detail);
	    model.addAttribute("detail", detail);
	    return "/hrm/salary"; // → 월별 내역 페이지
	}
	
	@GetMapping("/certificate")
	public String CertificateUser(@RequestParam("employee_id") int employee_id, Model model) {
		CertificateUserDTO certi = msalary.selectCeUserById(employee_id);
	    System.out.println(certi);
	    model.addAttribute("certi", certi);
	    return "/hrm/certificate"; 
	}
	
	@GetMapping("/msalary")
    public String list(@RequestParam(defaultValue = "1") int page, Model model) {
        int pageSize = 10; // 한 페이지에 보여줄 개수
        int start = (page - 1) * pageSize;
        int end = page * pageSize;

        List<SalaryDetailDTO> list = msalary.getList(start, end);
        System.out.println(list); // 상세 출력
        // ✅ 리스트 사이즈 출력 (여기!)
        System.out.println("list size = " + list.size());
        for (SalaryDetailDTO dto : list) {
            System.out.println(dto); // 상세 출력
        }
        
        int totalCount = msalary.getTotalCount();
        int totalPages = (int)Math.ceil((double)totalCount / pageSize);

        model.addAttribute("list", list);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);

        return "/hrm/msalary"; // JSP
    }


}
