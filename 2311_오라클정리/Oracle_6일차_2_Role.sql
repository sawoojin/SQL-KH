-- 오라클 6일차 오라클 객체 Role&DCL
-- ============================ 3. ROLE ===================================
-- -> 사용자에게 여러 개의 권한을 한번에 부여할 수 있는 데이터베이스 객체
-- -> 사용자에게 권한을 부여할 때 한 개씩 부여하게 되면 권한 부여 및 회수가 불편함.
CREATE USER KH IDENTIFIED BY KH;
GRANT CONNECT, RESOURCE TO KH;

-- ROLE 생성은 빨간색에서 해줘야함.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE ROLE VIEWRESOURCE;
GRANT CREATE VIEW TO VIEWRESOURCE;
--DROP ROLE VIEWRESOURCE;
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'VIEWRESOURCE';
-- DCL(Data Control Language) : GRANT / REVOKE
-- 권한부여 및 회수는 관리자 세션(빨간색)에서 사용가능
-- 관리자 계정
-- 1. sys : DB 생성/삭제 권한 있음, 로그인 옵션으로 as sysdba 지정
-- 2. system : 일반관리자
-- ROLE에 부여된 시스템 권한
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'CONNECT'; -- KH계정에서 사용
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'CONNECT'; -- 관리자계정에서 사용
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RESOURCE'; -- 관리자계정에서 사용
-- ROLE에 부여된 테이블 권한
SELECT * FROM ROLE_TAB_PRIVS;

-- 계정에 부여된 롤과 권한 확인
SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_SYS_PRIVS;
-- ============================== GRANT 실습 ============================
-- ======================= TABLE 생성은 KH에서 진행 ==================
CREATE TABLE COFFEE
(
    PRODUCT_NAME VARCHAR2(20) PRIMARY KEY,
    PRICE NUMBER NOT NULL,
    COMPANY VARCHAR2(20) NOT NULL
);
INSERT INTO COFFEE VALUES('큐브라떼', 4300, 'MGC');
INSERT INTO COFFEE VALUES('허니자몽', 5300, 'STARBUCKS');
INSERT INTO COFFEE VALUES('아아', 2500, '맥심');
INSERT INTO COFFEE VALUES('아바라', 5500, '커피빈');
SELECT * FROM COFFEE;
DROP TABLE COFFEE;
--========================================================================
--=========================== KHUSER02에서 실행함 =========================
-- KHUSER02에서 KH계정 소유의 COFFEE 테이블을 조회하고자 함.
SELECT * FROM KH.COFFEE;
-- 없다고 나옴..왜?? KHUSER02는 KH계정의 COFFEE를 조회할 권한이 없음
-- 그렇다면 조회할 수 있는 권한을 부여해보자!!
--========================================================================
--=========================== system에서 실행함 ===========================
-- KHUSER02가 KH의 COFFEEE 테이블을 SELECT할 수 있는 권한을 부여
GRANT SELECT ON KH.COFFEE TO KHUSER02; 
-- Grant을(를) 성공했습니다.
--=======================================================================
--=========================== KHUSER02에서 실행함 ========================
-- SELECT 권한 부여 후 다시 데이터 조회
SELECT * FROM KH.COFFEE;
-- COFFEE 테이블이 없다는 오류 메시지는 안나옴. 권한부여 성공하여 조회 가능해짐.
-- 권한부여 후 테이블은 확인은 가능하나 INSERT 후 COMMIT하지 않아서 데이터가 없음.
-- KH 세션에서 COMMIT을 해주어야 조회가 가능해짐
--=========================== KH에서 실행함 =============================
COMMIT;
--=========================== system에서 실행함 ===========================
-- 권한 회수
REVOKE SELECT ON KH.COFFEE FROM KHUSER02;
-- Revoke을(를) 성공했습니다.
--=========================== KHUSER02에서 실행함 ========================
-- SELECT 권한 회수 후 다시 데이터 조회
SELECT * FROM KH.COFFEE;
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--=======================================================================

--INSERT 권한 부여 실습
--=========================== KHUSER02에서 실행함 ========================
INSERT INTO KH.COFFEE
VALUES('카누디카페', 1500, '카누');
-- SQL 오류: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--=========================== system에서 실행함 ===========================
GRANT INSERT ON KH.COFFEE TO KHUSER02;
-- Grant을(를) 성공했습니다.
--=========================== KHUSER02에서 실행함 ========================
INSERT INTO KH.COFFEE
VALUES('카누디카페', 1500, '카누');
COMMIT;
--=========================== KH에서 실행함 ========================
SELECT * FROM COFFEE;
----=========================== system에서 실행함 ===========================
-- 권한 회수
REVOKE INSERT ON KH.COFFEE FROM KHUSER02;
-- Revoke을(를) 성공했습니다.
--=========================== KHUSER02에서 실행함 ========================
INSERT INTO KH.COFFEE
VALUES('카누디카페', 1500, '카누');
-- 권한이 회수되었으므로 INSERT가 되지 않음 확인
-- SQL 오류: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다.












SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT';
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'RESOURCE';
SELECT * FROM USER_SYS_PRIVS;