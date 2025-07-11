use my_db;
-- 사원들의 소속 부서 종류만 조회
select ENAME,DNAME
FROM emp
inner JOIN dept
ON emp.DEPTNO = dept.DEPTNO;

-- 급여가 2000이상 3000이하를 받는 사원 정보(부서번호, 이름, 직무, 급여)만 조회 , 결과집합 생성
select DEPT.DEPTNO, ENAME, JOB, SAL
FROM EMP
INNER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO
where SAL>=2000 AND SAL<=3000;

-- 사원번호가 7902, 7788, 7566인  사원 정보(사원번호,부서번호, 이름, 직무 )만 조회
select EMPNO, DEPT.DEPTNO, ENAME, JOB
FROM EMP
INNER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO
where EMPNO IN(7902, 7788,7566);

-- 사원 이름이 ‘A’로 시작하는  사원이름, 급여, 업무
select ENAME, SAL, JOB
FROM EMP
where ENAME LIKE 'A%';

-- 사원 이름의 두번째 문자가 ‘A’인  모든 사원이름, 급여, 업무
select ENAME, SAL, JOB
FROM EMP
where ENAME LIKE '_A%';

-- 사원 이름이 마지막 문자가 ‘N’인  사원이름, 급여, 업무 조회
select ENAME, SAL, JOB
FROM EMP
where ENAME LIKE '%N';

-- 커미션을 받지 않는 사원이름, 급여, 업무, 커미션을  조회
select ENAME, SAL, JOB, COMM
FROM EMP
WHERE COMM IS NULL;

-- 커미션이 NULL인 경우 0으로 SAL+COMM = TOTAL_SALARY 계산
UPDATE MY_DB.EMP
SET COMM = IFNULL(COMM, 0);

select SAL, COMM, SAL+COMM AS TOTAL_SALARY
FROM EMP;

UPDATE MY_DB.EMP
SET COMM = NULLIF(COMM, 0);

-- 커미션을 받는 사원들의 커미션 평균
select AVG(COMM) AS '커미션을 받는 사원들의 커미션 평균'
FROM EMP
WHERE COMM IS NOT NULL;

-- DEPTNO, JOB 별 급여합계, 급여평균, 총합계 

-- 외에 연습문제 출제해서 풀기

-- 각 부서(DEPTNO)별로 최고 급여와 최저 급여의 차이를 계산하여 조회하세요. 단, 급여 차이가 2500 이상인 부서의 정보만 보여주세요.
SELECT DEPTNO, MAX(SAL) - MIN(SAL) AS SAL_GAP
FROM EMP
GROUP BY DEPTNO
HAVING (MAX(SAL) - MIN(SAL)) >= 2500;

-- 직책이 'SALESMAN'인 사원 중, 커미션(COMM)이 급여(SAL)의 50%보다 많은 사원의 이름, 급여, 커미션을 조회하세요.
SELECT ENAME, SAL, COMM
FROM EMP
WHERE JOB = 'SALESMAN' AND COMM > (SAL * 0.5);

-- 사원들의 이름(ENAME)을 모두 소문자로 조회하고, 이름의 길이를 함께 출력하세요. 이름의 길이를 기준으로 내림차순 정렬하세요.
SELECT LOWER(ENAME) AS lower_name, LENGTH(ENAME) AS name_length
FROM EMP
ORDER BY name_length DESC;
    
-- 부서(DEPTNO)별로 급여가 2000 이상인 사원의 수와 2000 미만인 사원의 수를 각각 세어 조회하세요.
SELECT DEPTNO, COUNT(CASE WHEN SAL >= 2000 THEN 1 END) AS high_sal_count, COUNT(CASE WHEN SAL < 2000 THEN 1 END) AS low_sal_count
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

