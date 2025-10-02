package com.example.hrm.config;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

import com.example.hrm.config.service.CustomUserDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		System.out.println("=================   SecurityFilterChain");
		http
			.authorizeHttpRequests((authorize) -> authorize
				.requestMatchers(".well-known/**", "/login", "/", "/error").permitAll()
				//.requestMatchers("/admin/**").hasRole("ADMIN")
				//.requestMatchers("/user/**").hasRole("USER")
				.anyRequest().permitAll()
			)
			//.httpBasic(Customizer.withDefaults())
			.formLogin(from -> from
					.loginPage("/login")
					.usernameParameter("id")
					.passwordParameter("pw")
					.permitAll()
					//.successForwardUrl("/main") 		// 로그인 성공시 forward
					.defaultSuccessUrl("/login-success", true)	// /main으로 redirect
					.failureUrl("/login?error").permitAll()// 로그인 실패시 이동
			)
			// ★로그아웃 설정
			.logout(logout -> logout
					// 로그아웃을 처리할 URL을 지정
					.logoutUrl("/logout")
					// 로그아웃 성공 시 리디렉션할 목적지를 지정
					.logoutSuccessUrl("/login?logout")
					// 로그아웃 시 세션을 무효화
					.invalidateHttpSession(true)
					// 로그아웃 시 쿠키를 삭제
					.deleteCookies("JSESSIONID")
		   );
			

		return http.build();
	}

	/*
	@Bean
	public UserDetailsService userDetailsService() {
		UserDetails userDetails = User.builder()
			.username("admin")
			.password("$2a$10$3MK8N58SDf4DsDYvE583NOaWwbvtf2.WMfeRHn79TvvqtNXTuN8Ey")
			.roles("USER")
			.build();

		return new InMemoryUserDetailsManager(userDetails);
	}
	*/
	
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	CustomUserDetailsService customUserDetailsService() {
		return new CustomUserDetailsService();
	}

	/*
	@Bean
	UserDetailsManager users(DataSource dataSource) {
		UserDetails user = User.builder()
			.username("user")
			.password("$2a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW")
			.roles("USER")
			.build();
		UserDetails admin = User.builder()
			.username("admin")
			.password("$2a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW")
			.roles("USER", "ADMIN")
			.build();
		JdbcUserDetailsManager users = new JdbcUserDetailsManager(dataSource);
		
		if(!users.userExists("user")) users.createUser(user);
		if(!users.userExists("admin")) users.createUser(admin);

		return users;
	}
	*/
}
