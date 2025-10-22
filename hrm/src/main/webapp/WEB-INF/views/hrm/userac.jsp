<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>직원 조직도</title>

    <!-- Treant.js & Raphaël -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/treant-js/1.0/Treant.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.3.0/raphael.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/treant-js/1.0/Treant.min.js"></script>

    <style>
        body {
            background: #f8f9fa;
            font-family: 'Noto Sans KR', sans-serif;
        }
       .nodeExample1 {
        font-size: 14px;
        text-align: center;
        padding: 10px;
        border: 2px solid #6c757d;
        border-radius: 10px;
        background-color: #fff;
        box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
    }
        .Treant > .node {
            text-align: center;
        }
        .nodeExample1 img {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        object-fit: cover;
        margin-bottom: 5px;
    }
    .chart {
        margin: 40px auto;
    }
    </style>
</head>
<body>

<h2 style="text-align:center;">직원 조직도</h2>
<div id="basic-example" class="chart">로딩 중...</div>
<div id="nodes-container" style="display: none;"></div> <!-- 노드 DOM 요소 보관용 -->

<script>
window.addEventListener('error', function (e) {
	  console.error('❗ 전역 에러 발생:', e.message, e);
	});
fetch('/api/userac')
    .then(res => res.json())

    .then(userac => {
    	console.log("받은 데이터:", userac);
    	if (Array.isArray(userac) && userac.length > 0) {
    	      console.log("첫 번째 이미지 데이터:", userac[0].img);
    	    } else {
    	      console.warn("데이터가 배열이 아니거나 비어 있음");
    	    }
        const nodeMap = {};
        const container = document.getElementById('nodes-container');

        // ✅ 1. DOM 요소 생성
        userac.forEach(user => {
            const empId = user.employeeId;
            //const name = user.userName || '이름 없음';
            //const managerId = user.managerId;
            //const img = user.img || 'https://via.placeholder.com/60';
            const htmlId = 'user-node-' + empId;
            let imgSrc = 'https://via.placeholder.com/60'; // 기본
            if (user.img) {
            	if (!user.img.startsWith('data:image')) {
                    imgSrc = `data:image/jpeg;base64,${user.img}`;
                } else {
                    imgSrc = user.img; // 이미 접두사가 붙어있다면 그대로 사용
                }
            }

            // DOM 생성
            const div = document.createElement('div');
            div.id = htmlId;
            div.className = 'nodeExample1';
            div.innerHTML = `
            	<img src="${imgSrc}" class="node-img" />
                <div><strong>${user.userName || '이름 없음'}</strong></div>
                <div>(ID: ${empId})</div>
                <div>${user.jobTitle || ''}</div> <!-- 👈 직책 표시 -->
            `;
            container.appendChild(div);
    console.log(user.img);

            nodeMap[empId] = {
            		text: { name: user.userName || '이름 없음',
            			title: user.jobTitle || '' },
            			image: '/mypage/profile-image?employeeId='+empId,
            	    HTMLclass: 'nodeExample1',
            	    children: []
            };
        });

        // ✅ 2. 관계 연결
        const roots = [];
        userac.forEach(user => {
            const current = nodeMap[user.employeeId];
           
            if (user.managerId === 0 || !nodeMap[user.managerId]) {
            	roots.push(current);
            	} else {
            	nodeMap[user.managerId].children.push(current);
            	}
        });
        console.log("roots:", roots);
        roots.forEach(r => console.log(r.HTMLid));
        // ✅ 3. 조직도 생성
        const chart_config = {
            chart: {
                container: "#basic-example",
                connectors: { type: "step" },
                node: { HTMLclass: "nodeExample1" }
            },
            nodeStructure: roots.length === 1
                ? roots[0]
                : {
                    innerHTML: '<div class="nodeExample1"><strong>조직도</strong></div>',
                    children: roots
                }
        };

        new Treant(chart_config);
    })
    .catch(err => {
        document.getElementById('basic-example').innerText = '❌ 조직도 로딩 실패';
        console.error('❌ fetch 또는 처리 에러:', err);
    });
</script>



</body>
</html>
