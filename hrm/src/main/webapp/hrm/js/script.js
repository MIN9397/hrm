window.addEventListener('load', ()=>{
	// 버튼이 있을때만 이벤트를 추가
    let loginBtn = document.querySelector('#loginBtn');
    if(loginBtn != null){
	    loginBtn.addEventListener('click', ()=>{
	        location.href = '/member/login';
	    });
    }
    
    // 버튼이 있을때만 이벤트를 추가
    let signUpBtn = document.querySelector('#signUpBtn');
    if(signUpBtn != null){
	    signUpBtn.addEventListener('click', ()=>{
	        location.href= '/member/register'
	    });
    }
    
    // 로그아웃 버튼을 클릭하면 /member/loginout.jsp페이지로 연결
    let logoutBtn = document.querySelector('#logoutBtn');
    if(logoutBtn != null){
	    logoutBtn.addEventListener('click', ()=>{
	        //location.href= '/member/logout'; // get방식
			// -> post방식으로 변경
			
			logoutForm.method = "post";
			logoutForm.action = "/member/logout";
			logoutForm.submit();
			
	    });
    }
    
    // 검색 버튼을 클릭시 페이지번호를 초기화 하여 검색
    let searchBtn = document.querySelector('#searchBtn');
    if(searchBtn){
		searchBtn.addEventListener('click', ()=>{
	       	// searchForm의 pageNo를 초기화후 전송
	       	// 검색버튼을 클릭 하면 1페이지 보여주기
	       	go(1);
	    });
	    
	}
	
	// 페이지당 게시물의수가 변경되면 searchForm submit
	let amount = document.querySelector('[name="amount"]')
	if(amount){
		amount.addEventListener('change', ()=>{
			console.log(amount.value);			
			// searchForm.submit();
			go();	
		})
	}
	

});

/*
	pageDto를 가지고 페이지 블럭을 그려줌
*/
function renderPagination(pageDto) {
	console.log(pageDto);

  const pagination = document.getElementById('pagination');
  pagination.innerHTML = ''; // 기존 내용 초기화

  // Previous 버튼
  // 요소를 생성
  const prevItem = document.createElement('li');
  // 요소의 속성을 추가 
  prevItem.className = 'page-item' + (pageDto.isPrev ? '' : ' disabled');
  prevItem.innerHTML = `<a class="page-link" href="#" onclick="getList(${pageDto.currentPage - 1})">Previous</a>`;
  pagination.appendChild(prevItem);

  // 페이지 번호 버튼
  for (let i = pageDto.startNo; i <= pageDto.endNo; i++) {
    const pageItem = document.createElement('li');
    pageItem.className = 'page-item' + (i === pageDto.pageNo ? ' active' : '');
    pageItem.innerHTML = `<a class="page-link" href="#" onclick="getList(${i})">${i}</a>`;
    pagination.appendChild(pageItem);
  }

  // Next 버튼
  const nextItem = document.createElement('li');
  nextItem.className = 'page-item' + (pageDto.isNext ? '' : ' disabled');
  nextItem.innerHTML = `<a class="page-link" href="#" onclick="getList(${pageDto.currentPage + 1})">Next</a>`;
  pagination.appendChild(nextItem);
}

// select 박스 옵션 목록을 초기화
// 옵션목록을 매개변수로 전달 받아서 select박스에 옵션을 추가
function settingSelect(searchField, optionList, selectedItem){
	
	// 리스트의 요소를 하나씩 꺼내서 반복문을 실행
	optionList.forEach(function(item, index){
		console.log(index, item);
	    // option 태그 생성
	    let option = document.createElement("option"); // <option> 요소 생성
	    // 속성 추가
	    option.value = item.value;
	    option.textContent = item.text;
	
	    // 검색유지
	    if(selectedItem == item.value){
	    	option.selected = true;
	    }
	    
	    searchField.appendChild(option);
	})
}

// 페이지블럭의 버튼을 클릭 했을때 리스트 페이지를 요청
// 페이지 번호, 페이지당게시물수를 파라메터로 넘겨주는 역할
function go(pageNo, url){
	
	console.log("pageNo : ", pageNo);
	
	// 매개변수로 넘어온 pageNo가 있으면 pageNo를 세팅
	// 없으면 기존값 그대로
	// undefined : 매개변수로 넘어온 값이 없는경우 
	if(pageNo){	// undefined, null, 0, ""  => false
		// pageNo를 매개변수로 넘어온 값으로 변경
		document.querySelector("[name=pageNo]").value = pageNo;
	}
	
	// 페이지 마다 요청 URL이 다름
	// /member/list, /board/list/ ...
	if(url){
		searchForm.action = url;
	} else {
		// 현재요청 경로를 url로 지정
		searchForm.action = location.pathname;
	}
	
	// form 전송
	searchForm.submit();
	
}

//본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
function sample4_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
            extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== ''){
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample4_postcode').value = data.zonecode;
            document.getElementById("sample4_roadAddress").value = roadAddr;
            document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
            
            // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
            if(roadAddr !== ''){
                document.getElementById("sample4_extraAddress").value = extraRoadAddr;
            } else {
                document.getElementById("sample4_extraAddress").value = '';
            }

            var guideTextBox = document.getElementById("guide");
            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
            if(data.autoRoadAddress) {
                var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                guideTextBox.style.display = 'block';

            } else if(data.autoJibunAddress) {
                var expJibunAddr = data.autoJibunAddress;
                guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                guideTextBox.style.display = 'block';
            } else {
                guideTextBox.innerHTML = '';
                guideTextBox.style.display = 'none';
            }
        }
    }).open();
}


// 검증 정규식
const RULES = {
		user_id		: {pattern : /^[a-z0-9_]{4,12}$/,
							msg : '아이디는 영어소문자, 숫자, _로 4자이상 12자 이하로 입력 해주세요'}
		, password 	: {pattern : /^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{10,15}$/,
							msg : '비밀번호는 영어대문자, 특수문자를 포함하여 10자이상 15자 이하로 입력 해주세요'}
		, email 	: {pattern : /^[a-z]$/,
							msg : 'msg'}
		, pwcheck 	: {msg : '비밀번호가 일치하지 않습니다.'}
		
}

// 폼 유효성검사
// 유효성검사가 성공 => 요소의 class속성에 is-invalid라는 속성이 있는지 확인 => 빨강 박스의 갯수가 0개이면 true 아니면 false
function formCheck(form){
	
	// input요소 중에서 data-field속성을 가지고 있는 요소에 대해서 유효성 검사를 진행
	let inputList = form.querySelectorAll('input');
	
	// 리스트로 부터 요소를 하나씩 꺼내서 함수를 실행
	inputList.forEach((input)=>{
		// falsy한 값이 아니면 = data-field속성이 등록 되어 있으면 유효성 검사를 진행
		if(input.dataset.field){
			// 검증결과
			let testRes = true;							// 유효성 검증 결과
			// 정규식 패턴이 등록된 경우 정규식 패턴을 비교
			if(RULES[input.dataset.field].pattern){
				console.log('field : ', input.dataset.field);
				
				// RULES객체로 부터 검사패턴과 메세지 정보를 수집
				let regExp = RULES[input.dataset.field].pattern;
				
				console.log('regExp : ', regExp)
				// 정규식 테스트가 통과시 true
				testRes = regExp.test(input.value);
				
				console.log('testRes : ', testRes, regExp, input.value);
			
			} else {
				// 패턴이 아니지만 체크로직을 추가 하고 싶은 경우 
				// 비밀번호 체크
				if(input.dataset.field == 'pwcheck' && document.querySelector('[name=password]')){
					// 비밀번호와 비밀번호 확인이 같은지 체크
					if(!input.value || input.value != document.querySelector('[name=password]').value){
						testRes = false;
					} 
				}
			}
		
			// 유효성검사 실패시 빨강
			if(!testRes){
				let msg = RULES[input.dataset.field].msg;	// 출력할 메세지
				// 메세지 처리
				if(input.parentElement.querySelector('.invalid-feedback')){
					input.parentElement.querySelector('.invalid-feedback').innerText = msg;							
				}
	
				input.classList.add('is-invalid'); // 빨강
				input.classList.remove('is-valid');// 초록
			} else {
				input.classList.remove('is-invalid'); // 빨강
				input.classList.add('is-valid');// 초록
			}
		}
		
	});
	
	// 유효성 검증 결과를 반환
	// 폼의 클래스 속성에 is-invalid가 있는지 확인!!!
	return registerForm.querySelectorAll('.is-invalid').length == 0;
}

// get 방식 요청
function fetch_get(url, callback){
	fetch(url) // 요청URL
	.then(response => response.json())	// 요청결과를 object로 변환
	.then(result => {
	  	// 서버의 통신결과
	  	console.log(result);
		callback(result)
	})
	.catch(err=>{
	  	// 네트워크 장애, 매핑된 url이 없는경우
		console.log('err', err);  
	});
}

// post 방식 요청
function fetch_post(url, callback, form){
	let formdata = new FormData(form);

	fetch(url, {
		method : 'post',
		body : formdata
	}) // 요청URL
	.then(response => response.json())	// 요청결과를 object로 변환
	.then(result => {
		// 서버의 통신결과
		callback(result);	  	
	})
	.catch(err=>{
	  	// 네트워크 장애, 매핑된 url이 없는경우
		console.log('err', err);  
	});
}


