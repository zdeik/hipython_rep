USE WNTRADE;
create OR replace view VIEW_사원_여
AS
select 사원번호
	,이름
	,집전화 AS 전화번호
    ,입사일
    ,주소
    ,성별
FROM 사원
WHERE 성별 = '여'
with check option;

select * FROM VIEW_사원_여;

create OR replace view VIEW_제품별주문수량합
AS
select 제품명
	,SUM(주문수량) AS 주문수량량
FROM 제품
inner join 주문세부
ON 제품.제품번호 = 주문세부.제품번호
group by 제품명;

describe VIEW_제품별주문수량합;
SHOW create view VIEW_제품별주문수량합;


insert INTO VIEW_사원_여(
사원번호, 이름, 전화번호, 입사일, 주소, 성별)
values
-- ('E12','황여름','(02)587-4989','2023-02-10','서울시 강남구 청담동 23-5', '여')
('E16','박수혁','(02)587-4989','2023-02-10','서울시 강남구 청담동 23-5', '남');

describe 사원;
select * 
FROM 사원;
-- where 사원번호 ='E15';

-- 뷰: 가상의 테이블, 데이터 복재x, 쿼리만 저장 -> create,alter,DROP,SELECT
-- 인덱스
-- 기본인덱스(1 PK) + 보조인덱스(0...N)
-- 복합인덱스: 
create table 날씨
(
년도 int
,월 int
,일 int
,도시 varchar(20)
,기온 numeric(3,1)
,습도 int
,primary key(년도, 월, 일, 도시)
,index 기온인덱스(기온)
,index 도시인덱스(도시)
);

--
USE 분석실습;
CREATE OR replace view view_sales_summary AS
select
COUNTRY,
STOCKCODE,
SUM(Quantity) AS TOTAL_Quantity,
SUM(Quantity * UnitPrice) AS TOTAL_SALES
FROM SALES
group by COUNTRY, StockCode;

select *
FROM view_sales_summary
where COUNTRY = 'United Kingdom';

SHOW create view view_sales_summary;

SHOW INDEX FROM SALES;

create INDEX idx_customer_date ON SALES(CustomerID,InvoiceDate);
SHOW INDEX FROM SALES;

-- explain analyze
select * FROM SALES
where CustomerID = 17850 AND InvoiceDate >= '2010-12-01';

ALTER TABLE SALES DROP INDEX idx_customer_date;

-- explain analyze
select * FROM SALES
where CustomerID = 17850 AND InvoiceDate >= '2010-12-01';

-- INDEX LIKE 예시
explain analyze
select * FROM SALES
where CustomerID LIKE '%17850' AND InvoiceDate >= '2010-12-01';

--
use 분석실습;

SELECT *
FROM sales
WHERE Quantity BETWEEN 8 AND 9; -- 0.015sec, 0.016

-- 수량 인덱스
CREATE INDEX idx_quantity ON sales(Quantity);

ALTER TABLE sales DROP INDEX idx_quantity;

-- 또는 단가 인덱스
CREATE INDEX idx_unitprice ON sales(UnitPrice);

EXPLAIN analyze
SELECT *
FROM sales
WHERE Quantity BETWEEN 8 AND 9;

EXPLAIN
SELECT *
FROM sales FORCE INDEX (idx_quantity)
WHERE Quantity BETWEEN 5 AND 10;

EXPLAIN
SELECT /*+ INDEX(sales idx_quantity) */ Quantity
FROM sales
WHERE Quantity BETWEEN 5 AND 10;




