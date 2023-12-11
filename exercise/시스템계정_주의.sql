-- 관리자 계정
-- 1. sys : 슈퍼관리자 (데이터베이스 생성.삭제 권한)
-- 로그인 할때 로그인 옵션이 필요한 as sysdba를 써줘야 함
-- 2. system : 일반관리자

-- DDL (Data Definition Language) 데이터 정의어
show user;
-- 만든다 유저 '아이디' 비밀번호 BY '비밀번호';
create user C##KHUSER01 IDENTIFIED BY KHUSER01;
GRANT CONNECT TO c##KHUSER01;

-- C## 없이 명령어 실행
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER KHUSER02 IDENTIFIED BY KHUSER02;
GRANT CONNECT TO KHUSER02;
-- 권한부여
GRANT RESOURCE TO KHUSER02;
-- 유저 삭제
DROP USER C##KHUSER01;
-- 데이터 삽입 시 권한이 걸리지 않게 해주는 명령어
ALTER USER KHUSER02 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
-- 데이터 insert하기 위한 명령어
Grant Unlimited Tablespace To Kh;
-- -----------
CREATE USER KH IDENTIFIED BY KH;
GRANT CONNECT TO KH;
GRANT RESOURCE TO KH;
ALTER USER KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
-- ============================= 1211
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER CHUN IDENTIFIED BY CHUN;
GRANT CONNECT, RESOURCE TO CHUN;