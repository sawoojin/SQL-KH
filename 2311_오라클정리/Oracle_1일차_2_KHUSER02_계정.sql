-- ���� �Ѱ� ����
-- ���� ���� / ����, ���̺� ���� / ���� (DDL)
-- ���� ���� �ο� (DCL)
-- ������ ��ȸ (DQL)
-- ������ ����/����, ���� (DML)
-- ���� ���� �� ���� (TCL)


SHOW USER;
-- ���̺� ����(DDL)
CREATE TABLE MEMBER_TBL
(
    MEMBER_NO NUMBER,
    MEMBER_ID VARCHAR2(20),
    MEMBER_NAME VARCHAR2(30),
    MEMBER_EMAIL VARCHAR2(50)
);
-- ���̺� ����(DDL)
DROP TABLE MEMBER_TBL;
-- ������ ��ȸ/ DML(DQL)
SELECT MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_EMAIL FROM MEMBER_TBL;
-- ������ ����(INSERT INTO ~ VALUE )/DML
INSERT INTO MEMBER_TBL(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_EMAIL) 
VALUES(1, 'khuser01', '�Ͽ���', 'khuser01@kh.com');
INSERT INTO MEMBER_TBL(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_EMAIL) 
VALUES(2, 'khuser02', '�̿���', 'khuser02@kh.com');
INSERT INTO MEMBER_TBL(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_EMAIL) 
VALUES(3, 'khuser03', '�����', 'khuser03@kh.com');
INSERT INTO MEMBER_TBL(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_EMAIL) 
VALUES(4, 'khuser04', '�����', 'khuser04@kh.com');
-- ������ ����
UPDATE MEMBER_TBL SET MEMBER_NAME = '�Ͽ���' WHERE MEMBER_NO = 1; -- MEMBER_ID = 'khuser01',...
-- ������ ����(DELETE FROM ~ WHERE)/DML
DELETE FROM MEMBER_TBL WHERE MEMBER_NO = 1;
-- ���� �����ϴ� ��ɾ� (TCL)
COMMIT;
-- �ѹ��ϴ� ��ɾ� (TCL)
ROLLBACK;








