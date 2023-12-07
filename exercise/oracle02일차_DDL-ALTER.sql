-- DDL (CREATE, DROP, ALTER) - Data Definition Language
-- ALTER (����Ŭ ��ü)
-- ALTER �� �̿��� �������� �߰�, ����, �̸����� �غ���
-- ALTER �� �̿��� �÷��߰�, �÷� ����, �÷��� ����, �÷� ����, ���̺� ���� �غ���
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
-- ���̺� �÷� �߰�
ALTER TABLE user_foreignkey_copy
ADD USER_DATE DATE;
-- ���̺� �÷� ����
ALTER TABLE user_foreignkey_copy
DROP COLUMN USER_DATE;
-- ���̺� �÷� ����(�ڷ��� ����)
ALTER TABLE user_foreignkey_copy
MODIFY USER_DATE VARCHAR2(10);
-- ���̺� �÷��� ����
ALTER TABLE user_foreignkey_copy
RENAME COLUMN USER_DATE TO REG_DATE;
-- ���̺�� ����
ALTER TABLE user_foreignkey_copy
RENAME TO USER_ALTER_CHANE;

RENAME USER_ALTER_CHANE TO user_foreignkey_copy;
-- PK�������� �߰�
ALTER TABLE SHOP_BUY
ADD CONSTRAINT PK_BUY_NO PRIMARY KEY(BUY_NO);
-- FK�������� �߰�
ALTER TABLE SHOP_BUY
ADD CONSTRAINT FK_USER_ID FOREIGN KEY(USER_ID) REFERENCES SHOP_MAMBER(USER_ID);
-- �������� ���� * �������Ǹ��� �ʿ���
-- Ȯ�ι�� 1. ���̺� Ŭ�� > �������� �� / 2. SELECT��
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SHOP_BUY';
ALTER TABLE SHOP_BUY
DROP CONSTRAINT SYS_C007332;
-- �������� ����
--> ���� �� �߰�
-- �������� �̸�����
ALTER TABLE SHOP_BUY
RENAME CONSTRAINT PK_BUY_NO TO PRIMARY_BUYNO;
-- �������� Ȱ��ȭ/��Ȱ��ȭ
ALTER TABLE SHOP_BUY
DISABLE CONSTRAINT FK_USER_ID;
ALTER TABLE SHOP_BUY
ENABLE CONSTRAINT FK_USER_ID;
DROP TABLE DEPARTMENT;