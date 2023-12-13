-- 오라클 6일차 오라클 객체 Role
-- ====================== 3. ROLE
-- 관리자계정
-- 사용자에게 여러 개의 권한을 한번에 부여할 수 있는 데이터베이스 객체
-- 사용자에게 권한을 부여할 때 한 개씩 부여하게 되면 권한 부여 및 회수가 불편함.
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER KH IDENTIFIED BY KH;
GRANT CONNECT, RESOURCE TO KH;
CREATE ROLE VIEWRESOURCE;
-- DROP ROLE VIEWRESOURCE;

-- DCL(Data Control Language) : GRANT / REVOKE
-- 권한부여 및 회수는 관리자 계정에서
-- 관리자 계정
-- sys : DB생성/ 삭제 권한, 로그인 옵션으로 as sysdba 지정
-- system : 일반관리자
-- ROLE에 부여된 시스템 권한
SELECT * FROM DBA_SYS_PRIVS WHERE ROLE = 'CONNECT';
-- 테이블 권한
SELECT * FROM ROLE_TAB_PRIVS;
--
-- KHUSER02가 KH의 COFFEE 테이블을 조회할 수 있는 권한
GRANT SELECT ON KH.COFFEE TO KHUSER02;
GRANT INSERT ON KH.COFFEE TO KHUSER02;
-- 권한 회수
REVOKE SELECT ON KH.COFFEE FROM KHUSER02;
REVOKE INSERT ON KH.COFFEE FROM KHUSER02;