-- ����Ŭ 6���� ����Ŭ ��ü INDEX
-- ================================ 4. INDEX =======================================
-- -> SQL ��ɹ��� ó���ӵ��� ����Ű�� ���ؼ� �÷��� ���ؼ� �����ϴ� ����Ŭ ��ü
-- - KEY - VALUE ���·� ������ �Ǹ� KEY���� �ε����� ���� �÷���, VALUE���� ���� ����� �ּҰ��� �����
-- * ���� : �˻��ӵ��� �������� �ý��ۿ� �ɸ��� ���ϸ� �ٿ��� �ý��� ��ü ������ ����ų �� ����.
-- * ���� : 1. �ε����� ���� �߰� ���� ������ �ʿ��ϰ� �ε����� �����ϴµ� �ð��� �ɸ�
--          2. �������� �����۾�(INSERT/UPDATE/DELETE)�� ���� �Ͼ�� ���̺� INDEX ������
--          ������ ���� ���ϰ� �߻��� �� ����.
-- * � �÷��� �ε����� ����� ������?
-- -> �����Ͱ��� �ߺ��� ���� ���� ������ �����Ͱ��� ������ �÷��� ����� ���� ���� ����.
--    �׸��� ���� ���Ǵ� �÷��� ����� ����
-- * ȿ������ �ε��� ��� ��
-- 1. WHERE���� ���� ���Ǵ� �÷��� �ε��� ����
--  > ��ü ������ �߿� 10 ~ 15% �̳��� �����͸� �˻��ϴ� ���, �ߺ��� ���� ���� �÷��̾�� ��.
-- 2. �� �� �̻��� �÷� WHERE���̳� ����(JOIN)�������� ���� ���Ǵ� ���
-- 3. �ѹ� �Էµ� �������� ������ ���� �Ͼ�� �ʴ� ���
-- 4. �� ���̺� ����� ������ �뷮�� ����� Ŭ ���
SELECT * FROM EMPLOYEE;

-- �ε��� ����
CREATE INDEX IND_EMP_ENAME
ON EMPLOYEE(EMP_NAME);
-- �ε��� Ȯ��
SELECT * FROM USER_IND_COLUMNS;
-- �ε��� ����
DROP INDEX IND_EMP_ENAME;

CREATE INDEX IDX_EMP_COLUMNS
ON EMPLOYEE(EMP_NAME, EMP_NO, HIRE_DATE);

-- Ʃ�׽� ���Ǵ� ��ɾ�
-- #1
EXPLAIN PLAN FOR
SELECT * FROM EMPLOYEE
WHERE EMP_NO LIKE '%04%';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- #2
SET TIMING ON;
SELECT * FROM EMPLOYEE
WHERE EMP_NO LIKE '%04%';
-- F10���� �����Ͽ� ����Ŭ PLAN Ȯ���Ͽ� �ε��� ���� Ȯ��
--SET TIMING OFF;

-- ================================= 1. PL/SQL ===================================
-- Oracle's Procedural Language Extension to SQL�� ����
-- > ����Ŭ ��ü�� ����Ǿ� �ִ� ������ ���ν�, SQL�� ������ �����Ͽ� SQL���� ������
-- ������ ����, ����ó��, �ݺ�ó�� ���� ������.

-- PL/SQL�� ����
-- 1. �͸���(Anonymous Block)
-- 2. ���ν���(Procedure)
-- 3. �Լ�(Function)

-- PL/SQL�� ����(�͸���)
-- 1. �����(����) : DECLARE
-- 2. �����(�ʼ�) : BEGIN
-- 3. ����ó����(����) : EXCEPTION
-- 4. END; (�ʼ�)
-- 5. /(�ʼ�)
SET SERVEROUTPUT ON;

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO PL/SQL');
END;
/
-- PL/SQL���� �������� ���
DECLARE
    VID NUMBER;
BEGIN
    SELECT EMP_ID
    INTO VID
    FROM EMPLOYEE
    WHERE EMP_NAME = '������';
    DBMS_OUTPUT.PUT_LINE('ID = '||VID);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data~');
END;
/
SET TIMING OFF;

-- ============================= 2. PL/SQL ���� ==================================
-- # ������ �ڷ���
-- 1. �⺻ �ڷ���
-- VARCHAR2, NUMBER, DATE, BOOLEAN, ...
-- 2. ���� �ڷ���
-- Record, Cursor, Collection
-- 2.1 %TYPE ����
-- ���� ���������� �ߴ� ���̺��� �÷� Ÿ���� �״�� �������� ���.
DESC EMPLOYEE;
DECLARE
    VEMPNO EMPLOYEE.EMP_NO%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSAL   EMPLOYEE.SALARY%TYPE;
    VHDATE EMPLOYEE.HIRE_DATE%TYPE;
    -- %TYPE �Ӽ��� ����Ͽ� ������ VEMPNO������ �ش� ���̺��� �÷��� ���� �ڷ�����
    -- ũ�⸦ �״�� �����ؼ� �������.
    -- �÷��� �ڷ����� ����Ǹ� �����ϴ� ���۷��� ������ �ڷ����� ũ�⵵ �ڵ����� �ݿ��ǹǷ�
    -- ������ ������ �ʿ䰡 ���� ������ ����.
BEGIN
    SELECT EMP_NO, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPNO, VENAME, VSAL, VHDATE
    FROM EMPLOYEE
    WHERE EMP_ID = '203';
    DBMS_OUTPUT.PUT_LINE(VEMPNO||':'||VENAME||':'||VSAL||':'||VHDATE);
    -- ������ ���� ���� ����ϰ� ���ִ� �κ�
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found');        
END;
/
-- @�ǽ�����1
-- ���, �����, ���޸��� ���� �� �ִ� ��������(%TYPE)�� ���ؼ�
-- ������ ����� ���, �����, ���޸��� �͸���� ���� ����ϼ���.
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
--EXCEPTION
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

-- ===================== 3. PL/SQL �Է¹ޱ� =====================
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('��� : '||VEMP.EMP_ID||', �̸� : '||VEMP.EMP_NAME);
END;
/
-- @�ǽ�����2
-- �����ȣ�� �Է¹޾Ƽ� �ش� ����� �����ȣ, �̸�, �μ��ڵ�, �μ����� ����ϼ���.
-- 1. ������� ����ϴ� ������ �ۼ�
-- 2. PL/SQL �͸��Ͽ� ����
-- 3. �����ȣ �Է¹޾Ƽ� PL/SQL�� ����ϱ�
DECLARE
    --VEMP EMPLOYEE%ROWTYPE;
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDCODE DEPARTMENT.DEPT_ID%TYPE;
    VDNAME DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    INTO VEMPID, VENAME, VDCODE, VDNAME
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE(VENAME||':'||VDCODE||':'||VDNAME);
END;
/













