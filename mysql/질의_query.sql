-- 함수 --
use wntrade;
select CHAR_LENGTH('HELLO'),length('HELLO'),CHAR_LENGTH('안녕'),length('안녕');
-- 날짜/시간형 함수
-- NOW(), SYSDATE(), CURDATE() & CURTIME()
-- 현재날짜+시간 가져오기: 
-- 쿼리 시작시점 NOW()
-- 함수 시작시점 SYSDATE()

select NOW() AS NOW_1
,sleep(5)
,SYSDATE() AS NOW_2
,CURDATE() AS SYS_1
,sleep(5)
,CURTIME() AS SYS_2;

-- 값을 구분해서 반환하는 함수
-- 기간 변환 함수
select NOW()
,datediff(NOW(), '2025-6-1') -- END, STAR
,timestampdiff(YEAR,NOW(),'2023-12-20') AS YEAR
,timestampdiff(MONTH,NOW(),'2024-12-20') AS MONTH
,timestampdiff(WEEK,NOW(),'2025-6-20') AS WEEK;

SELECT NOW()
,LAST_DAY(NOW()) -- 이번달의 마지막 일자
,DAYOFYEAR(NOW()) -- 오늘이 올해의 몇번째 날인지
,monthname(NOW()) -- 이번 달 이름을 영문으로
,weekday('2025-7-1'); -- 요일, 월요일 0~

-- 태어난지 몇일 되었나? DATEDIFF()
select NOW()
,DATEDIFF(NOW(),'2000-11-17') AS TOTAL_BORN_DAY;
-- 천일 기념일 ADDDATE()
select NOW()
,adddate(NOW(),1000) AS 1000_DAY;
-- 나는 몇요일의 아이일까? DAYNAME()
select NOW()
,DAYNAME('2000-11-17') AS WHAT_DAY;

-- 형변환
-- CAST( ): ANSI SQL
-- CONVERT( ): MYSQL
select CAST('1' AS unsigned)
,cast(2 AS CHAR(1))
,CONVERT('1', unsigned)
,CONVERT(2, CHAR(1));

-- 제어 함수
-- IF(): 조건식, 참값, 거짓값
SELECT IF (12500 * 450 > 5000000, '초과달성', '미달성');

-- IFNULL(속성, 2): 널처리 ->속성, 널일때 2
select 지역
from 고객
WHERE 지역 IS NULL;

select 담당자명, ifnull(지역, '미입력')
FROM 고객;

-- NULLIF(수식1, 수식2): 두값이 같으면 NULL반환, 다르면 수식1 반환
select NULLIF(12*10, 120)
,NULLIF(12*10, 130);

select 고객번호, NULLIF(마일리지, 0) AS '유효마일리지'
FROM 고객;

-- CASE 문
/*select 컬럼명,
CASE WHEN 조건1 THEN 결과1
	WHEN 조건2 THEN 결과2
END
*/
select 
CASE WHEN 12500*450 >5000000 THEN '초과'
	WHEN 12500*450 >4000000 THEN '달성'
    ELSE '미달성'
END;

-- 고객, 마일리지 1만점>VIP, 5천점>GOLD, 1천점>SILVER, BRONZE
SELECT 고객번호, 고객회사명, 마일리지,
       CASE
           WHEN 마일리지 > 10000 THEN 'VIP'
           WHEN 마일리지 > 5000 THEN 'GOLD'
           WHEN 마일리지 > 1000 THEN 'SILVER'
           ELSE 'BRONZE'
       END AS 등급
FROM 고객;

-- 주문금액 = 수량*단가, 할인금액 = 주문금액*할인율, 실주문금액 = 주문금액 - 할인금액

-- 주문 세부주문

-- 사원테이블에서 이름, 생일, 만나이, 입사일, 입사일수 500일기념일 계산

-- 주문테이블에서 주문번호, 고객번호, 주문일, 년도, 분기, 월, 일, 요일, 한글로요일

-- 집계함수
-- COUNT()
select COUNT(*)
,COUNT(고객번호)
,COUNT(도시)
,COUNT(지역)
FROM 고객;

-- 조건부 집계
select SUM(마일리지)
,AVG(마일리지)
,MIN(마일리지)
,MAX(마일리지)
FROM 고객
WHERE 도시 = '서울특별시';

-- 그룹별 집계(소계): 컬럼값 -> 범주로 집계
-- GROUP BY
select 도시
,COUNT(*) AS 고객수 -- 서브셋의 레코드 전체 *
,AVG(마일리지) AS 평균마일리지
FROM 고객
group by 도시;

-- 집계 결과에 조건부 출력
select 도시
,count(*) AS 고객수
,AVG(마일리지) AS 평균마일리지
FROM 고객
group by 도시
having count(*) >= 10;

-- WHERE : 셀렉션의 조건, 그룹바이 이전에 실행
-- HAVING: GORUP BY 한 집계에 조건, 기준 미달인

select 제품번호, AVG(주문수량)
FROM 주문세부
WHERE 주문수량 >= 30
group by 제품번호
having AVG (주문수량) >= 50;

-- 예제 4-7
select 도시, SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
group by 도시
having SUM(마일리지) >= 1000;

-- SQL 실행순서
/*
5. SELECT
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
6. ORDER BY
*/

-- WITH ROLLUP: 합계 표시
select 도시
,count(*) AS 고객수
,AVG(마일리지) AS 평균마일리지
FROM 고객
group by 도시
WITH ROLLUP;


-- 4-9
SELECT 담당자직위, 도시, count(*) AS 고객수
FROM 고객
WHERE 담당자직위 LIKE '%마케팅%'
GROUP BY 담당자직위, 도시
WITH ROLLUP;

-- 고객 번호가 T로 시작하는 고객에 대해 도시별로 묶어서
-- 고객의 마일리지 합을 구하시오.
-- 이때 마일리지 합이 1,000점 이상인 레코드만 총계를 출력
SELECT 도시, SUM(마일리지) AS 합계
FROM 고객
WHERE 고객번호 LIKE 'T%'
GROUP BY 도시 WITH ROLLUP
HAVING SUM(마일리지) >= 1000;

-- 개선
select 도시, 합계
FROM (SELECT 도시, SUM(마일리지) AS 합계
	FROM 고객
	WHERE 고객번호 LIKE 'T%'
	GROUP BY 도시 WITH ROLLUP
) AS 그룹
WHERE(도시 IS NULL OR 합계>=1000);

-- GROUPING( )
SELECT 지역, count(*) AS 고객수
,IF(GROUPING(지역) = 1, '합계행', 지역) AS 도시명
,grouping(지역) AS 구분 -- 지역의 널값의 구분 짓기 위함 
FROM 고객
WHERE 담당자직위 = '대표 이사'
GROUP BY 지역
WITH ROLLUP;

select group_concat(distinct 고객회사명)
FROM 고객;

  
-- 성별에 따른 사원수, NULL>총 사원수를 출력
SELECT
    CASE
        WHEN 성별 IS NULL THEN '총 사원수'
        ELSE 성별
    END AS 성별,
    COUNT(*) AS 사원수
FROM
    사원
GROUP BY
    성별
WITH ROLLUP;
-- 성별에 따른 사원수, NULL>총 사원수를 출력
SELECT
IF(GROUPING(성별)=1, '총사원수', 성별) AS 성별,
    COUNT(*) AS 사원수
FROM
    사원
GROUP BY
    성별
WITH ROLLUP;

-- 주문년도별 주문건수
select year(주문일) AS 주문년도, COUNT(*) AS 주문건수
FROM 주문
group by year(주문일);

-- 주문년도별, 분기별, 전체주문건수 추가
select year(주문일) AS 주문년도, quarter(주문일) AS 분기, COUNT(*) AS 주문건수
FROM 주문
group by 주문년도,분기
with rollup;


-- 주문내역에서 월별 발송지연건 
select MONTH(주문일) AS 주문월, COUNT(*) AS 지연건수
FROM 주문
WHERE 발송일 > 요청일
group by 주문월
order by 주문월;

-- 아이스크림 제품별 재고합
select 제품명, count(*) AS '제품별 재고합'
FROM 제품
group by 제품명;

-- 고객구분(VIP,일반)에 따른 고객수, 평균 마일리지, 총합
SELECT
    CASE
        WHEN 마일리지 >= 100000 THEN 'VIP'
        ELSE '일반'
    END AS 고객구분,
    COUNT(*) AS 고객수,
    AVG(마일리지) AS '평균 마일리지',
    SUM(마일리지) AS 총합
FROM 고객
group by 고객구분;