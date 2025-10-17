package com.example.hrm;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
class HrmApplicationTests {

	@Test
	void contextLoads() {
	}

    public static void main(String[] args) {
        String plain="1234";
        BCryptPasswordEncoder encoder=new BCryptPasswordEncoder();
        String hashed=encoder.encode(plain);
        System.out.println("plain:"+plain);
        System.out.println("bcrypt:"+hashed);
    }
}
