package com.example.hrm.config.service;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.example.hrm.dto.UploadDto;
import com.example.hrm.mapper.UploadMapper;




@Service
public class UploadService {

	@Autowired
	UploadMapper uploadMapper;
	
	// 업로드 경로 - 프로퍼티 파일의 정보를 읽어오기
	@Value("${file.upload.upload_dir}")
	private String uploadRoot; 
	
	public int getSeq() {
		uploadMapper.updateSeq();
		return uploadMapper.selectSeq();
		
	}
	
	// 파일유틸을 만들기
	// 메서드 - 저장된 파일명을 반환하는 메서드
	// 파일의 확장자를 검사하는 메서드 
	public String getSname(String oname){
		// 파일의 이름을 새로 만들어 주는 역할
		// 파일명 + _uuid + .확장자
		System.out.println(".의 위치" + oname.lastIndexOf("."));
		// 파일이름
		String name = oname.substring(0, oname.lastIndexOf("."));
		String ext = oname.substring(oname.lastIndexOf(".")+1);
		String uuid = UUID.randomUUID().toString();
		System.out.println("oname : " + name);
		System.out.println("ext : " + ext);
		System.out.println("uuid : " + uuid);
		
		String sname = name + "_" + uuid + "." + ext;
		return sname;
	}


	/**
	 * 파일 1건의 정보를 상세 조회
	 * @return
	 */
	public UploadDto getFile(UploadDto dto) {
		
		return uploadMapper.getFile(dto);
	}


	// model에 저장
	// 내장객체의 영역에 저장 - jsp에서 불러다 사용
//	public void selectList(Model model, SearchDto searchDto) {
//		// 리스트 조회
//		List<UploadDto> list = uploadMapper.selectList(searchDto);
//		
//		// 페이지Dto 생성
//		int totalCnt = uploadMapper.getTotalCnt(searchDto);
//		PageDto pageDto = new PageDto(searchDto, totalCnt);
//		
//		// model에 저장
//		model.addAttribute("list", list);
//		model.addAttribute("pageDto", pageDto);
//	}
//	
//	// map을 반환
//	public Map<String, Object> selectList_fetch(SearchDto searchDto) {
//		// 리스트 조회
//		List<UploadDto> list = uploadMapper.selectList(searchDto);
//		
//		// 페이지Dto 생성
//		int totalCnt = uploadMapper.getTotalCnt(searchDto);
//		PageDto pageDto = new PageDto(searchDto, totalCnt);
//		
//		
//		return Map.of("list", list, "pageDto", pageDto);
//	}

	/**
	 * 파일 리스트를 전달 받아서 파일을 서버에 등록
	 * @param files 업로드된 파일목록
	 * @return 서버에 저장된 파일의 갯수
	 */
	public int insertMultiUpload(List<MultipartFile> files) {
		int res = 0;
		int file_no = getSeq();
		for(int i=0; i< files.size(); i++) {
			res += insertUpload(files.get(i), file_no, i);
		}
		
		return res;
	}

	
	public int insertUpload(MultipartFile file, int file_id) {
		return insertUpload(file, file_id, 0);
	}
	
	// 파일의 정보를 데이터 베이스에 저장 하고 
	// 파일을 서버에 저장
	public int insertUpload(MultipartFile file, int file_id, int attach_idx) {
		
		int res = 0;
		if(file.isEmpty()) {
			System.out.println("첨부파일 없음");
		} else {
			try {
				//String uploadRoot = "C:/dev/upload/";
				// 저장할 파일명
				String sname = getSname(file.getOriginalFilename());
				Path path = Paths.get(uploadRoot, sname);			
				
				UploadDto upload = new UploadDto();
				// 시퀀스 번호를 전달 받아서 입력
				upload.setFile_id(file_id);
				// attach_idx : 첨부파일이 여러개인 경우 
				upload.setAttach_idx(attach_idx);
				upload.setContent_type(file.getContentType());
				upload.setFile_size(file.getSize());
				upload.setStored_name(sname);
				upload.setOrig_name(file.getOriginalFilename());
				upload.setRel_path("2025/08/18/");
				upload.setUser_id("100");
				
				res = uploadMapper.insertUpload(upload);
				// 지정된 위치에 파일을 저장
				file.transferTo(path);
				
				System.out.println("파일 저장");
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return res;
	}
}












