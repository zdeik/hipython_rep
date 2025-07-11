USE WNTRADE;
-- 제품별로 주문수량합, 주문금액 합 제품
select 제품명, SUM(주문수량) AS 주문세부수량합, SUM(주문세부.단가 * 주문수량) AS 주문금액합
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
group by 제품명;

-- 아이스크림 제품의 주문년도, 제품명 별 주문수량 합
select YEAR(주문일) AS 주문년도, 제품명, SUM(주문수량)
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
INNER JOIN 주문
ON 주문.주문번호 = 주문세부.주문번호
WHERE 제품명 LIKE '%아이스크림%'
group by 제품명,주문년도;

-- 주문이 한번도 안된 제품도 포함한 제품별로 주문수량합, 주문금액 합
select 제품명, SUM(주문수량) AS 주문수량합, SUM(주문세부.단가 * 주문수량) AS 주문금액합
FROM 제품
LEFT JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
group by 제품명;


-- 고객 회사 중 마일리지 등급이 'A'인 고객의 정보  (고객번호, 담당자명, 고객회사명, 등급명, 마일리지)
select 고객번호, 담당자명, 고객회사명, 등급명, 마일리지
from 고객
inner join 마일리지등급
ON 마일리지 between 하한마일리지 AND 상한마일리지
WHERE 등급명 = 'A';


-- MY_DB 조인 연습
use my_db;
-- emp테이블에서 사원들의 이름, 급여와 급여 등급을 출력하는 SQL문 작성
select ENAME,SAL,GRADE
FROM EMP
INNER JOIN salgrade
ON SAL between losal AND hisal;

-- 사원번호, 사원이름, 관리자번호, 관리자이름을 조회
select EMP.empno, EMP.ENAME, EMP.MGR, mg.ENAME
FROM EMP
inner join EMP as mg
on EMP.EMPNO = mg.MGR;

-- 모든 사원에 대해서 사원번호와 이름, 부서번호, 부서이름을 조회
select empno, ENAME, dept.DEPTNO, DNAME
from emp
inner join dept
ON emp.DEPTNO = dept.DEPTNO;

-- 모든 부서에 대해서 부서별로 소속 사원들의 정보를 출력
select DNAME, ENAME, JOB, SAL
from dept
LEFT join emp
ON emp.DEPTNO = dept.DEPTNO
order by DNAME;

-- 모든 사원과 모든 부서 정보를 조인 결과로 생성. 부서에 소속된 사원이 없어도 부서와 소속되지 않은 사원 출력
select dept.DEPTNO, DNAME, ENAME, EMPNO, SAL JOB, MGR, HIREDATE, SAL, COMM, emp.DEPTNO
from dept
LEFT JOIN emp
ON dept.DEPTNO = emp.DEPTNO;


