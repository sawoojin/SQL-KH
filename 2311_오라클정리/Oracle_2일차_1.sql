-- Oracle 2����
-- �������� ���� ���̺�
CREATE TABLE USER_NO_CONSTRAINT(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20), -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(30), -- �ѱ� 10����
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50)    
);
INSERT INTO USER_NO_CONSTRAINT
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', '��', '01082827373', 'khuser01@kh.com');
-- �����ϰ� ��� Ȯ���ϼ���!!
-- ���Ȯ���ϴ� �����??
COMMIT;
SELECT * FROM USER_NO_CONSTRAINT;
ROLLBACK; -- ���� Ŀ�Ե� ���·� ����

-- NOT NULL �������� ���̺�
CREATE TABLE USER_CONSTRAINT_NOTNULL(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) NOT NULL, -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL, -- �ѱ� 10����
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50)    
);
-- ���� �� Ȯ���ϱ�!!
INSERT INTO USER_CONSTRAINT_NOTNULL
VALUES(1, null, 'pass01', '�Ͽ���', '��', '01082827373', 'khuser01@kh.com');

-- UNIQUE �������� ���̺�
CREATE TABLE USER_CONSTRAINT_UNIQUE(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE, -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL, -- �ѱ� 10����
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50)    
);
-- UNIQUE�� NULL�� �����!!!
INSERT INTO USER_CONSTRAINT_UNIQUE
VALUES(1, null, 'pass01', '�Ͽ���', '��', '01082827373', 'khuser01@kh.com');
INSERT INTO USER_CONSTRAINT_UNIQUE
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', '��', '01082827373', 'khuser01@kh.com');
-- PRIMAKRY �������� ���̺�
CREATE TABLE USER_PRIMARY_KEY(
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR2(20) PRIMARY KEY, -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL, -- �ѱ� 10����
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50)    
);
INSERT INTO USER_PRIMARY_KEY
VALUES(1, null, 'pass01', '�Ͽ���', '��', '01082827373', 'khuser01@kh.com');
-- �����ϰ� cannot insert NULL into (%s)" �޽��� Ȯ���ϼ���.
INSERT INTO USER_PRIMARY_KEY
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', '��', '01082827373', 'khuser01@kh.com');
-- �����ϰ� ���Ἲ ���� ����(KH.SYS_C007402)�� ����˴ϴ� �޽��� Ȯ���ϼ���.
-- => NOT NULL�� UNIQUE ��ģ ���̸�, ���̺���踦 ���� �� ����.

-- CHECK �������� ���̺�
CREATE TABLE USER_CHECK(
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR2(20) CONSTRAINT PK_USER_ID PRIMARY KEY, -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL, -- �ѱ� 10����
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M','F')),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50)    
);
INSERT INTO USER_CHECK
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', '��', '01082827373', 'khuser01@kh.com');
-- �����ϰ� '��'�̶� �Է��ϸ� �������� �� Ȯ��,
-- üũ ��������(KH.SYS_C007406)�� ����Ǿ����ϴ� �޽��� Ȯ��
-- INSERT�ϰ� ������ �� -> M
INSERT INTO USER_CHECK
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', 'M', '01082827373', 'khuser01@kh.com');
-- �����ϰ� ����Ȯ��
SELECT * FROM USER_CHECK;
COMMIT;
-- DEFAULT ��������
CREATE TABLE USER_DEFAULT(
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR2(20) PRIMARY KEY, -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL, -- �ѱ� 10����
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M','F')),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50),
    USER_DATE DATE DEFAULT SYSDATE
);
INSERT INTO USER_DEFAULT
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', 'M', '01082827373', 'khuser01@kh.com', '23/12/07');
-- �����ϰ� Ȯ��, ��¥�� 23/12/07��
SELECT * FROM USER_DEFAULT;
-- �ٸ� ������ �־�Կ�, khuser02, pass02, �̿���
INSERT INTO USER_DEFAULT
VALUES(2, 'khuser02', 'pass02', '�̿���', 'M', '01082827373', 'khuser02@kh.com', '23/12/14');
-- USER_NO�� 2�� �ٲٰ� ��¥�� 23/12/14���� Ȯ��
INSERT INTO USER_DEFAULT
VALUES(3, 'khuser03', 'pass03', '�����', 'M', '01082827373', 'khuser03@kh.com', DEFAULT);
-- �ٸ� ������ �־�Կ�, khuser03, pass03, �����, '23/12/14' -> SYSDATE
-- SYSDATE�� ����ϸ� ���� ��¥ 23/12/07 ���°� Ȯ�� SYSDATE�� ��¥�Լ���� �ϰ��
-- ���� ��¥�� �Է����ִ� ������ �մϴ�. ��� Ȯ���غ�����!!
SELECT * FROM USER_DEFAULT;
-- DEFAULT ���������� �⺻���� ������ �� ����ϰ� DEFAULT�� ���� �ٸ� ���� �Ű澲�� �ʰ�  �����͸�
-- ���� �� ����.

-- (FOREIGN KEY) �ܷ�Ű ��������
CREATE TABLE USER_GRADE
(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO USER_GRADE VALUES(10, '�Ϲ�ȸ��');
INSERT INTO USER_GRADE VALUES(20, '���ȸ��');
INSERT INTO USER_GRADE VALUES(30, 'Ư��ȸ��');
COMMIT;
-- ���� �� �����ϰ� Ȯ���غ�����~!
-- USER_GRADE�� ������ �θ� ���̺��Դϴ�. �ڽ����̺��� �� �÷��� �θ��÷��� �����͸� �����.
SELECT * FROM USER_GRADE;

DROP TABLE USER_FOREIGNKEY;
CREATE TABLE USER_FOREIGNKEY(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE, -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL, -- �ѱ� 10����
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M','F')),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50),
    USER_DATE DATE DEFAULT SYSDATE,
    GRADE_CODE NUMBER REFERENCES USER_GRADE(GRADE_CODE) ON DELETE SET NULL
);
-- ���� ���Ἲ�� �����ϴ� FOREGIN KEY�� ����
-- �ڽ����̺��� insert�� ��, �θ� ���̺��� ������ �ִ� �÷��� �ʵ尪���θ� insert�� �ǵ��� ��.
-- �θ����̺��� �����͸� �Ժη� ������ ���ϰ� ��.
INSERT INTO USER_FOREIGNKEY
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', 'M', '01082827373', 'khuser01@kh.com', DEFAULT, 10);
-- GRADE_CODE�� 10�̸� �θ����̺��� ������ �ִ� �÷��� �ʵ尪�̱� ������ insert ���� Ȯ��
INSERT INTO USER_FOREIGNKEY
VALUES(2, 'khuser02', 'pass02', '�̿���', 'M', '01082827373', 'khuser02@kh.com', DEFAULT, 20);
-- GRADE_CODE�� 40�̸� �θ����̺��� ������ �ִ� �÷��� �ʵ尪�� �ƴϱ� ������ insert ���� Ȯ��
-- �����ϰ� ���Ἲ ��������(KH.SYS_C007427)�� ����Ǿ����ϴ�- �θ� Ű�� �����ϴ� �޽��� Ȯ��
COMMIT;
-- �����ϰ� Ȯ��
SELECT * FROM USER_FOREIGNKEY;
-- �ܷ�Ű(FOREIGN KEY) ����
-- SHOP �� ���̺�, SHOP_MEMBER(�θ�)
CREATE TABLE SHOP_MEMBER(
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR2(20) PRIMARY KEY, -- �ѱ۷� �����? 6����
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL, -- �ѱ� 10����
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M','F')),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50)
);
INSERT INTO SHOP_MEMBER
VALUES(1, 'khuser01', 'pass01', '�Ͽ���', 'M', '01082893933','khuser01@naver.com');
INSERT INTO SHOP_MEMBER
VALUES(2, 'khuser02', 'pass02', '�Ͽ���', 'M', '01082893933','khuser02@naver.com');
INSERT INTO SHOP_MEMBER
VALUES(3, 'khuser03', 'pass03', '�Ͽ���', 'M', '01082893933','khuser03@naver.com');
SELECT * FROM SHOP_MEMBER;
COMMIT;
-- SHOP ���� ���� ���̺�, SHOP_BUY(�ڽ�)
CREATE TABLE SHOP_BUY
(
    BUY_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(30) REFERENCES SHOP_MEMBER(USER_ID),
    PRODUCT_NAME VARCHAR2(20),
    REG_DATE DATE DEFAULT SYSDATE
);
INSERT INTO SHOP_BUY
VALUES(1, 'khuser01', '��ȭ', DEFAULT);
INSERT INTO SHOP_BUY
VALUES(2, 'khuser02', '�౸ȭ', DEFAULT);
INSERT INTO SHOP_BUY
VALUES(3, 'khuser03', '�豸ȭ', DEFAULT);
INSERT INTO SHOP_BUY
VALUES(4, 'khuser04', '����ȭ', DEFAULT);
-- ����� ���Ἲ ��������(KH.SYS_C007434)�� ����Ǿ����ϴ�- �θ� Ű�� �����ϴ� �޽��� Ȯ��
-- �ܷ�Ű �������ǿ� �ɸ�. �θ� ������ �ִ� �÷��� ��(�ʵ�) �� 1���� ����� ��
-- khuser01, khuser02, khuser03
SELECT * FROM SHOP_BUY;
ROLLBACK;
SELECT * FROM USER_GRADE;
SELECT * FROM USER_FOREIGNKEY;
-- ���� ���Ἲ �����ϱ� ���ؼ� ���� �Ұ�, �θ����̺��� ������ ���� �Ұ�
DELETE FROM USER_GRADE WHERE GRADE_CODE = 10;
-- ���� �� ���Ἲ ��������(KH.SYS_C007427)�� ����Ǿ����ϴ�- �ڽ� ���ڵ尡 �߰ߵǾ����ϴ�. �޽��� Ȯ��
-- �׷����� �ұ��ϰ� ������ ����ؾ� �Ǵ� ��찡 �ְ�
-- �׷��� �ϱ� ���ؼ� ���� �ɼ��� �ܷ�Ű �����Ҷ� ���� ����� ��
-- �ܷ�Ű ���� �ɼ�
-- 1. �⺻ �ɼ� ON DELETE RESTRICTED
-- 2. ������ ��� �� ���� �ɼ�, ON DELETE CASCADE(�θ�, �ڽ� ��� �����͸� ����)
-- 3. NULL�� ����� �ɼ�, ON DELETE SET NULL(�θ�� �����ǰ�, �ڽĿ� �����ִ� �����ʹ� null�� �������)
-- > �ش� �ɼ��� �ܷ�Ű �����ÿ� ���� �����־�� �����.


--================== JOB ���̺� =========================
CREATE TABLE JOB
(
    JOB_CODE CHAR(2),
    JOB_NAME VARCHAR2(35)
);
INSERT INTO JOB
VALUES('J1', '��ǥ');

COMMENT ON COLUMN JOB.JOB_CODE IS '�����ڵ�';
COMMENT ON COLUMN JOB.JOB_NAME IS '���޸�';
-- �����ϰ� ��� �� Ȯ���ϱ�

--================== DEPARTMENT ���̺� ======================
CREATE TABLE DEPARTMENT
(
    DEPT_ID CHAR(2),
    DEPT_TITLE VARCHAR2(35),
    LOCATION_ID CHAR(2)
);
INSERT INTO DEPARTMENT
VALUES('D1', '�λ������', 'L1');

COMMENT ON COLUMN DEPARTMENT.DEPT_ID IS '�μ��ڵ�';
COMMENT ON COLUMN DEPARTMENT.DEPT_TITLE IS '�μ���';
COMMENT ON COLUMN DEPARTMENT.LOCATION_ID IS '�����ڵ�';

SELECT * FROM DEPARTMENT;
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID FROM DEPARTMENT;


-- ==================== EMPLOYEE ���̺� =======================
DROP TABLE EMPLOYEE;
CREATE TABLE EMPLOYEE
(
    EMP_ID VARCHAR2(3),
    EMP_NAME VARCHAR2(20) NOT NULL,
    EMP_NO CHAR(14),
    EMAIL VARCHAR2(25),
    PHONE VARCHAR2(12),
    DEPT_CODE CHAR(2),
    JOB_CODE CHAR(2),
    SAL_LEVEL CHAR(2),
    SALARY NUMBER,
    BONUS NUMBER,
    MANAGER_ID VARCHAR2(3),
    HIRE_DATE DATE,
    ENT_DATE DATE,
    ENT_YN CHAR(1),
    CONSTRAINT UNQ_EMP_ID UNIQUE(EMP_ID)
);
SELECT * FROM EMPLOYEE;
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL
,SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN FROM EMPLOYEE;

-- ������ �����͸� EMPLOYEE ���̺� �־����!!
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL
,SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN)
VALUES('200', '������', '621231-1985634', 'sun-di@kh.or.kr', '01099546325', 'D9', 'J1', 'S1'
, 8000000, 0.3, null, '2013/02/06', null, 'N');
-- �÷��� ��������, �÷� ���� �� ������� ������ �Է� �ʼ�!!
INSERT INTO EMPLOYEE
VALUES('200', '������', '621231-1985634', 'sun-di@kh.or.kr', '01099546325', 'D9', 'J1', 'S1'
, 8000000, 0.3, null, '2013/02/06', null, 'N');
SELECT * FROM EMPLOYEE;

-- ���̺� ��Ű�� ��ȸ, �÷��� Ȯ��
DESC EMPLOYEE;

COMMENT ON COLUMN EMPLOYEE.EMP_ID IS '�����ȣ';
COMMENT ON COLUMN EMPLOYEE.EMP_NAME IS '������';
COMMENT ON COLUMN EMPLOYEE.EMP_NO IS '�ֹε�Ϲ�ȣ';
COMMENT ON COLUMN EMPLOYEE.EMAIL IS '�̸���';
COMMENT ON COLUMN EMPLOYEE.PHONE IS '��ȭ��ȣ';
COMMENT ON COLUMN EMPLOYEE.DEPT_CODE IS '�μ��ڵ�';
COMMENT ON COLUMN EMPLOYEE.JOB_CODE IS '�����ڵ�';
COMMENT ON COLUMN EMPLOYEE.SAL_LEVEL IS '�޿����';
COMMENT ON COLUMN EMPLOYEE.SALARY IS '�޿�';
COMMENT ON COLUMN EMPLOYEE.BONUS IS '���ʽ���';
COMMENT ON COLUMN EMPLOYEE.MANAGER_ID IS '�����ڻ��';
COMMENT ON COLUMN EMPLOYEE.HIRE_DATE IS '�Ի���';
COMMENT ON COLUMN EMPLOYEE.ENT_DATE IS '�����';
COMMENT ON COLUMN EMPLOYEE.ENT_YN IS '��������';






