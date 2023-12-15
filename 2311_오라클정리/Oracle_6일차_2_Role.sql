-- ����Ŭ 6���� ����Ŭ ��ü Role&DCL
-- ============================ 3. ROLE ===================================
-- -> ����ڿ��� ���� ���� ������ �ѹ��� �ο��� �� �ִ� �����ͺ��̽� ��ü
-- -> ����ڿ��� ������ �ο��� �� �� ���� �ο��ϰ� �Ǹ� ���� �ο� �� ȸ���� ������.
CREATE USER KH IDENTIFIED BY KH;
GRANT CONNECT, RESOURCE TO KH;

-- ROLE ������ ���������� �������.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE ROLE VIEWRESOURCE;
GRANT CREATE VIEW TO VIEWRESOURCE;
--DROP ROLE VIEWRESOURCE;
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'VIEWRESOURCE';
-- DCL(Data Control Language) : GRANT / REVOKE
-- ���Ѻο� �� ȸ���� ������ ����(������)���� ��밡��
-- ������ ����
-- 1. sys : DB ����/���� ���� ����, �α��� �ɼ����� as sysdba ����
-- 2. system : �Ϲݰ�����
-- ROLE�� �ο��� �ý��� ����
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'CONNECT'; -- KH�������� ���
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'CONNECT'; -- �����ڰ������� ���
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RESOURCE'; -- �����ڰ������� ���
-- ROLE�� �ο��� ���̺� ����
SELECT * FROM ROLE_TAB_PRIVS;

-- ������ �ο��� �Ѱ� ���� Ȯ��
SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_SYS_PRIVS;
-- ============================== GRANT �ǽ� ============================
-- ======================= TABLE ������ KH���� ���� ==================
CREATE TABLE COFFEE
(
    PRODUCT_NAME VARCHAR2(20) PRIMARY KEY,
    PRICE NUMBER NOT NULL,
    COMPANY VARCHAR2(20) NOT NULL
);
INSERT INTO COFFEE VALUES('ť���', 4300, 'MGC');
INSERT INTO COFFEE VALUES('����ڸ�', 5300, 'STARBUCKS');
INSERT INTO COFFEE VALUES('�ƾ�', 2500, '�ƽ�');
INSERT INTO COFFEE VALUES('�ƹٶ�', 5500, 'Ŀ�Ǻ�');
SELECT * FROM COFFEE;
DROP TABLE COFFEE;
--========================================================================
--=========================== KHUSER02���� ������ =========================
-- KHUSER02���� KH���� ������ COFFEE ���̺��� ��ȸ�ϰ��� ��.
SELECT * FROM KH.COFFEE;
-- ���ٰ� ����..��?? KHUSER02�� KH������ COFFEE�� ��ȸ�� ������ ����
-- �׷��ٸ� ��ȸ�� �� �ִ� ������ �ο��غ���!!
--========================================================================
--=========================== system���� ������ ===========================
-- KHUSER02�� KH�� COFFEEE ���̺��� SELECT�� �� �ִ� ������ �ο�
GRANT SELECT ON KH.COFFEE TO KHUSER02; 
-- Grant��(��) �����߽��ϴ�.
--=======================================================================
--=========================== KHUSER02���� ������ ========================
-- SELECT ���� �ο� �� �ٽ� ������ ��ȸ
SELECT * FROM KH.COFFEE;
-- COFFEE ���̺��� ���ٴ� ���� �޽����� �ȳ���. ���Ѻο� �����Ͽ� ��ȸ ��������.
-- ���Ѻο� �� ���̺��� Ȯ���� �����ϳ� INSERT �� COMMIT���� �ʾƼ� �����Ͱ� ����.
-- KH ���ǿ��� COMMIT�� ���־�� ��ȸ�� ��������
--=========================== KH���� ������ =============================
COMMIT;
--=========================== system���� ������ ===========================
-- ���� ȸ��
REVOKE SELECT ON KH.COFFEE FROM KHUSER02;
-- Revoke��(��) �����߽��ϴ�.
--=========================== KHUSER02���� ������ ========================
-- SELECT ���� ȸ�� �� �ٽ� ������ ��ȸ
SELECT * FROM KH.COFFEE;
-- ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�
--=======================================================================

--INSERT ���� �ο� �ǽ�
--=========================== KHUSER02���� ������ ========================
INSERT INTO KH.COFFEE
VALUES('ī����ī��', 1500, 'ī��');
-- SQL ����: ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�
--=========================== system���� ������ ===========================
GRANT INSERT ON KH.COFFEE TO KHUSER02;
-- Grant��(��) �����߽��ϴ�.
--=========================== KHUSER02���� ������ ========================
INSERT INTO KH.COFFEE
VALUES('ī����ī��', 1500, 'ī��');
COMMIT;
--=========================== KH���� ������ ========================
SELECT * FROM COFFEE;
----=========================== system���� ������ ===========================
-- ���� ȸ��
REVOKE INSERT ON KH.COFFEE FROM KHUSER02;
-- Revoke��(��) �����߽��ϴ�.
--=========================== KHUSER02���� ������ ========================
INSERT INTO KH.COFFEE
VALUES('ī����ī��', 1500, 'ī��');
-- ������ ȸ���Ǿ����Ƿ� INSERT�� ���� ���� Ȯ��
-- SQL ����: ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�.












SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT';
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'RESOURCE';
SELECT * FROM USER_SYS_PRIVS;