-- ������ ���� sys, system ����
-- 1. sys : ���۰����� (+�����ͺ��̽� ����/���� ���� ����)
-- �α��� �Ҷ� �α��� �ɼ��� �ʿ��� as sysdba�� ����� ��.
-- 2. system : �Ϲݰ�����

SHOW USER;
-- DDL(Data Definition Language) ������ ���Ǿ�
-- ù��° ���� ���� c## �ٿ��� �����ؾ� ����.
CREATE USER c##KHUSER01 IDENTIFIED BY KHUSER01;
DROP USER c##KHUSER01;
GRANT CONNECT TO c##KHUSER01;

-- c## �Ƚᵵ �ǵ��� ��ɾ� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- �����͸� ������ �� ������ �ɸ��� �ʰ� ���ִ� ��ɾ� ����
ALTER USER KHUSER02 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER USER KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
Grant Unlimited Tablespace To Kh;

-- ���� �ϳ��� �����غ���, ���� �����Ҷ��� �����ڰ������� �ؾ���.
-- ID�� KHUSER02, PW�� KHUSER02(��ҹ��� ����)
CREATE USER KHUSER02 IDENTIFIED BY KHUSER02;
-- �����ߴٰ� ���ӵǴ� ���� �ƴ϶� ���� ������ �ο��ؾ� ��.
GRANT CONNECT TO KHUSER02;
GRANT RESOURCE TO KHUSER02;


SELECT * FROM DICT;
-- �ּ�

-- KH ����(����� KH)�� ����� ���ӱ��Ѱ� ���̺� ���������� �ο����ּ���.
-- �׸��� ����ڷ� ���ӱ������ּ���~
CREATE USER KH IDENTIFIED BY KH;
GRANT CONNECT, RESOURCE TO KH;


