package com.example.hrm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

// Authentication failure type checks
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.example.hrm.config.service.CustomUserDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		System.out.println("=================   SecurityFilterChain");
		http
			.authorizeHttpRequests((authorize) -> authorize
				.requestMatchers("/", "/login", "/error", "/css/**", "/js/**", "/img/**", "/.well-known/**").permitAll()
				//.requestMatchers("/admin/**").hasRole("ADMIN")
				//.requestMatchers("/user/**").hasRole("USER")
				.anyRequest().authenticated()
			)
			//.httpBasic(Customizer.withDefaults())
			.formLogin(form -> form
					.loginPage("/login")
					.loginProcessingUrl("/login-process")
					.usernameParameter("employee_code")
					.passwordParameter("password")
					.permitAll()
                    .defaultSuccessUrl("/main",true)
					.failureHandler((request, response, exception) -> {
						String reason;
						if (exception instanceof org.springframework.security.authentication.BadCredentialsException) {
							reason = "bad_credentials";
						} else if (exception instanceof org.springframework.security.authentication.DisabledException) {
							reason = "disabled";
						} else if (exception instanceof org.springframework.security.authentication.LockedException) {
							reason = "locked";
						} else if (exception instanceof org.springframework.security.authentication.AccountExpiredException) {
							reason = "account_expired";
						} else if (exception instanceof org.springframework.security.authentication.CredentialsExpiredException) {
							reason = "credentials_expired";
						} else if (exception instanceof org.springframework.security.core.userdetails.UsernameNotFoundException) {
							reason = "user_not_found";
						} else {
							reason = "auth_error";
						}
						response.sendRedirect("/login?error=" + reason);
					})
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

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers(
                "/css/**",
                "/js/**",
                "/img/**",
                "/favicon.ico",
                "/WEB-INF/**"   // ✅ JSP 뷰 제외!
        );
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
