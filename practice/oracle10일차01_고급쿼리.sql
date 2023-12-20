-- ����Ŭ 10����, �������
-- 1. TOP-N �м�
-- 2. WITH ����
-- 3. ������ ����(Hierarchical Query)
-- 4. ������ �Լ�
-- Ư�� �÷����� ���� ū N���� �� �Ǵ� ���� ���� N���� ���� ���ؾ� �� ��쿡 ���
-- EX) ���� ���� �ȸ� ��ǰ 10������? ȸ�翡�� �޿��� ���� ���� ��� 3����?
SELECT MAX(SALARY) FROM EMPLOYEE;
-- # ROWNUM, ROWID
-- ���̺��� �����ϸ� �ڵ����� �������.
-- ROWID : ���̺��� Ư�� ���ڵ带 �����ϰ� �����ϱ� ���� ������ �ּҰ�
-- ROWNUM : �� �࿡ ���� �Ϸù�ȣ, ����Ŭ���� ���������� �ο��ϴ� �÷�.
SELECT ROWNUM, ROWID, EMP_ID FROM EMPLOYEE;
SELECT ROWNUM, SALARY FROM EMPLOYEE ORDER BY 2 DESC;
-- �޿��� �������� ���� �� ROWNUM���� �ѹ����ؼ� TOP3�� ���Ϸ��� ������
-- ROWNUM�� �ο��� �� ORDER BY�� �Ͽ��� �����̴�..
-- �ذ� : ORDER BY ���Ŀ� ROWNUM�� �ο��Ѵ�.
SELECT ROWNUM, EMP_NAME, SALARY
FROM 
(SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY 2 DESC);

-- �ǽ�1
-- D5�μ����� ������ ���� ���� ��� 3���� ��ü������ ����ϼ���
SELECT ROWNUM, E.*
FROM  
(SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D5' ORDER BY SALARY DESC) E
WHERE ROWNUM < 4;
-- �ǽ�2
-- �μ��� �޿���� TOP3 �μ��� �μ��ڵ�� �μ���, ��ձ޿��� ����ϼ���
SELECT * FROM
(
SELECT ROWNUM RNUM, E.*
FROM
(SELECT DEPT_CODE, DEPT_TITLE, TO_CHAR(ROUND(AVG(SALARY)), 'L999,999,999') AVG_SAL 
FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
GROUP BY DEPT_CODE, DEPT_TITLE 
ORDER BY 3 DESC) E 
)
WHERE RNUM BETWEEN 4 AND 6;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
-- 2. WITH
-- ���������� �̸����ٿ��ΰ� �ζ��κ�� ��� �� ���������� �̸��� FROM ���� ����� �� �̽¤�
-- ���� ���������� ������ ���� ��� �ߺ� �ۼ��� ���� �� �ְ� ����ӵ��� ������
-- ������
-- WITH �̸� AS (��������)
-- SELECT * FROM (����������)
-- ��
-- EMPLOYEE ���̺��� ���� TOP 5DLS ������ ��ü ������ ����Ͻÿ�
SELECT ROWNUM, F.*
FROM
(SELECT * FROM EMPLOYEE ORDER BY SALARY DESC) F
WHERE ROWNUM < 6;
-- �ǽ�1
-- D5 �μ����� ������ ���� ���� ��� 3���� ��ü����
SELECT ROWNUM, E.*
FROM 
(SELECT * FROM EMPLOYEE );
-- �ǽ� 2
-- �μ��� �޿���� TOP3 �μ��� �μ��ڵ�� �μ����� ��ձ޿��� ���
WITH TOPN_DEPT SAL AS (SELECT DEPT_CODE, DEPT_TITLE, ROUND(AVG(SALARY))) AVG_SAL
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_CODE, DEPT_tITLE
ORDER BY AVG_SAL DESC

WHERE ROWNUM < 4;
-- 4 ~ 6��?
-- ������ �Լ�
-- 1. �����Լ�
-- 1.1 RANK() OVER
-- 1.1.1 ���� : RANK() OVER(ORDER BY�÷��� ASC | DESC)
-- Ư�� �÷��� �������� ��ŷ�� �ο���. �ߺ� ���� ������ �ش� ������ŭ ���ʰ��� ���̷� ��ȯ��
-- ȸ�� ���� ����
SELECT ROWNUM, TOPN_SAL
FROM (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC) E;
WITH TOPN_SAL AS (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC)
SELECT ROWNUM, TOP_SAL.*
FROM TOPN_SAL;
SELECT EMP_NAME ,SALARY, RANK() OVER(ORDER BY SALARY DESC) ��������
FROM EMPLOYEE;
--
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) ����
FROM EMPLOYEE;
--�ǽ�����. �⺻�޿��� ����� 1����� 10������� ������ �̸�, �޿�, ������ ����Ͻÿ�
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) ����
FROM EMPLOYEE WHERE ROWNUM BETWEEN 1 AND 10;
-- ������ ����
-- JOIN�� ���� ���������� �����÷��� �����Ų �Ͱ� �޸� �����÷��� ������ �������� ����� ����
-- ������, �޴�, �ܴ��� �Խ��� �� ����Ż ������ ǥ���� ������.
-- ����Ŭ���� ���Ǵ� ����
-- 1. START WITH : �θ���(��Ʈ)�� ����
-- 2. CONNECT BY : �θ� �ڽİ��踦 ����
-- 3. PRIOR : START WITH ������ ������ �θ����� �����÷��� ������
-- 4. LEVEL : �ǻ��÷�(PSEUDO COLUM), ���������� ��Ÿ���� �����÷�, SELECT, WHERE, ORDER BY ���� ��밡��
-- ���� 1���̶� ������ �����ϴ� �Ŵ����� ������ ����ϼ���
--@�ǽ�����1
--MENU_TBL ���̺��� �����ϴµ� ������ NOĮ���� PRIMARY KEY�� �ְ�,���ڷ� ũ�Ⱑ 100��
--MENU_NAME Į���� �ְ� ���ڷ� �� PARENT_NO ��� �ϴ� �÷��� ����
CREATE TABLE MENU_TBL
(
    NO NUMBER PRIMARY KEY,
    MENU_NAME VARCHAR2(100),
    PARENT_NO NUMBER
);
SELECT * FROM MENU_TBL;
INSERT INTO MENU_TBL
VALUES(100,'�ָ޴�1',NULL);
INSERT INTO MENU_TBL
VALUES(200,'�ָ޴�2',NULL);
INSERT INTO MENU_TBL
VALUES(300,'�ָ޴�3',NULL);
INSERT INTO MENU_TBL
VALUES(1000,'����޴�A',100);
INSERT INTO MENU_TBL
VALUES(2000,'����޴�B',200);
INSERT INTO MENU_TBL
VALUES(3000,'����޴�C',300);
INSERT INTO MENU_TBL
VALUES(1001,'�󼼸޴�A1',1000);
INSERT INTO MENU_TBL
VALUES(1002,'�󼼸޴�A2',1000);
INSERT INTO MENU_TBL
VALUES(1003,'�󼼸޴�A3',1000);
INSERT INTO MENU_TBL
VALUES(3001,'�󼼸޴�C1',3000);
SELECT LPAD(' ��' , (LEVEL-1)*5,'')|| MENU_NAME "�޴�"
FROM MENU_TBL
START WITH PARENT_NO IS NULL
CONNECT BY PRIOR NO= PARENT_NO;
SELECT LPAD('��' , (LEVEL-1)*5,'')||MENU_NAME|| NVL2(PARENT_NO, ' ('||PARENT_NO||')','')AS "�޴���"
FROM MENU_TBL
START WITH NO IN (100,200,300)
CONNECT BY PRIOR NO = PARENT_NO;
