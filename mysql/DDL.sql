-- CREATE
create database WNCAMP_CLASS;
USE WNCAMP_CLASS;
create table 학과
(
학과번호 CHAR(2)
,학과명 VARCHAR(20)
,학과장명 VARCHAR(20)
);

insert into 학과
values('AA','컴퓨터공학과','배경민')
	,('BB','소프트웨어학과','김남준')
    ,('CC','디자인융합학과','박선영');
    
    
select *
FROM 학과;

create table 학생
(
학번 CHAR(5)
,이름 VARCHAR(20)
,생일 DATE
,연락처 VARCHAR(20)
,학과번호 CHAR(2)
);

insert into 학생
values('S0001','이윤주','2020-01-30','01033334444','AA')
    ,('S0001','이승은','2021-02-23',NULL,'AA')
    ,('S0003','백재용','2018-03-31','01077778888','DD');
    
select *
FROM 학생;

create table 회원
(
아이디 VARCHAR(20) primary KEY
,회원명 VARCHAR(20)
,키 INT
,몸무게 INT
,체질량지수 decimal(4,1) AS (몸무게 / power(키 / 100, 2)) stored
);

insert INTO 회원(아이디, 회원명, 키, 몸무게)
values('APPLE','김사과',178,70);

insert INTO 회원(아이디, 회원명, 키, 몸무게)
values('KIEDZ','이정석',187,81);

select *
FROM 학생;

-- ALTER, DROP
alter table 학생 ADD 성별 CHAR(1);  -- 컬럼 추가 생성
alter table 학생 modify column 성별 varchar(2);  -- 컬럼 타입변경
describe 학생;
ALTER table 학생 change column 성별 NEW_성별 CHAR(1); -- 컬럼 이름(타입)변경
alter table 학생 drop column NEW_성별;  -- 컬럼 삭제 
ALTER table 학생 rename NEW_학생; -- 테이블 이름변경
DROP database wncamp_class; -- DB 삭제
DROP table 학생; -- 테이블 삭제 

-- 제약조건: 무결성
-- PRIMARY KEY = NOT NULL + UNIQUE
-- CHECK, DEFAULT, FOREIGN KEY

create table 학과1
(
학과번호 CHAR(2) PRIMARY KEY
,학과명 VARCHAR(20) NOT NULL
,학과장명 VARCHAR(20)
);

create table 학생1
(
학번 CHAR(5) PRIMARY KEY
,이름 VARCHAR(20) NOT NULL
,생일 DATE NOT NULL
,연락처 VARCHAR(20) UNIQUE
,학과번호 CHAR(2) references 학과1(학과번호)
,성별 char(2) check(성별 IN ('남','여'))
,등록일 DATE default(curdate())
,foreign key(학과번호) references 학과1(학과번호)
);

insert into 학과1
values('AA','컴퓨터공학과','배경민')
	,('BB','소프트웨어학과','김남준')
    ,('CC','디자인융합학과','박선영');

insert into 학생1(학번, 이름, 생일, 학과번호)
values('S0001','이윤주','2020-01-30','AA');

select *
FROM 학생1;

insert into 학생1(이름, 생일, 학과번호)
values('이승은','2021-02-23','AA'); -- 학번이 PRIMARY KEY 인데 누락

insert into 학생1(학번, 이름, 생일, 학과번호)
values('S0003','백재용','2018-03-31','DD'); -- 참조하는 학과1의 학과번호가 'DD'가 없음
    
CREATE TABLE 과목
    (
       과목번호 CHAR(5) PRIMARY KEY
      ,과목명 VARCHAR(20) NOT NULL
      ,학점 INT NOT NULL CHECK(학점 BETWEEN 2 AND 4)
      ,구분 VARCHAR(20) CHECK(구분 IN ('전공','교양','일반'))
    );
    
select *
FROM 과목;

insert into 과목(과목번호, 과목명, 학점, 구분)
values('C0001','데이터베이스실습', 3, '전공'); -- 학점이 NOT NULL이라 필수값
insert into 과목(과목번호, 과목명, 구분, 학점)
values('C0002','데이터베이스 설계와 구축', '전공', 5); -- 학점이 2와4 사이값인데 5입력
insert into 과목(과목번호, 과목명, 구분, 학점)
values('C0003','데이터 분석', '전공', 3);

insert into 과목(과목번호, 과목명, 학점, 구분)
values('C0001','데이터베이스실습', 3, '전공'); -- 학점이 NOT NULL이라 필수값
insert into 과목(과목번호, 과목명, 구분, 학점)
values('C0002','데이터베이스 설계와 구축', '전공', 3); -- 학점이 2와4 사이값인데 5입력
insert into 과목(과목번호, 과목명, 구분, 학점)
values('C0003','데이터 분석', '전공', 3);

CREATE TABLE 수강_1
    (
       수강년도 CHAR(4) NOT NULL
      ,수강학기 VARCHAR(20) NOT NULL
                  CHECK(수강학기 IN ('1학기','2학기','여름학기','겨울학기'))
      ,학번 CHAR(5) NOT NULL
      ,과목번호 CHAR(5) NOT NULL
      ,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
      ,PRIMARY KEY(수강년도, 수강학기, 학번, 과목번호)
      ,FOREIGN KEY (학번) REFERENCES 학생1(학번)
      ,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
    );
    
select *
FROM 과목;

select *
FROM 수강_1;

select *
FROM 학생1;

insert into 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
values('2023','1학기', 'S0001','C0001',4.3);
insert into 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
values('2023','1학기', 'S0001','C0001',4.5); -- 중복된 PRIMARY KEY(수강년도, 수강학기, 학번, 과목번호)
insert into 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적) 
values('2023','1학기', 'S0001','C0002',4.6); -- 성적이 CHECK조건에 위반
insert into 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적) 
values('2023','1학기', 'S0002','C0009',4.3); -- 과목번호 'C0009'가 PRIMARY KEY에 없는 FOREIGN KEY


-- 수강_2 테이블 생성
CREATE TABLE 수강_2
    (
       수강번호 INT primary key auto_increment
	  ,수강년도 char(4) NOT NULL
      ,수강학기 VARCHAR(20) NOT NULL
                  CHECK(수강학기 IN ('1학기','2학기','여름학기','겨울학기'))
      ,학번 CHAR(5) NOT NULL
      ,과목번호 CHAR(5) NOT NULL
      ,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
      ,FOREIGN KEY (학번) REFERENCES 학생1(학번)
      ,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
    );
    describe 수강_2;
    
insert into 수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
values('2023','1학기', 'S0001','C0001',4.3);

insert into 수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
values('2023','1학기', 'S0001','C0001',4.5);  

select *
FROM 수강_2;

-- 제약조건의 삭제, 수정
alter table 학생1 add constraint check(학번 like 'S%'); -- 컬럼에 CHECK 제약조건 추가

select *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRANT_SCHEMA = 'wncamp_class'
AND TABLE_NAME = '학생1';

ALTER TABLE 학생1 DROP constraint 연락처;

--

show create table 제품;

use wntrade;
-- 제품 테이블의 재고 컬럼 '0보다 크거나 같아야 한다'
alter table 제품 add constraint check(재고 >= 0);

-- 제품테이블 재고금액 컬럼 추가 '단가*재고' 자동 계산, 저장
alter table 제품 drop 재고금액;
alter table 제품 ADD 재고금액 INT AS (단가 * 재고) STORED;

select 단가, 재고, 재고금액
from 제품;

-- 제품 레코드 삭제시 주문 세부 테이블의 관련 레코드도 함께 삭제되도록 주문 세부 테이블에 설정
show create table 주문세부;
ALTER TABLE 주문세부 ADD CONSTRAINT fk_제품
FOREIGN KEY (제품번호)
REFERENCES 제품(제품번호)
ON DELETE CASCADE;



