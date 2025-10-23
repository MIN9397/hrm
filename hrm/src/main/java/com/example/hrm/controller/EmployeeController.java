package com.example.hrm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.hrm.config.service.EmployeeService;
import com.example.hrm.dto.EmployeeDto;
import com.example.hrm.dto.UserDto;

@Controller
@RequestMapping("/employee")
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    private boolean isHr(Authentication auth) {
        if (auth == null || auth.getPrincipal() == null) return false;
        Object p = auth.getPrincipal();
        if (p instanceof UserDto u) {
            return "2".equals(u.getRoleId());
        }
        return false;
    }

    @GetMapping("/manage")
    public String manage(Model model, Authentication auth) {
        if (!isHr(auth)) {
            // 접근 차단: 메인으로 리다이렉트
            return "redirect:/main";
        }
        List<EmployeeDto> employees = employeeService.getEmployees();
        model.addAttribute("employees", employees);
        return "/hrm/employee/list";
    }

    @GetMapping("/register")
    public String registerForm(Authentication auth, Model model) {
        if (!isHr(auth)) {
            return "redirect:/main";
        }
        model.addAttribute("jobs", employeeService.getJobs());
        model.addAttribute("departments", employeeService.getDepartments());
        return "/hrm/employee/register";
    }

    // 활성화 여부 토글 (GET 사용: CSRF 회피용, 내부에서만 사용)
    @GetMapping("/toggle-enabled")
    public String toggleEnabled(Authentication auth, @RequestParam("employeeId") String employeeId) {
        if (!isHr(auth)) {
            return "redirect:/main";
        }
        employeeService.toggleEnabled(employeeId);
        return "redirect:/employee/manage";
    }

    @PostMapping("/register")
    public String register(
        Authentication auth,
        @RequestParam("username") String username,
        @RequestParam("salaryYear") Integer salaryYear,
        @RequestParam("sDate") String sDate,
        @RequestParam(value = "dependents", required = false) Integer dependents,
        @RequestParam(value = "children", required = false) Integer children,
        @RequestParam("jobId") String jobId,
        @RequestParam("deptId") String deptId,
        @RequestParam(value = "email", required = false) String email

    ) {
        if (!isHr(auth)) {
            return "redirect:/main";
        }
        java.time.LocalDate hire = java.time.LocalDate.parse(sDate);

        EmployeeDto dto = new EmployeeDto();
        dto.setUsername(username);
        dto.setSalaryYear(salaryYear);
        dto.setHireDate(hire);
        dto.setDependents(dependents);
        dto.setChildren(children);
        dto.setJobId(jobId);
        dto.setDeptId(deptId);
        dto.setEmail(email);


        employeeService.registerEmployee(dto);
        return "redirect:/employee/manage";
    }

        @PostMapping("/resign")
        public String resign(Authentication auth, @RequestParam("employeeId") String employeeId) {
            if (!isHr(auth)) {
                return "redirect:/main";
            }
            employeeService.resignEmployee(employeeId);
            return "redirect:/employee/manage";
        }

    @GetMapping("/edit")
    public String editForm(Authentication auth, @RequestParam("employeeId") String employeeId, Model model) {
        if (!isHr(auth)) {
            return "redirect:/main";
        }
        EmployeeDto employee = employeeService.getEmployeeById(employeeId);
        if (employee == null) {
            return "redirect:/employee/manage";
        }
        model.addAttribute("employee", employee);
        model.addAttribute("jobs", employeeService.getJobs());
        model.addAttribute("departments", employeeService.getDepartments());
        return "/hrm/employee/edit";
    }

    @PostMapping("/edit")
    public String edit(
        Authentication auth,
        @RequestParam("employeeId") String employeeId,
        @RequestParam("username") String username,
        @RequestParam("salaryYear") Integer salaryYear,
        @RequestParam(value = "sDate", required = false) String sDate,
        @RequestParam(value = "dependents", required = false) Integer dependents,
        @RequestParam(value = "children", required = false) Integer children,
        @RequestParam("jobId") String jobId,
        @RequestParam("deptId") String deptId,
        @RequestParam(value = "email", required = false) String email,
        @RequestParam(value = "address", required = false) String address,
        @RequestParam(value = "phone", required = false) String phone,
        @RequestParam(value = "birth", required = false) String birth
    ) {
        if (!isHr(auth)) {
            return "redirect:/main";
        }
        java.time.LocalDate hire = null;
        if (sDate != null && !sDate.isBlank()) {
            hire = java.time.LocalDate.parse(sDate);
        }
        java.time.LocalDate birthDate = null;
        if (birth != null && !birth.isBlank()) {
            birthDate = java.time.LocalDate.parse(birth);
        }

        EmployeeDto dto = new EmployeeDto();
        dto.setEmployeeId(employeeId);
        dto.setUsername(username);
        dto.setSalaryYear(salaryYear);
        dto.setHireDate(hire);
        dto.setDependents(dependents);
        dto.setChildren(children);
        dto.setJobId(jobId);
        dto.setDeptId(deptId);
        dto.setEmail(email);
        dto.setAddress(address);
        dto.setPhone(phone);
        dto.setBirth(birthDate);

        employeeService.updateEmployee(dto);
        return "redirect:/employee/manage";
    }
}
