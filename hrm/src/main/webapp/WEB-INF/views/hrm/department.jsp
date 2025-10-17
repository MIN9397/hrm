<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부서 조직도</title>

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
            border: 2px solid #6c757d;
            border-radius: 10px;
            padding: 10px;
            background-color: white;
            box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
        }
        .Treant > .node {
            text-align: center;
        }
    </style>
</head>
<body>

<h2 style="text-align:center;">부서 조직도 </h2>
<div id="basic-example" class="chart">로딩 중...</div>

<script>
    fetch('/api/departments')
        .then(res => res.json())
        .then(departments => {
            // 1. Map 생성
            const nodeMap = {};
            departments.forEach(dept => {
                nodeMap[dept.deptId] = {
                    text: { name: dept.deptName },
                    HTMLclass: 'nodeExample1',
                    children: []
                };
            });

            // 2. 계층 구조 연결
            let roots = [];
            departments.forEach(dept => {
                if (dept.parentId === null) {
                    roots.push(nodeMap[dept.deptId]);
                } else {
                    const parent = nodeMap[dept.parentId];
                    if (parent) {
                        parent.children.push(nodeMap[dept.deptId]);
                    }
                }
            });

            // 3. chart 구성
            const chart_config = {
                chart: {
                    container: "#basic-example",
                    connectors: { type: 'step' },
                    node: { HTMLclass: 'nodeExample1' }
                },
                nodeStructure: roots.length === 1 ? roots[0] : {
                    text: { name: "hrm" },
                    children: roots
                }
            };

            // 4. 트리 생성
            new Treant(chart_config);
        })
        .catch(err => {
            document.getElementById('basic-example').innerText = '❌ 조직도 로딩 실패';
            console.error(err);
        });
</script>

</body>
</html>
