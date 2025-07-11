-- DROP DATABASE IF EXISTS 분석실습;

CREATE DATABASE 분석실습 DEFAULT CHARSET  utf8mb4 COLLATE  utf8mb4_general_ci;

USE 분석실습;

CREATE TABLE CUSTOMER (
    mem_no INT PRIMARY KEY,
    last_name VARCHAR(20),
    first_name VARCHAR(20),
    gd CHAR(1),
    birth_dt DATE,
    entr_dt DATE,
    grade VARCHAR(10),
    sign_up_ch CHAR(2)
);

CREATE TABLE SALES (
    InvoiceNo VARCHAR(10),
    StockCode VARCHAR(20),
    Description VARCHAR(100),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(50)
);

SELECT * FROM customer;

SELECT * FROM sales;