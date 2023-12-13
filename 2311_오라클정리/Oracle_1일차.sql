-- 관리자 계정 sys, system 차이
-- 1. sys : 슈퍼관리자 (+데이터베이스 생성/삭제 권한 있음)
-- 로그인 할때 로그인 옵션이 필요한 as sysdba를 써줘야 함.
-- 2. system : 일반관리자

SHOW USER;
-- DDL(Data Definition Language) 데이터 정의어
-- 첫번째 계정 생성 c## 붙여서 생성해야 했음.
CREATE USER c##KHUSER01 IDENTIFIED BY KHUSER01;
DROP USER c##KHUSER01;
GRANT CONNECT TO c##KHUSER01;

-- c## 안써도 되도록 명령어 실행
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 데이터를 삽입할 때 권한이 걸리지 않게 해주는 명령어 실행
ALTER USER KHUSER02 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER USER KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
Grant Unlimited Tablespace To Kh;

-- 계정 하나더 생성해보기, 계정 생성할때는 관리자계정에서 해야함.
-- ID는 KHUSER02, PW는 KHUSER02(대소문자 구분)
CREATE USER KHUSER02 IDENTIFIED BY KHUSER02;
-- 생성했다고 접속되는 것이 아니라 접속 권한을 부여해야 함.
GRANT CONNECT TO KHUSER02;
GRANT RESOURCE TO KHUSER02;


SELECT * FROM DICT;
-- 주석

-- KH 계정(비번도 KH)을 만들고 접속권한과 테이블 생성권한을 부여해주세요.
-- 그리고 녹십자로 접속까지해주세요~
CREATE USER KH IDENTIFIED BY KH;
GRANT CONNECT, RESOURCE TO KH;


