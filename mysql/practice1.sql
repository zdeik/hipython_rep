show databases;
use wntrade;
show tables;

describe 고객;
show columns from 고객;

-- 셀렉션 명령 : 테이블에서 행단위로 추출
select count(*) FROM 고객; -- 93건
select count(*) from 주문; -- 830건

select *
from information_schema.tables
WHERE table_schema = 'wntrade';

select * -- 어떤 컬럼 지정
from 고객;

-- 프로젝션 연산
select 고객번호, 고객회사명, 담당자명 -- 어떤 컬럼 지정
from 고객
where 담당자명 ='이은광'; -- 셀렉션 연산주문일
-- 쿼리 연산 : 각 테이블의 데이터를 셀렉션, 프로젝션 하기
-- 프로젝션->> 컬럼 ALIAS, 연산식, 함수

select 고객회사명, 담당자명 AS 이름, 담당자직위 AS 직위,마일리지, 마일리지 *1.1 AS '인상된 마일리지'
from 고객
where 마일리지>100000
ORDER BY 직위 desc; -- 디폴트: ASC: 오름차순

select *
from 주문
where 요청일 ='2020-04-24';

select 제품명, 단가
from 제품
where 단가 >= 3000;

select *
from 마일리지등급;

select *
from 부서;

select *
from 사원;

select *
from 제품;

select *
from 주문;

select *
from 주문세부;
-------------------
select *
FROM 고객
limit 3;

-- 마일리지가 많은 TOP3 고객
select *
FROM 고객
ORDER BY 마일리지 DESC
limit 3;

select distinct 도시
from 고객;
-- DISTINCT, ORDER BY, ASC, DESC

-- 1. SQL 문에서는 대소문자 구분이 없다 - 키워드,객체명,모두
-- 2. 꼭 한줄에 쓰지 않아도 된다 ;로 구분한다
-- 3. 가독성을 위해 줄을 맞춰 쓴다.
-- 4. 일반적으로 카워드는 대문자, 객체명은 소문자로 입력한다.
-- 5. 프로젝션에서 지정한 컬럼의 순서가 결과 출력의 순서이다.

-- 산술, 비교, 논리,집합 연산자
select 23 + 5 AS 더하기,
23 - 5 AS 빼기;

-- 2-8, 2-9 예제
-- 담당자가 '대표 이사'가 아닌 고객의 모든 정보
select *
FROM 고객
WHERE 담당자직위 <> '대표이사';

-- 주문일이'2020-3-16'일 이전인 주문목록
select *
FROM 주문
WHERE 주문일 < '2020-3-16';
-- 논리연산자: AND, OR, NOT

-- 도시가 '부산광역시'이면서 마일리지가 1,000점보다 작은 고객의 모든정보를 보이시오.
select *
FROM 고객
where 도시 = '부산광역시' AND 마일리지 <= 1000;

-- 도시가 '서울특별시'이거나 마일리지가 5,000점보다 큰 고객의 모든정보를 보이시오.
select *
FROM 고객
where 도시 = '서울특별시' OR 마일리지 >= 5000;

-- 서울이 아닌 고객
select *
FROM 고객
where 도시 != '서울특별시';

-- 서울이 아닌데, 마일리지가 5000이상
select *
FROM 고객
where 도시 != '서울특별시' AND 마일리지 >= 5000;

-- 서울, 부산인 마일리지 많은 고객
select *
FROM 고객
where 도시 = '서울특별시' OR 도시 = '부산광역시'
order by 마일리지 desc;

-- 집합연산 : 합집합, UNION, UNIONALL
select *
FROM 고객
where 도시 = '부산광역시' AND 마일리지 >= 5000
union
select *
FROM 고객
where 도시 = '서울특별시' AND 마일리지 >= 5000
order by 1;

select 도시
FROM 고객
union ALL -- 103건 (중복행 그대로 반환)
select 도시 
FROM 사원;

select 도시
FROM 고객
union ALL -- 30건 (중복행 제거 반환)
select 도시 
FROM 사원;

-- 교집합 INTERSECTION
select distinct도시 FROM 고객
where 도시 IN(
select  distinct 도시 from 사원
);

-- 여집합 EXCEPT
select distinct도시 FROM 고객
where 도시 NOT IN(
select  distinct 도시 from 사원
); 

-- 합집합: 컬럼수와 컬럼의 데이터타입이 일치
-- 정열 : 전체쿼리 바깥에서 ORDER BY

-- IS NULL 연산자
-- NULL : 값없음 0, ''이 아님.

select *
FROM 고객
-- where 지역 = ''; -- 66ROW
where 지역 IS NULL;

UPDATE 고객
SET 지역 = null
where 지역 = '';

select COUNT(*) -- 66ROW
FROM 고객
where 지역  IS NULL;

-- IN: OR 연산
-- BETWEEN...AND... : AND 연산,범위 지정

-- 예제2-14
select 고객번호, 담당자명, 담당자직위
from 고객
where 담당자직위 = '영업 과장' OR 담당자직위 = '마케팅 과장';
-- 예제2-14(IN사용)
select 고객번호, 담당자명, 담당자직위
from 고객
where 담당자직위 IN('영업 과장','마케팅 과장');

-- 서울, 부천, 부산에 사는사원
select 이름, 도시
from 사원
where 도시 IN('서울특별시','부천시','부산광역시'); -- 컬럼/속성의 도메인 값을 확인

-- A1,A2 부서의 사원
select 이름, 도시, 부서번호
from 사원
where 부서번호 IN('A1','A2');

-- 마일리지가 100000점 이상 200000점 이하인 고객에 대해 담당자명,마일리지를 보이시오
select 담당자명, 마일리지
from 고객
where 마일리지 >=100000 AND 마일리지 <= 200000;
-- BETWEEN...AND...사용
select 담당자명, 마일리지
from 고객
where 마일리지 BETWEEN 100000 AND 200000;

-- 주문이 6월 1달 동안 발생한 목록
select 주문번호, 고객번호, 주문일
from 주문
where 주문일 BETWEEN '2020-06-01' AND '2020-06-30';

-- 마일리지 7천대~9천대 인 고객 추출
select 고객번호, 마일리지
from 고객
where 마일리지 BETWEEN 7000 AND 9999;

-- LIKE 연산자 : , _(밑줄)
select *
from 고객
where 도시 LIKE '%광역시%';

-- 도시가 '광역시'이면서 고객번호 두 번째 글자 또는 세번째글자가 'C'인 고객의 모든정보 추출
select *
from 고객
where 도시 LIKE '%광역시%'AND (고객번호 LIKE '_C%' OR 고객번호 LIKE '__C%'); -- 3ROW
-- where 도시 LIKE '%광역시%'AND 고객번호 LIKE '_C%' OR 고객번호 LIKE '__C%'; 8ROW

-- 전화번호가 45로 끝나는 고객
select *
from 고객
where 전화번호 LIKE '%45';

-- 전화번호 중에 45가 있는 고객
select *
from 고객
where 전화번호 LIKE '%45%';

-- 서울에 사는 고객 중, 마일리지 15000점 이상 20000점 이하인 고객
select *
from 고객
where 도시 = '서울특별시' AND 마일리지 BETWEEN 15000 AND 20000;

-- 고객의 거주 (지역, 도시)를 1개씩 보이기 > 지역순, 동일지역은 도시순으로 출력
SELECT DISTINCT 지역, 도시
from 고객
order by 지역, 도시;

-- 춘천시, 과천시, 광명시 고객중 직위에 이사/사원이 있는 고객
select *
from 고객
where 지역 IN('춘천시','과천시','광명시') AND 담당자직위 IN ('이사','사원');

-- 광역시, 특별시가 아닌 고객중 마일리지가 많은 상위 고객 3명 
select *
from 고객
where 도시 NOT LIKE '%광역시' AND 도시 NOT LIKE '%특별시'
ORDER BY 마일리지 DESC
LIMIT 3;

-- 지역 값이 있는 고객, 담당자직위가 대표이사인 고객을 제외하고 출력
select *
from 고객
where  지역 IS NOT NULL AND 담당자직위 <> '대표이사';



