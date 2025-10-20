package com.example.hrm.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SalaryDetailDTO {
	
	
    private int payId;
    private String employeeId;
    private String username;
    private String deptName;
    private String jobTitle;
    private String payMonth;
    private double baseSalary;
    private double mealAllowance;
    private double carAllowance;
    private double childcareAllowance;
    private String bonus1Name;
    private double bonus1;
    private String bonus2Name;
    private double bonus2;
    private double totalPayment;
    private double pension;
    private double healthInsurance;
    private double employmentInsurance;
    private double incomeTax;
    private double localTax;
    private double totalDeduction;
    private double netPayment;
    private String payDate;
    private String regDate;
    

}
