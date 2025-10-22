package com.example.hrm.dto;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CertificateUserDTO {
	
	
	 private String employeeId;
	 private String username;
	 private String deptName;
	 private String jobTitle;
	 private String sDate;
	 private String address;
	 private String birth;
	 private LocalDate issueDate = LocalDate.now();
	 
	 public String getsDate() {
		 return sDate;
	 }
	 public void setsDate(String sDate) {
		 this.sDate = sDate;
	 }
	 
	 
}
