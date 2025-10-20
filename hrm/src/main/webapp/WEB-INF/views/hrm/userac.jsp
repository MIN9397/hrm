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
        .node-img {
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
fetch('/api/userac')
    .then(res => res.json())
    .then(userac => {
        const nodeMap = {};
        const container = document.getElementById('nodes-container');

        // ✅ 1. DOM 요소 생성
        userac.forEach(user => {
            const empId = user.employeeId;
            //const name = user.userName || '이름 없음';
            //const managerId = user.managerId;
            //const img = user.img || 'https://via.placeholder.com/60';
            const htmlId = 'user-node-' + empId;

            // DOM 생성
            const div = document.createElement('div');
            div.id = htmlId;
            div.className = 'nodeExample1';
            div.innerHTML = `
                <img src="${user.img || 'https://via.placeholder.com/60'}" class="node-img" />
                <div><strong>${user.userName || '이름 없음'}</strong></div>
                <div>(ID: ${empId})</div>
                <div>${user.jobTitle || ''}</div> <!-- 👈 직책 표시 -->
            `;
            container.appendChild(div);

            nodeMap[empId] = {
            		text: { name: user.userName || '이름 없음',
            			title: user.jobTitle || '' },
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
        console.error(err);
    });
</script>



</body>
</html>
