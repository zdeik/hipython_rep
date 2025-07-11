use 분석실습;
-- 9.2.1 기간별 매출현황
SELECT
invoicedate
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
GROUP BY invoicedate
ORDER BY invoicedate;


-- 9.2.2 국가별 매출 현황
SELECT
country
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
GROUP BY country;


-- 9.2.3 국가별 X 제품별 매출 현황
SELECT
country
,stockcode
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
GROUP BY country, stockcode;

-- 9.2.4 특정 제품별 매출 지표(매출액, 주문수량) 파악
SELECT SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
where stockcode ='21615';

-- 9.2.5 특정 제품의 기간별 매출 현황
SELECT invoicedate
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
where stockcode IN('21615','21731')
GROUP BY invoicedate;

-- 9.3.1 2011년 9월 10일부터 2011년 9월 25일까지 약 15일동안 진행한 이벤트의 매출확인 - 이벤트 효과 분석(시기에 대한 비교)
SELECT CASE WHEN invoicedate between '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
			WHEN invoicedate between '2011-08-10' AND '2011-08-25' THEN '이벤트 기간(전월동기간)' END AS 기간구분
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
where invoicedate between '2011-09-10' AND '2011-09-25'
   OR invoicedate between '2011-08-10' AND '2011-08-25'
GROUP BY CASE WHEN invoicedate between '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
			  WHEN invoicedate between '2011-08-10' AND '2011-08-25' THEN '이벤트 기간(전월동기간)' END;
            
-- 9.3.2 2011년 9월 10일부터 2011년 9월 25일까지 특정제품(stockcode='17012A'및'17012C','17021','17084N')에 실시한 이벤트에 대해 해당 제품의 매출확인 -이벤트 제품 효과 분석(시기에 대한 비교)
SELECT CASE WHEN invoicedate between '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
			WHEN invoicedate between '2011-08-10' AND '2011-08-25' THEN '이벤트 기간(전월동기간)' END AS 기간구분
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
where (invoicedate between '2011-09-10' AND '2011-09-25'
   OR invoicedate between '2011-08-10' AND '2011-08-25')
  AND stockcode IN ('17012A','17012C','17021','17084N')
GROUP BY CASE WHEN invoicedate between '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
			  WHEN invoicedate between '2011-08-10' AND '2011-08-25' THEN '이벤트 기간(전월동기간)' END;

-- 9.4.1 2010년 12월 1일부터 2010년 12월 10일까지 특정제품(stockcode='21730'및'21615')을 구매한 고객 정보만 출력
-- 출력을 원하는 고객 정보는 고객ID, 이름, 성별, 생년월일, 가입 일자, 등급, 가입 채널
SELECT s.customerid
	   , c.customer_name
       , c.gd
       , c.birth_dt
       , grade
       , c.sign_up_ch
from (
	 select distinct customerid
     from sales
     where stockcode IN ('21730','21615') AND invoicedate between '2010-12-01' AND '2010-12-10'
) s
left join (
	 select mem_no
			, concat(last_name,first_name) AS customer_name
            , gd
            , birth_dt
            , entr_dt
			, grade
			, sign_up_ch
from customer
) c
ON s.customerid =c.mem_no;

-- 9.4.2 전체 멤버십 가입 고객중에서 구매 이력이 없는 고객과 구매 이력이 있는 고객정보를 구분 -미구매 고객 정보
-- step1: SALES테이블과 CUSTOMER 테이블을 결합하고 미구매 고객을 구분하는 쿼리를 CASE문을 사용해 작성
SELECT CASE WHEN s.CustomerID IS NULL THEN c.mem_no END AS non_purchaser
	   , c.mem_no
       , c.last_name
       , c.first_name
       , s.InvoiceNo
       , s.StockCode
       , s.Quantity
       , s.InvoiceDate
       , s.Unitprice
       , s.CustomerID
from customer c
left join sales s ON c.mem_no =s.CustomerID;

-- 9.4.2
-- step2: 전체 고객수와 미구매 고객수를 계산
select count(distinct case when s.CustomerID is null then c.mem_no end) as non_purchaser
	   , count(distinct c.mem_no) as total_customer
       from customer c
left join sales s on c.mem_no = s.CustomerID;

-- 9.5.1 A 브랜드 매장의 매출 평균 지표 ATV, AMV, Avg.Frq, Avg.Unit의 값 파악
SELECT SUM(unitprice*quantity) AS 매출액
	   , SUM(quantity) AS 주문수량
	   , COUNT(DISTINCT invoiceno) AS 주문건수
	   , COUNT(DISTINCT customerid) AS 주문고객수
	
	   , SUM(unitprice*quantity)/COUNT(DISTINCT invoiceno) as ATV
       , SUM(unitprice*quantity)/COUNT(DISTINCT customerid) as AMV
       , SUM(quantity) * 1.00 / COUNT(DISTINCT invoiceno) AS AvgUnits
FROM sales;

-- 9.5.2 연도 및 월별 매출 평균지표 ATV, AMV, Avg.Frq, Avg.Unit의 값 파악
SELECT year(InvoiceDate) as 연도
	   , month(InvoiceDate) as 월
	   , SUM(unitprice*quantity) AS 매출액
	   , SUM(quantity) AS 주문수량
	   , COUNT(DISTINCT invoiceno) AS 주문건수
	   , COUNT(DISTINCT customerid) AS 주문고객수
	
	   , SUM(unitprice*quantity)/COUNT(DISTINCT invoiceno) as ATV
       , SUM(unitprice*quantity)/COUNT(DISTINCT customerid) as AMV
       , SUM(quantity) * 1.00 / COUNT(DISTINCT invoiceno) AS AvgUnits
FROM sales
group by 연도, 월
order by 1,2;

-- 9.6.1 2011년에 가장 많이 판매된 제품 top10의 정보 확인
SELECT 
    stockcode,
    description,
    SUM(Quantity) AS qty
FROM sales
WHERE YEAR(InvoiceDate) = '2011'
GROUP BY stockcode, description
ORDER BY 
    qty DESC
LIMIT 10;

-- 9.6.2 국가별로 가장 많이 판매된 제품 순으로 실적 구하기
SELECT 
    ROW_NUMBER() OVER (PARTITION BY country ORDER BY qty DESC) AS rnk,
    country,
    stockcode,
    description,
    qty
FROM (
    SELECT 
        country,
        stockcode,
        description,
        SUM(quantity) AS qty
    FROM sales
    GROUP BY country, stockcode, description
) a
ORDER BY country, rnk;

-- 9.6.3 20대 여성 고객이 가장 많이 구매한 제품 top 10의 정보 확인
SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY qty DESC) AS rnk,
        stockcode,
        description,
        qty
    FROM (
    SELECT 
        stockcode,
        description,
        SUM(quantity) AS qty
	from sales s
    left join customer c
    on s.customerid=c.mem_no
    where c.gd = 'F'
    and 2023-year(c.birth_dt) between '20' and '29'
    GROUP BY stockcode, description
    ) a
    
) aa
where rnk <= 10;

-- 9.7.1 특정제품(stockcode = '20725')과 함꼐 가장 많이 구매한 제품 top10의 정보 확인
-- step1: 특정 제품(stockcode = '20725')을 구매한 거래 내역확인
select distinct invoiceno
from sales
where stockcode = '20725';

-- step2: 1단계에서 확인한 거래 내역 중 특정 제품을 제외하고 구매한 제품 확인
select *
from sales s
inner join(
			select distinct invoiceno
			from sales
			where stockcode = '20725'
) i
on s.invoiceno = i.invoiceno
where s.stockcode <> '20725'; 

-- step3: 특정 제품과 함께 구매한 제품의 주문 수량을 구하고 주문 수량이 높은 순서대로 상위 10개만 나열합니다.
SELECT 
    s.stockcode,
    s.description,
    SUM(s.quantity) AS total_quantity
FROM sales s
INNER JOIN (
    SELECT DISTINCT invoiceno
    FROM sales
    WHERE stockcode = '20725'
) i ON s.invoiceno = i.invoiceno
WHERE s.stockcode <> '20725'
GROUP BY s.stockcode, s.description
ORDER BY total_quantity DESC
LIMIT 10;

-- 9.7.2 특정제품과 함께 가장 많이 구매한 제품 TOP 10의 정보를 확인하고싶습니다. 단 이중에서 제품명에 LUNCH가 포함된 제품은 제외
SELECT 
    s.stockcode,
    s.description,
    SUM(s.quantity) AS qty
FROM sales s
INNER JOIN (
    SELECT DISTINCT invoiceno
    FROM sales
    WHERE stockcode = '20725'
) i ON s.invoiceno = i.invoiceno
WHERE s.stockcode <> '20725'
  AND s.description NOT LIKE '%LUNCH%'
GROUP BY s.stockcode, s.description
ORDER BY qty DESC
LIMIT 10;

-- 9.8.1 쇼핑몰의 재구매 고객수를 확인
SELECT COUNT(distinct customerid) AS repurchaser_count
FROM (
    SELECT customerid, count(distinct InvoiceDate) as frq
    FROM sales
    where customerid <> ''
    GROUP BY customerid
    HAVING COUNT(DISTINCT InvoiceDate) >= 2
) a;

-- 9.8.2 특정제품의 재구매 고객수와 구매일자 순서 확인
SELECT COUNT(distinct customerid) AS repurchaser_count
FROM (
    SELECT customerid, dense_rank() over (partition by customerid order by InvoiceDate) as rnk
    FROM sales
    WHERE customerid <> ''
      AND stockcode = '21088'
) a
where rnk =2;

-- 9.8.3 2010년 구매 이력이 있는 고객들의 2011년 유지율을 확인
SELECT COUNT(DISTINCT customerid) AS retention_customer_count
FROM sales
WHERE customerid IN (
    SELECT customerid
    FROM sales
    WHERE customerid <> ''
      AND YEAR(InvoiceDate) = '2010'
  )
  AND YEAR(InvoiceDate) = '2011';

-- 9.8.4 고객별로 첫 구매 이후 재구매까지의 구매 기간 확인
-- step1: 고객별로 제품을 구매한 순서를 정한다.
SELECT customerid
  , InvoiceDate
  , dense_rank() over (partition by customerid order by InvoiceDate) as day_no
from (
		select CustomerID, InvoiceDate
        from sales
        where CustomerID <> ''
        group by CustomerID, InvoiceDate
) a;

-- step2: step1에서 확인한 순서를 바탕으로 첫 구매와 재구매 기간을 확인합니다.
SELECT 
    aa.CustomerID AS first_pur_CustomerID,
    aa.InvoiceDate AS first_pur_InvoiceDate,
    aa.day_no AS first_pur_day_no,
    bb.CustomerID AS second_pur_CustomerID,
    bb.InvoiceDate AS second_pur_InvoiceDate,
    bb.day_no AS second_pur_day_no
FROM (
    SELECT 
        CustomerID,
        InvoiceDate,
        DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS day_no
    FROM (
        SELECT 
            CustomerID,
            InvoiceDate
        FROM sales
        WHERE CustomerID <> ''
        GROUP BY CustomerID, InvoiceDate
    ) a
) aa
LEFT JOIN (
    SELECT 
        CustomerID,
        InvoiceDate,
        DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS day_no
    FROM (
        SELECT 
            CustomerID,
            InvoiceDate
        FROM sales
        WHERE CustomerID <> ''
        GROUP BY CustomerID, InvoiceDate
    ) b
) bb
    ON aa.CustomerID = bb.CustomerID
    AND aa.day_no + 1 = bb.day_no
WHERE aa.day_no = 1
  AND bb.day_no = 2;
  
-- step3: 첫 구매와 재구매 기간의 차이를 계산합니다.
SELECT 
    aa.CustomerID AS first_pur_CustomerID,
    aa.InvoiceDate AS first_pur_InvoiceDate,
    aa.day_no AS first_pur_day_no,
    bb.CustomerID AS second_pur_CustomerID,
    bb.InvoiceDate AS second_pur_InvoiceDate,
    bb.day_no AS second_pur_day_no
    , DATEDIFF(bb.InvoiceDate, aa.InvoiceDate) AS purchase_period
FROM (
    SELECT 
        CustomerID,
        InvoiceDate,
        DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS day_no
    FROM (
        SELECT 
            CustomerID,
            InvoiceDate
        FROM sales
        WHERE CustomerID <> ''
        GROUP BY CustomerID, InvoiceDate
    ) a
) aa
LEFT JOIN (
    SELECT 
        CustomerID,
        InvoiceDate,
        DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS day_no
    FROM (
        SELECT CustomerID, InvoiceDate
        FROM sales
        WHERE CustomerID <> ''
        GROUP BY CustomerID, InvoiceDate
    ) b
) bb
    ON aa.CustomerID = bb.CustomerID AND aa.day_no + 1 = bb.day_no
WHERE aa.day_no = 1
  AND bb.day_no = 2;
  
-- step4: 구매 기간 차이 일수에 대한 평균 지표를 구하는 집계 함수를 구합니다.
SELECT AVG(purchase_period) AS avg_purchase_period
FROM (
    SELECT 
        aa.CustomerID AS first_pur_CustomerID,
        aa.InvoiceDate AS first_pur_InvoiceDate,
        aa.day_no AS first_pur_day_no,
        bb.CustomerID AS second_pur_CustomerID,
        bb.InvoiceDate AS second_pur_InvoiceDate,
        bb.day_no AS second_pur_day_no,
        DATEDIFF(bb.InvoiceDate, aa.InvoiceDate) AS purchase_period
    FROM (
        SELECT CustomerID, InvoiceDate,
            DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS day_no
        FROM (
            SELECT CustomerID, InvoiceDate
            FROM sales
            WHERE CustomerID <> ''
            GROUP BY CustomerID, InvoiceDate
        ) a
    ) aa
    LEFT JOIN (
        SELECT CustomerID, InvoiceDate,
            DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS day_no
        FROM (
            SELECT CustomerID, InvoiceDate
            FROM sales
            WHERE CustomerID <> ''
            GROUP BY CustomerID, InvoiceDate
        ) b
    ) bb
        ON aa.CustomerID = bb.CustomerID 
        AND aa.day_no + 1 = bb.day_no
    WHERE aa.day_no = 1
      AND bb.day_no = 2
) aaa;






