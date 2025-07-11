-- 관계형 데이터베이스: 관계연산 - 프로젝션, 셀렉션, 조인 
-- 조인(Join)
-- 크로스 조인(Cross Join)
-- 내부 조인(Inner Join)
-- 외부 조인(Outer Join) LEFT,RIGHT
-- 셀프 조인(Self Join)
use wntrade;
-- ansi 
select *
from a 
JOIN B;

-- non ansi
select *
from a,b;

-- 크로스조인
select *
from 부서
cross join 사원
where 이름 = '이소미';

select *
from 부서, 사원
where 이름 = '이소미';

-- 고객,제품 크로스조인
select *
from 고객, 제품;

-- 내부 조인
-- 가장 일반적인 조인방식, 두 테이블에서 조건에 만족하는 행만 연결 추출
-- 연결컬럼을 찾아서 매핑
select 사원번호, 이름, 직위, 사원.부서번호, 부서명
from 사원
inner join 부서
on 사원.부서번호 = 부서.부서번호
where 이름 = '이소미';

-- 주문세부,제품 제품명을 연결
select 주문번호, 주문세부.제품번호, 제품명
from 주문세부
inner join 제품
on 주문세부.제품번호 = 제품.제품번호;

-- 주문, 고객
select 고객.고객번호, 담당자명, 고객회사명, count(*) as 주문건수
from 고객
inner join 주문
on 고객.고객번호 = 주문.고객번호
group by 고객번호, 담당자명, 고객회사명
order by 주문건수 desc;

-- 5-4
select 고객.고객번호, 담당자명, 고객회사명, sum(주문수량 * 단가) as 주문금액
from 고객
inner join 주문
on 고객.고객번호 = 주문.고객번호
inner join 주문세부
on 주문.주문번호 = 주문세부.주문번호
group by 고객번호, 담당자명, 고객회사명
order by 4 desc;

-- 5-5
select 고객번호, 담당자명, 마일리지, 마일리지등급.*
from 고객
CROSS JOIN 마일리지등급
WHERE 담당자명 = '이은광';

select 고객번호, 담당자명, 마일리지, 마일리지등급.*
from 고객
inner JOIN 마일리지등급
-- ON 마일리지 >= 하한마일리지 AND 마일리지 <= 상한마일리지
ON 마일리지 between 하한마일리지 AND 상한마일리지
WHERE 담당자명 = '이은광';

-- 카테시안 프로덕트: 법위성 테이블과 나올수 있는 모든 조합을 확인
-- 내부조인: 연결(컬럼)된 테이블에서 매핑된 컬럼을 가져올 때
-- 외부조인: 기존 테이블의 결과를 유지하면서 매핑된 컬럼을 가져오라 할때

-- 외부조인
-- LEFT,RIGHT, 양쪽 다 -> MYSQL은 지원 X

-- LEFT조인
-- 부서,사원-- '정수진' 사원이 부서가 null이라 inner join시 검색안됨 -> left 조인 사용
select 사원번호, 이름, 부서명
FROM 사원
left join 부서
on 사원.부서번호 = 부서.부서번호;

-- 주문, 고객 -- 고객명,주문 번호, 주문금액
select 주문.고객번호, 주문.주문번호, 단가
FROM 주문
left join 고객
on 주문.고객번호 = 고객.고객번호
inner join 주문세부
on  주문.주문번호 = 주문세부.주문번호;

-- 사원이 없는 부서
select 부서명, 이름
FROM 부서
left join 사원
on 부서.부서번호 = 사원.부서번호
where 사원.이름 is null;

-- 등급이 할당되지 않은 고객
select 고객번호, 등급명
FROM 고객
left JOIN 마일리지등급
ON 마일리지 between 하한마일리지 AND 상한마일리지
where 마일리지등급.등급명 is null;

-- 부서가 없는 직원과, 직원이 없는 부서 모두 출력
select 사원번호, 이름, 부서명
FROM 사원
left join 부서
on 사원.부서번호 = 부서.부서번호
where 부서.부서명 is null
union
select 사원번호, 이름, 부서명
FROM 사원
right join 부서
on 부서.부서번호 = 사원.부서번호
where 사원.이름 is null;

-- -내부조인 + 셀프조인
select 사원.이름, 사원.직위, 상사.이름 as 상사이름
from 사원
inner join 사원 as 상사
on 사원.상사번호 = 상사.사원번호;

-- 5-12 -- 외부조인 + 셀프조인
select 사원.이름, 사원.직위, 상사.이름 as 상사이름
from 사원 as 상사
right outer join 사원
on 사원.상사번호 = 상사.사원번호
order by 상사이름;

-- 주문, 고객 FULL OUTER JOIN <- MYSQL에서 지원안됨 -> FULL OUTER JOIN = LEFT JOIN  UNION  RIGHT JOIN
-- select *
-- from 주문
-- FULL  OUTER JOIN 고객 on 주문.고객번호 = 고객.고객번호;

-- 입사일이 빠른 선배-후배 관계 찾기


