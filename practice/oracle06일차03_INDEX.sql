-- ����Ŭ 6���� ����Ŭ��ü INDEX
-- SQL ��ɹ��� ó���ӵ��� ����Ű�� ���� �÷��� ���� �����ϴ� ����Ŭ ��ü
-- - KEY - VALUE ���·� ������ �Ǹ� KEY���� �ε����� ���� �÷���,
-- VALUE���� ���� ����� �ּҰ��� ����ȴ�.
-- ���� : �˻��ӵ��� �������� �ý��ۿ� �ɸ��� ���ϸ� �ٿ� ��ü ���� ���.
-- ���� : 1. �ε����� ���� �߰� ���� ������ �ʿ��ϰ� �ε����� �����ϴµ� �ð��� �ɸ�
--        2. �������� �����۾�(INSERT/UPDATE/DELETE)�� ���� �Ͼ�� ���̺� INDEX ������
--           ������ ���� ���ϰ� �߻��� �� ����.
-- �ε����� ����� ���� �÷�
-- �����Ͱ��� �ߺ��� ���� ���� ������ �����Ͱ��� ������ �÷��� ����� ���� ����.
-- ȿ������ �ε��� ��� ��
-- 1. WHERE ���� ���� ���Ǵ� �÷��� �ε��� ����
-- > ��ü ������ �߿� 10 ~ 15%�̳��� �����͸� �˻��ϴ� ���, �ߺ��� ���� ���� �÷��̾�� ��.
-- 2. �ΰ� �̻��� �÷� WHERE���̳� JOIN�������� ���� ���Ǵ� ���
-- 3. �ѹ� �Էµ� �������� ������ ���� �Ͼ�� �ʴ� ���
-- 4. �� ���̺� ����� ������ �뷮�� ����� ū ���
SELECT * FROM EMPLOYEE;
-- INDEX ����
CREATE INDEX IND_EMP_ENAME ON EMPLOYEE(EMP_NAME);
-- INDEX Ȯ��
SELECT * FROM USER_IND_COLUMNS;
-- INDEX ����
DROP INDEX IND_EMP_ENAME;
CREATE INDEX IND_EMP_ENAME ON EMPLOYEE(EMP_NAME, EMP_NO, HIRE_DATE);
-- Ʃ�׽� ���Ǵ� ��ɾ�
EXPLAIN PLAN FOR
SELECT * FROM EMPLOYEE
WHERE EMP_NO LIKE '%04%';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- 2
SET TIMING ON;
SELECT * FROM EMPLOYEE WHERE EMP_NO LIKE '%04%';
-- F10���� �����Ͽ� ����Ŭ PLAN Ȯ���� �ε��� ���� Ȯ��
-- SET TIMING OFF;
-- ===================== PL/SQL
-- Oracle's Procedural Language Extension to SQL �� ����
-- ����Ŭ ��ü�� ����Ǿ� �ִ� ������ ���ν�, SQL�� ������ �����Ͽ� SQL���忡��
-- ������ ����, ����ó��, �ݺ�ó�� ���� ������.
-- PL/SQL �� ����
-- 1. �͸���(Annoymous Block)
-- 2. ���ν���(Procedure)
-- 3. �Լ�(Function)

-- PL/SQL�� ����(�͸���)
-- 1. �����(����) : DECLARE
-- 2. �����(�ʼ�) : BIGIN
-- 3. ����ó����(����) : EXCEPION
-- 4. END; (�ʼ�)
-- 5.(�ʼ�)
SET SERVEROUTPUT ON;
SET TIMING OFF;
-- �⺻ �ڷ��� 
-- VARCAHR2, NUMBER, DATE, BOOLEAN
-- ���� �ڷ���
-- RECORD, CURSOR, COLLECTION
-- 2.1 %TYPE����
-- ���� ���������� �ߴ� ���̺��� �÷� Ÿ���� �״�� �������� ���
DECLARE
    VEMPNO EMPLYEE.EMP_NO%TYPE;
    VENAME VARCHAR2(30);
    VSAL NUMBER;
    VHDATE DATE;
-- %TYPE �Ӽ��� ����Ͽ� ������ VEMPNO������ �ش� ���̺��� �÷��� ���� �ڷ�����
-- ũ�⸦ �״�� �����ؼ� �������.
-- �÷��� �ڷ����� ����Ǹ� �����ϴ� ���۷��� ������ �ڷ����� ũ�⵵ �ڵ����� �ݿ��ǹǷ�
-- ������ ������ �ʿ��� ���� ������ ����
BEGIN
    SELECT EMP_NO, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPNO, VENAME, VSAL, VHDATE
    FROM EMPLOYEE
    WHERE EMP_ID = '203';
    DBMS_OUTPUT.PUT_LINE(VEMPNO||':'||VENAME||':'||VSAL||':'||VHDATE);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found');
END;
/
-- @�ǽ�����1
-- ���, �����, ���޸��� ���� �� �ִ� ��������(%TYPE)�� ���ؼ�
-- ������ ����� ���, �����, ���޸��� �͸���� ���� ����ϼ���
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VJNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_NAME
    INTO VEMPID, VENAME, VJNAME
    FROM EMPLOYEE
    LEFT OUTER JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = '������';
    DBMS_OUTPUT.PUT_LINE(VEMPID||':'||VENAME||':'||VJNAME);
END;
/
-- 2.2 %ROWTYPE
-- ��(ROW) ������ �����ϴ� �Ӽ�, ��ü �÷��� �����͸� ����Ҷ� ������
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_NAME = '���ö';
    DBMS_OUTPUT.PUT_LINE(VEMP.EMP_ID||':'||VEMP.EMP_NAME);
--EXCEPTION
END;
/
----------- 3. �Է¹ޱ�
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '200';
    DBMS_OUTPUT.PUT_LINE('��� : '||VEMP.EMP_ID||', �̸� : '||VEMP.EMP_NAME);
END;
/
-- �ǽ�2
-- �����ȣ�� �Է¹޾Ƽ� ��� ����� �����ȣ, �̸�, �μ��ڵ�, �μ����� ����ϼ���
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('��� : '||VEMP.EMP_ID||', �̸� : '||VEMP.EMP_NAME||', �μ��� : '||VEMP.DEPT_TITLE);
END;
/