-- ����Ŭ 5����_2_����Ŭ ��ü
-- ����Ŭ ��ü
-- ======================= 1. VIEW ==========================
-- FROM�� �ڿ� ���� ���������� �̸��� �ٿ��� ������ ���̺�� ����ϴ� ��
-- �������̺� �ٰ��� ������ ������ ���̺�(����ڿ��� �ϳ��� ���̺�ó��
-- ��� �����ϰ� ��)
-- �̸��� ���̱� �� INLINE VIEW, �̸��� ���� �� STORE VIEW
SELECT * FROM EMPLOYEE;

CREATE VIEW EMP_VIEW1
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, MANAGER_ID FROM EMPLOYEE;
-- EMP_VIEW1 ��� ���� ���
SELECT * FROM EMP_VIEW1;

-- �̸����� ��, INLINE VIEW
SELECT * FROM (SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, MANAGER_ID FROM EMPLOYEE);

-- ============================ ���� Ư¡ ======================================
-- ���̺� �ִ� �����͸� ������ ���̸�, ������ ��ü�� �����ϰ� �ִ� ���� �ƴ�
--  - ������ġ ���� ���������� �������� �ʰ� ���� ���̺�� �������
--  - �������� ���� ���̺���� ��ũ ������.
--  * �並 ����ϸ� Ư�� ����ڰ� ���� ���̺� �����Ͽ� ��� �����͸� �����ϴ� ���� ������ �� ����.
--    - ���� ���̺��� �ƴ� �並 ���� Ư�� �����͸� �������� ����.
--  * �並 ����� ���ؼ��� ������ �ʿ���!! ( �⺻ RESOURCE�ѿ� ���� �ȵ�, CREATVE VIEW ����)
-- ============================ ���� Ư¡2 ======================================
-- 1. �÷��Ӹ� �ƴ϶� ��� ����ó����. VIEW ������ ������.
-- ex) ���������� ������ �ִ� VIEW�� �����Ͻÿ�.(ANNUAL_SALARY_VIEW)
-- ���, �̸�, �޿�, ����
CREATE VIEW ANNUAL_SALARY_VIEW(EMP_ID, EMP_NAME, SALARY, ANNUAL_SALARY)
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;
SELECT * FROM ANNUAL_SALARY_VIEW;
-- 2. JOIN�� Ȱ���� VIEW ������ ������
-- ex) ��ü ������ ���, �̸�, ���޸�, �μ���, �������� �� �� �ִ� VIEW�� �����Ͻÿ�(ALL_INFO_VIEW)
DROP VIEW ALL_INFO_VIEW;
CREATE VIEW ALL_INFO_VIEW
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
SELECT * FROM ALL_INFO_VIEW;
-- ========================= VIEW �����غ��� =========================
CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;
SELECT * FROM V_EMPLOYEE;
-- �������� DEPT_CODE�� D8�� �ٲٴ� DML�� �ۼ��Ͻÿ�.
UPDATE V_EMPLOYEE
SET DEPT_CODE = 'D8'
WHERE EMP_ID = '200';
-- ���� ���̺� Ȯ�� -> ������ �� Ȯ��
-- VIEW�� ������ ��ũ�Ǿ� �־ VIEW ������ ������ ������.
SELECT * FROM EMPLOYEE;
-- Ȯ�������� ����
ROLLBACK;
-- ================================ VIEW �ɼ� ============================
-- 1. OR REPLACE
-- ������ ��� DROP �� CREATE
CREATE OR REPLACE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE FROM EMPLOYEE
WITH READ ONLY;
-- 2. FORCE/NOFORCE
-- �⺻ ���̺��� �������� �ʴ��� �並 �����ϴ� �ɼ�
-- 3. WITH CHECK OPTION
-- WHERE�� ���ǿ� ����� �÷��� ���� �������� ���ϰ� ��.
-- 4. WITH READ ONLY
-- VIEW�� ���� ��ȸ�� �����ϸ� DML �Ұ����ϰ� ��.

-- @�ǽ�����1
-- KH���� ������ �� EMPLOYEE, JOB, DEPARTMENT ���̺��� �Ϻ� ������ ����ڿ��� �����Ϸ��� �Ѵ�.
-- ������̵�, �����, ���޸�, �μ���, �����ڸ�, �Ի����� �÷������� ��(V_EMP_INFO)�� (�б� ��������)
-- �����Ͽ���.
CREATE OR REPLACE VIEW V_EMP_INFO(EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, MANAGER_NAME, HIRE_DATE)
AS
SELECT EMP_ID, EMP_NAME, JOB_NAME
, NVL(DEPT_TITLE, '����')
, NVL((SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID=E.MANAGER_ID), '����')
, HIRE_DATE
FROM EMPLOYEE E
LEFT OUTER JOIN JOB USING(JOB_CODE)
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WITH READ ONLY;

SELECT * FROM V_EMP_INFO;

-- ======================== ������ ��ųʸ�(DD, Data Dictionary) =====================
-- > �ڿ��� ȿ�������� �����ϱ� ���� �پ��� ������ ������ �ý��� ���̺�
-- > ������ ��ųʸ��� ����ڰ� ���̺��� �����ϰų� ����ڸ� �����ϴ� ���� �۾��� �� ��
-- �����ͺ��̽� ����(����Ŭ)�� ���� �ڵ����� ���ŵǴ� ���̺���.
-- ����ڴ� ������ ��ųʸ��� ������ ���� �����ϰų� ������ �� ����.
-- ������ ��ųʸ� �ȿ��� �߿��� ������ ���� �ֱ� ������ ����ڴ� �̸� Ȱ���ϱ� ���ؼ���
-- ������ ��ųʸ� �並 ����ϰ� ��.
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_SYS_PRIVS;
-- ========================= ������ ��ųʸ� ���� ���� =============================
-- 1. USER_XXX : �ڽ��� ������ ������ ��ü � ���� ������ ��ȸ��.
SELECT * FROM USER_TABLES;
SELECT * FROM USER_VIEWS;
-- 2. ALL_XXX : �ڽ��� ������ ������ ��ü � ���� ������ ��� ��ȸ��.(���Ѻο�������)
SELECT * FROM ALL_TABLES;
SELECT * FROM ALL_VIEWS;
-- 3. DBA_XXX : �����ͺ��̽� �����ڸ� ������ ������ ��ü ���� ���� ��ȸ
SELECT * FROM DBA_TABLES; -- ���������� �����ؾ� ��.



















