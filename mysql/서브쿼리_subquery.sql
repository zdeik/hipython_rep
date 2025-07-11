-- select 1개 테이블
-- join 2개 이상 테이블
-- 서브쿼리(내부쿼리)

-- select 컬럼
-- from 고객
-- inner join 주문
-- on 고객번호
-- where

-- select *
-- from 테이블
-- where 컬럼=(서브쿼리)

-- 종류
-- 1. 서브쿼리가 변환하는 행의 갯수: 단일행,복수행
-- 2. 서브쿼리의 위치에 따라: 조건절(where), from절, select절
-- 3. 상관서브쿼리: 메인쿼리와 서브쿼리 상관(컬럼)
-- 4. 반환하는 컬럼: 단일컬럼, 다중컬럼 서브쿼리

-- 단일행 서브쿼리
-- 6-1
select 고객회사명, 담당자명, 마일리지
from 고객
where 마일리지 =
	(
	select max(마일리지)
	from 고객
	);
    
select A.고객회사명, A.담당자명, A.마일리지
from 고객 A
left join 고객 B
on A.마일리지 < B.마일리지
where B.고객번호 IS NULL;

-- 6-2
select 고객회사명, 담당자명
from 고객
where 고객번호 =(
	select 고객번호  -- NARHA
    from 주문
    where 주문번호 = 'H0250'
    );
    
select 고객회사명, 담당자명
from 고객
where 고객번호 = 'NARHA';

select 고객회사명, 담당자명
from 고객
inner join 주문
on 고객.고객번호 = 주문.고객번호
where 주문번호 = 'H0250';

-- 6-3
select 담당자명, 고객회사명, 마일리지
from 고객
where 마일리지 > (
	select min(마일리지) -- 806
    from 고객
    where 도시 = '부산광역시'
    );
    
select 담당자명, 고객회사명, 마일리지
from 고객
where 마일리지 > 806;

-- 복수행 서브쿼리 IN,, ANY(최소값과 비교), SOME, ALL(최대값과 비교), EXISTS
-- 6-4
select count(*) as 주문건수
from 주문
where 고객번호 in (
	select 고객번호
    from 고객
    where 도시 = '부산광역시'
    );
    
select 고객번호
from 고객
where 도시 = '부산광역시';

-- 6-5
select 담당자명, 고객회사명, 마일리지
from 고객
where 마일리지 > ANY (
	select 마일리지
    from 고객
    where 도시 = '부산광역시'
    );
    
select 담당자명, 고객회사명, 마일리지
from 고객
where 마일리지 > ALL (
	select 마일리지
    from 고객
    where 도시 = '부산광역시'
    );
    
-- 6-7
select 고객번호, 고객회사명
from 고객
where exists  (
	select *
    from 주문
    where 주문.고객번호 = 고객.고객번호
    );
    
select 고객번호, 고객회사명
from 고객
where 고객번호 IN  (
	select distinct 고객번호
    from 주문
    );
    
select distinct 고객.고객번호, 고객회사명
from 고객
inner join 주문
ON 고객.고객번호 = 주문.고객번호;
    
-- 위치: WHERE에 존재하는 서브쿼리
-- GROUP BY 의 조건절에 사용하는 서브쿼리
select 도시, avg(마일리지) AS 평균
from 고객
GROUP BY 도시
having 평균 > (
	select AVG(마일리지)
    FROM 고객
    );
    
-- FROM 절의 서브쿼리: 인라인 뷰, 별명 필수
select 도시, avg(마일리지) AS 도시_평균마일리지
from 고객
GROUP BY 도시;

select  담당자명, 고객회사명, 마일리지, 고객.도시, 도시_평균마일리지, (도시_평균마일리지 - 마일리지) AS 마일리지차이
FROM 고객, (
select 도시, avg(마일리지) AS 도시_평균마일리지
from 고객
GROUP BY 도시
) AS 도시별요약
WHERE 고객.도시 = 도시별요약.도시;

-- 사원별 상사의 이름 출력을 인라인뷰로 구현
select  A.이름 AS 사원명, B.이름 AS 상사명
FROM 사원 A
join(
select 사원번호, 이름
from 사원
) B
ON A.사원번호 = B.사원번호;

-- 제품별 총 주문 수량과 제고 비교를 인라인뷰로 구현
select  제품명, 재고, 총주문수량, (재고-총주문수량) AS 재고차이
FROM 제품 A
join
	(
	select 제품번호, SUM(주문수량) AS 총주문수량
	from 주문세부
    GROUP BY 제품번호
	) B
ON A.제품번호 = B.제품번호
ORDER BY 재고차이 ASC;

-- 고객별 가장 최근 주문일 출력
select A.고객번호, 최근주문일
FROM 고객 A
join
	(
	select 고객번호, MAX(주문일)  AS 최근주문일
	from 주문
    GROUP BY 고객번호
	) B
ON A.고객번호 = B.고객번호;
-- 인라인뷰 조인: 유지보수 관점에서는 되도록이면 조인을 추천

-- 스칼라 서브쿼리
select 고객번호,(
	select MAX(주문일)
    FROM 주문
    WHERE 주문.고객번호 = 고객.고객번호
) AS 최근주문일
FROM 고객;

-- 고객별 총주문건수
explain analyze
select 고객.고객번호, (
	select SUM(주문수량)
    FROM 주문세부
    WHERE 주문.주문번호= 주문세부.주문번호
) AS 총주문건수
FROM 고객
join 주문
ON 고객.고객번호 = 주문.고객번호;

-- 조인 
EXPLAIN ANALYZE
SELECT c.고객번호, SUM(od.주문수량) AS 총주문건수
FROM 고객 c
JOIN 주문 o ON c.고객번호 = o.고객번호
JOIN 주문세부 od ON o.주문번호 = od.주문번호
GROUP BY c.고객번호;

-- 제품별 마지막 주문단가
select 제품명, (
	select 단가
    FROM 주문세부
    join 주문 ON 주문세부.주문번호 = 주문.주문번호
    WHERE 주문세부.제품번호 = 제품.제품번호
    ORDER BY 주문일 DESC limit 1
) AS 마지막주문단가
FROM 제품;

-- 각 사원별 최대 주문수량
select 사원번호, 이름,(
	select max(주문수량)
    FROM 주문세부
    join 주문 ON 주문세부.주문번호 = 주문.주문번호
    WHERE 주문.사원번호 = 사원.사원번호
    ORDER BY 최대주문수량
) AS 주문수량
FROM 사원;

-- CTE: 임시테이블 정의, 쿼리 1개
-- WITH 도시요약 AS()

WITH 도시요약 AS(
select 도시, AVG(마일리지)AS 도시평균마일리지
FROM 고객
GROUP BY 도시
)
select 담당자명, 고객회사명, 마일리지, 고객.도시, 도시평균마일리지
FROM 고객
join 도시요약
ON 고객.도시 = 도시요약.도시;

-- 다중 컬럼 서브쿼리
-- 각 도시마다 최고 마일리지를 보유한 고객의 정보를 보이시오
select 고객회사명, 도시,  담당자명, 마일리지
FROM 고객
where (도시,마일리지) IN (
select 도시, MAX(마일리지)
FROM 고객
group by 도시
);

select A.고객회사명, A.도시, A.담당자명, A.마일리지
FROM 고객 AS A
join 고객 AS B
ON A.도시 = B.도시
group by A.고객회사명, A.도시, A.담당자명, A.마일리지
HAVING A.마일리지 = MAX(B.마일리지)
ORDER BY 1;