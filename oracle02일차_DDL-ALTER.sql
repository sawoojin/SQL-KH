-- DDL (CREATE, DROP, ALTER) - Data Definition Language
-- ALTER (오라클 객체)
-- ALTER 를 이용한 제약조건 추가, 수정, 이름변경 해보기
-- ALTER 를 이용한 컬럼추가, 컬럼 수정, 컬럼명 수정, 컬럼 삭제, 테이블 변경 해보기
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SHOP_MEMBER';
-- CONSTTAINT TYPE
-- P : PRIMARY KEY
-- R : FOREIGN KEY
-- C : CHKECK OR NOT NULL
-- U : UNIQUE
CREATE TABLE USER_FOREIGNKEY_COPY
AS SELECT * FROM USER_FOREIGNKEY;
SELECT * FROM user_foreignkey_copy;
-- DELETE FROM user_foreignkey_copy = user_date;
-- 테이블에 컬럼 추가
ALTER TABLE user_foreignkey_copy
ADD USER_DATE DATE;
-- 테이블에 컬럼 삭제
ALTER TABLE user_foreignkey_copy
DROP COLUMN USER_DATE;
-- 테이블에 컬럼 수정(자료형 수정)
ALTER TABLE user_foreignkey_copy
MODIFY USER_DATE VARCHAR2(10);
-- 테이블에 컬럼명 수정
ALTER TABLE user_foreignkey_copy
RENAME COLUMN USER_DATE TO REG_DATE;
-- 테이블명 수정
ALTER TABLE user_foreignkey_copy
RENAME TO USER_ALTER_CHANE;

RENAME USER_ALTER_CHANE TO user_foreignkey_copy;
-- PK제약조건 추가
ALTER TABLE SHOP_BUY
ADD CONSTRAINT PK_BUY_NO PRIMARY KEY(BUY_NO);
-- FK제약조건 추가
ALTER TABLE SHOP_BUY
ADD CONSTRAINT FK_USER_ID FOREIGN KEY(USER_ID) REFERENCES SHOP_MAMBER(USER_ID);
-- 제약조건 삭제 * 제약조건명이 필요함
-- 확인방법 1. 테이블 클릭 > 제약조건 탭 / 2. SELECT문
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SHOP_BUY';
ALTER TABLE SHOP_BUY
DROP CONSTRAINT SYS_C007332;
-- 제약조건 수정
--> 삭제 후 추가
-- 제약조건 이름변경
ALTER TABLE SHOP_BUY
RENAME CONSTRAINT PK_BUY_NO TO PRIMARY_BUYNO;
-- 제약조건 활성화/비활성화
ALTER TABLE SHOP_BUY
DISABLE CONSTRAINT FK_USER_ID;
ALTER TABLE SHOP_BUY
ENABLE CONSTRAINT FK_USER_ID;
DROP TABLE DEPARTMENT;