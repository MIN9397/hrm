package com.example.hrm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hrm.dto.CertificateUserDTO;
import com.example.hrm.dto.SalaryDetailDTO;
import com.example.hrm.dto.UserDto;
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
	public String CertificateUser(@RequestParam("employeeId") int employeeId, Model model) {
		CertificateUserDTO certi = msalary.selectCeUserById(employeeId);
	    System.out.println(certi);
	    model.addAttribute("certi", certi);
	    return "/hrm/certificate"; 
	}
	
	@GetMapping("/msalary")
    public String list(@RequestParam(defaultValue = "1") int page, Model model, Authentication authentication) {
        int pageSize = 10; // 한 페이지에 보여줄 개수
        int start = (page - 1) * pageSize;
        int end = pageSize;

        UserDto user = (UserDto) authentication.getPrincipal();
        String role = user.getRoleId();
        String employeeId = user.getEmployeeId();

        List<SalaryDetailDTO> list;

        if ("2".equals(role)) {
            list = msalary.getList(start, end);
        } else {
            list = msalary.findByEmployeeId(employeeId, start, end);
        }
        int totalCount = msalary.getTotalCount();
        int totalPages = (int)Math.ceil((double)totalCount / pageSize);

        model.addAttribute("list", list);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("user", user);
        return "/hrm/msalary"; // JSP
    }
	
	@PostMapping("/msalary")
	public String generateSalary(@RequestParam int year, @RequestParam int month) {
		msalary.callSalaryProcedure(year, month);
	    return "redirect:/msalary"; // 완료 후 이동할 페이지
	}



}
