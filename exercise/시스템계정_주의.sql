-- ������ ����
-- 1. sys : ���۰����� (�����ͺ��̽� ����.���� ����)
-- �α��� �Ҷ� �α��� �ɼ��� �ʿ��� as sysdba�� ����� ��
-- 2. system : �Ϲݰ�����

-- DDL (Data Definition Language) ������ ���Ǿ�
show user;
-- ����� ���� '���̵�' ��й�ȣ BY '��й�ȣ';
create user C##KHUSER01 IDENTIFIED BY KHUSER01;
GRANT CONNECT TO c##KHUSER01;

-- C## ���� ��ɾ� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER KHUSER02 IDENTIFIED BY KHUSER02;
GRANT CONNECT TO KHUSER02;
-- ���Ѻο�
GRANT RESOURCE TO KHUSER02;
-- ���� ����
DROP USER C##KHUSER01;
-- ������ ���� �� ������ �ɸ��� �ʰ� ���ִ� ��ɾ�
ALTER USER KHUSER02 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
-- ������ insert�ϱ� ���� ��ɾ�
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