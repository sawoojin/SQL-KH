-- ����Ŭ 6���� ����Ŭ ��ü ������(SEQUENCE)
-- ���������� ���� ���� �ڵ����� �����ϴ� ��ü, �ڵ� ��ȣ �߻���(ä����)�� ������ ��
-- CREATE SEQUENCE [��������]; > �⺻������ ����
-- CREATE SEQUENCE [��������]
-- ====================== �������� �ɼ� ===========================
-- MINVALUE : �߻���ų �ּҰ� ����
-- MAXVALUE : �߻���ų �ִ밪 ���� 
-- START WITH : ó�� �߻���ų ���� �� ����, �⺻�� 1
-- INCREMENT BY : ���� ���� ���� ����ġ, �⺻�� 1
-- NOCYCLE : ������ ���� �ִ밪���� ������ �Ϸ��ϸ� CYCLE�� START WITH�� �ٽ� ������.
-- NOCACHE; : �޸𸮻󿡼� ���������� ����, �⺻�� 20, ��������ü�� ���ٺ󵵸� �ٿ��� ȿ������ �����
-- ============================ ������ ����� ===============================
-- 1. ��������.NEXTVAL : ���ʷ� ȣ���� �Ŀ� ����ؾ���.
-- 2. ��������.CURRVAL : ���� LAST_NUMBER�� �˷���.(NEXTVAL�� 1���̻� �� �Ŀ� ��밡��)
CREATE SEQUENCE SEQ_KH_MEMBER_NO;
SELECT * FROM USER_SEQUENCES;
SELECT SEQ_KH_MEMBER_NO.NEXTVAL FROM DUAL;
SELECT SEQ_KH_MEMBER_NO.CURRVAL FROM DUAL;

CREATE TABLE SEQUENCE_TBL
(
    NUM NUMBER PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    AGE NUMBER NOT NULL
);
INSERT INTO SEQUENCE_TBL
VALUES(SEQ_USER_NO.NEXTVAL, '�Ͽ���', '31');
INSERT INTO SEQUENCE_TBL
VALUES(SEQ_USER_NO.NEXTVAL, '�̿���', '32');
INSERT INTO SEQUENCE_TBL
VALUES(SEQ_USER_NO.NEXTVAL, '�����', '33');

SELECT * FROM SEQUENCE_TBL;
ROLLBACK;
CREATE SEQUENCE SEQ_USER_NO;
SELECT * FROM USER_SEQUENCES;

-- @�ǽ�����1
-- ���� ��ǰ�ֹ��� ����� ���̺� ORDER_TBL�� �����, ������ ���� �÷��� �����ϼ���.
-- ORDER_NO(�ֹ�NO) : NUMBER, PK
-- USER_ID(�����̵�) : VARCHAR2(40)
-- PRODUCT_ID(�ֹ���ǰ ���̵�) : VARCHAR2(40)
-- PRODUCT_CNT(�ֹ�����) : NUMBER
-- ORDER_DATE : DATE, DEFAULT SYSDATE
CREATE TABLE ORDER_TBL
(
    ORDER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(40),
    PRODUCT_ID VARCHAR2(40),
    PRODUCT_CNT NUMBER,
    ORDER_DATE DATE DEFAULT SYSDATE
);
-- SEQ_ORDER_NO �������� �����Ͽ� ������ �����͸� �߰��ϼ���.
-- * kang���� saewookkang��ǰ�� 5�� �ֹ��ϼ̽��ϴ�.
-- * gam���� gamjakkang��ǰ�� 30�� �ֹ��ϼ̽��ϴ�.
-- * ring���� onionring��ǰ�� 50�� �ֹ��ϼ̽��ϴ�.
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'kang', 'saewookkang', 5, DEFAULT);
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'gam', 'gamjakkang', 30, DEFAULT);
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'ring', 'onionring', 50, DEFAULT);

CREATE SEQUENCE SEQ_ORDER_NO;
DROP SEQUENCE SEQ_ORDER_NO;
SELECT * FROM ORDER_TBL;
ROLLBACK;
DELETE FROM ORDER_TBL;
COMMIT;

CREATE TABLE ORDER_NEW_TBL
(
    ORDER_NO VARCHAR2(30) CONSTRAINT PK_ORDER_NO PRIMARY KEY,
    USER_ID VARCHAR2(40) NOT NULL,
    PRODUCT_ID VARCHAR2(40) NOT NULL,
    PRODUCT_CNT NUMBER(3),
    ORDER_DATE DATE DEFAULT SYSDATE
);
-- #0 DELETE FROM ORDER_NEW_TBL
-- #1
DROP SEQUENCE SEQ_NEW_ORDER_NO;
-- #2
CREATE SEQUENCE SEQ_NEW_ORDER_NO;
-- #3
INSERT INTO ORDER_NEW_TBL
VALUES('kh-'||TO_CHAR(SYSDATE, 'yyyymmdd')||'-'||SEQ_NEW_ORDER_NO.NEXTVAL
, 'kang', 'saewookkang', 5, DEFAULT);
INSERT INTO ORDER_NEW_TBL
VALUES('kh-'||TO_CHAR(SYSDATE, 'yyyymmdd')||'-'||SEQ_NEW_ORDER_NO.NEXTVAL
, 'gam', 'potatokkang', 30, DEFAULT);
INSERT INTO ORDER_NEW_TBL
VALUES('kh-'||TO_CHAR(SYSDATE, 'yyyymmdd')||'-'||SEQ_NEW_ORDER_NO.NEXTVAL
, 'ring', 'onionring', 50, DEFAULT);
SELECT * FROM ORDER_NEW_TBL;
ROLLBACK;

-- @�ǽ�����2
-- KH_MEMBER ���̺��� �����ϼ���
-- �÷� : MEMBER_ID, MEMBER_NAME, MEMBER_AGE, MEMBER_JOIN_COM
-- �ڷ��� : NUMBER, VARCHAR2(20), NUMBER, NUMBER
CREATE TABLE KH_MEMBER
(
    MEMBER_ID NUMBER,
    MEMBER_NAME VARCHAR2(20),
    MEMBER_AGE NUMBER,
    MEMBER_JOIN_COM NUMBER
);
CREATE SEQUENCE SEQ_MEMBER_ID
START WITH 500
INCREMENT BY 10
NOCYCLE
NOCACHE;
CREATE SEQUENCE SEQ_MEMBER_JOIN_COM;
INSERT INTO KH_MEMBER
VALUES(SEQ_MEMBER_ID.NEXTVAL, 'ȫ�浿', 20, SEQ_MEMBER_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER
VALUES(SEQ_MEMBER_ID.NEXTVAL, 'û�浿', 30, SEQ_MEMBER_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER
VALUES(SEQ_MEMBER_ID.NEXTVAL, '�ܱ浿', 40, SEQ_MEMBER_JOIN_COM.NEXTVAL);
INSERT INTO KH_MEMBER
VALUES(SEQ_MEMBER_ID.NEXTVAL, '��浿', 50, SEQ_MEMBER_JOIN_COM.NEXTVAL);
SELECT * FROM KH_MEMBER;
-- 1. ID���� 500������ �����Ͽ� 10�� �����Ͽ� ����
-- 2. JOIN_COM���� 1������ �����Ͽ� 1�� �����Ͽ� ����
-- MEMBER_ID    MEMBER_NAME     MEMBER_AGE      MEMBER_JOIN_COM
--  500             ȫ�浿         20                  1
--  510             û�浿         30                  2
--  520             �ܱ浿         40                  3
--  530             ��浿         50                  4

-- ========================== ������ ���� ===================================
-- ��, START WITH�� ����Ұ�, �ٲٰ� ������ DROP �� RE CREATE����� ��.
SELECT * FROM USER_SEQUENCES;

ALTER SEQUENCE SEQ_KH_MEMBER_NO
INCREMENT BY 1
MAXVALUE 100000
NOCYCLE
NOCACHE;


SELECT * FROM USER_TABLES;
SELECT * FROM USER_VIEWS;

SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_SYS_PRIVS;

