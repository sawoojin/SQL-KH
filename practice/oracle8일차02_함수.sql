SET SERVEROUTPUT ON;
-- ����Ŭ 8����, ����Ŭ ��ü ���ν���, �Լ�, Ʈ����
-- PL/SQL ����
-- 1. �͸���
-- 2. ��������
-- 3. �Լ�
-- ==================== PL/SQL - Stored Procedure
-- ���ν����� �Ϸ��� �۾� ������ �����ؼ� �����ص� ��
-- �Լ��ʹ� �ٸ��� ��ȯ���� ����.
-- ū ������ �����ؼ� ó���ؾ� �� ��� ���������� ���ν����� �����Ͽ� ó����.
-- ���� SQL���� ��� �̸� �����صΰ� �ϳ��� ��û���� ������ �� ����
-- ���� ���ν����� ��������� ����� �� ����
-- ======================= Stored Procedure ����
-- CREATE OR REPLACE PROCEDURE ���ν�����(�Ű�����1, �Ű�����2, .... )
-- �Ű������� IN���(�����͸� ���޹��� ��), OUT���(����� ����� �޾ư� ��)�� ����
-- IS
-- �������𰡴� (OUT���)
--  �͸���
-- ����� EXECUTE ���ν�����
CREATE TABLE EMP_DUPLICATE
AS SELECT * FROM EMPLOYEE;
-- ���ν��� ����
CREATE OR REPLACE PROCEDURE PROC_DEL_ALL_EMP
IS
BEGIN
    DELETE FROM EMP_DUPLICATE;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('�����Ͱ� ��� ������');
END;
/
-- ���ν��� ����
EXECUTE PROC_DEL_ALL_EMP;
-- Stroed Procedure �� ������ (PROC_ADD_ALL_EMP)
CREATE OR REPLACE PROCEDURE PROC_ADD_ALL_EMP
IS
BEGIN
    INSERT INTO EMP_DUPLICATE
    (SELECT * FROM EMPLOYEE);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('�����Ͱ� ��� �߰���');
END;
/
-- ���ñⰡ �����ϵǾ����ϴ�.
-- ���ν��� ����
EXECUTE PROC_ADD_ALL_EMP;
-- Stroed Procedure �Ű����� ����غ���
CREATE OR REPLACE PROCEDURE PROC_DEL_ONE_EMP(IN_EMPID IN EMP_DUPLICATE.EMP_ID%TYPE)
IS
BEGIN
    DELETE FROM EMP_DUPLICATE WHERE EMP_ID = IN_EMPID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(IN_EMPID||'�� ����� �����Ǿ����ϴ�');
END;
/
EXECUTE PROC_DEL_ONE_EMP('&IN_EMPID');
SELECT * FROM EMP_DUPLICATE;
ROLLBACK;
-- 2# �Ű����� IN, OUT��� ��� ����Ͽ� SELECT �غ���
CREATE OR REPLACE PROCEDURE PROC_SELECT_EMP_INFO
(
    P_EMPID IN EMPLOYEE.EMP_ID%TYPE,
    P_ENAME OUT EMPLOYEE.EMP_NAME%TYPE,
    P_SALARY OUT EMPLOYEE.SALARY%TYPE,
    P_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS 
BEGIN
    SELECT EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO P_ENAME, P_SALARY, P_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMPID;
END;
/
-- ���ε� ���� ����
VAR B_ENAME VARCHAR2(30);
VAR B_SALARY NUMBER;
VAR B_BONUS NUMBER;
EXEC PROC_SELECT_EMP_INFO('&EMPID', :B_ENAME, :B_SALARY, :B_BONUS);
PRINT B_ENAME;
PRINT B_SALARY;
PRINT B_BONUS;
-- ��ƺ���
VAR RESULT VARCHAR2(200);
EXEC :RESULT := (:B_ENAME||', '||:B_SALARY||', '||:B_BONUS);
PRINT RESULT;
-- @�ǽ�����
-- 1. ���� �μ����̺��� DEPT_ID, DEPT_TITLE�� ������ DEPT_COPY ���̺��� �����Ѵ�.
-- 2. DEPT_ID �÷��� PK�߰��ϰ� DEPT_ID �÷��� Ȯ���Ѵ�(CHAR(3))
-- 3. DEPT_COPY�� �����ϴ� ���ν��� PROC_MAN_DEPT_COPY�� �����Ѵ�.
-- 3.1 ù��° ���ڷ� FLAG�� UPDATE/DELETE�� �޴´�.
-- 3.2 UPDATE�� �����Ͱ� �������� ������ INSERT, �����Ͱ� �����ϸ� UPDATE�� �ϵ��� �Ѵ�.
-- 3.3 DELETE�� �ش�μ��� ����� �����ϴ��� �˻��Ͽ� �����ϸ� ���޽����� �Բ� ��������ϰ�
-- �׷��� ������ �����ϵ��� �Ѵ�.

-- #1
CREATE TABLE DEPT_COPY
AS SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;
SELECT * FROM DEPT_COPY;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DEPT_COPY';
DESC DEPT_COPY;
-- #2
-- #2.1 PK�߰�
ALTER TABLE DEPT_COPY ADD CONSTRAINT PK_DEPT_ID PRIMARY KEY(DEPT_ID);
-- 121 ���� �� 117 Ȯ���غ��� PK�� �߰��Ǿ�����.
-- #2.2 �÷� �ڷ��� ����
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
-- #3
CREATE OR REPLACE PROCEDURE PROC_MAN_DEPT_COPY
(
    P_FLAG IN VARCHAR2,
    P_DEPTID IN DEPARTMENT.DEPT_ID%TYPE,
    P_DTITLE IN DEPARTMENT.DEPT_TITLE%TYPE
)
IS
    P_CNT NUMBER := 0;
BEGIN
    IF (P_FLAG = 'UPDATE')
    THEN
        -- 3.2 UPDATE�� �μ��ڵ尡 �������� ������ �μ��ڵ�, �μ����� INSERT
        -- , �μ��ڵ尡 �����ϸ� �μ����� UPDATE�ϵ��� �Ѵ�.
        SELECT COUNT(*) INTO P_CNT FROM DEPT_COPY WHERE DEPT_ID = P_DEPTID;
        IF (P_CNT > 0)
        THEN 
            -- �����ϸ� UPDATE
            UPDATE DEPT_COPY SET DEPT_TITLE = P_DTITLE WHERE DEPT_ID = P_DEPTID;
        ELSE
            -- �������� ������ INSERT
            INSERT INTO DEPT_COPY VALUES(P_DEPTID, P_DTITLE);
        END IF;
    ELSIF (P_FLAG = 'DELETE')
    THEN 
        -- 3.3 DELETE�� �ش�μ��� ����� �����ϴ��� �˻��Ͽ� �����ϸ� ���޽����� �Բ� ��������ϰ�
        -- �׷��� ������ �����ϵ��� �Ѵ�.
        SELECT COUNT(*) INTO P_CNT FROM EMPLOYEE WHERE DEPT_CODE = P_DEPTID;
        IF (P_CNT > 0) 
        THEN
            -- �μ��� ���� ����
            DBMS_OUTPUT.PUT_LINE('ERROR : �ش� �μ��� ������ �����ϹǷ�, �μ��� ������ �� �����ϴ�.');
        ELSE
            -- �μ��� ������ ����
            DELETE FROM DEPT_COPY WHERE DEPT_ID = P_DEPTID;
        END IF;
    END IF;
    COMMIT;
END;
/
-- #3.2 ����Ȯ��
EXEC PROC_MAN_DEPT_COPY('UPDATE', 'D10', 'ȸ���');
-- #3.3 ����Ȯ��
EXEC PROC_MAN_DEPT_COPY('DELETE', 'D10', '');
SELECT * FROM DEPT_COPY ORDER BY 2 DESC;
-- ======================== PL/SQL FUNCTION
-- RETURN ���� �����ϴ� STORED PROCEDURE
-- ======================== ����
-- CREATE OR REPLACE FUNCTION �Լ���(�Ű�����1, �Ű�����2, ..)
-- RETURN �ڷ���(EX. VARCHAR2, NUMBER, ..)
-- IS
--      �������� ����
-- BEGIN
--      ���๮
-- END;
-- /
-- ======================== ������
-- EXEC ���ε� ���� := �Լ���(�Ű�����1, �Ű�����2, ..)
-- ���ڿ��� �Է¹޾� �� ���� d��b�� �ٿ� ������� �����ִ� �Լ��� �ۼ��Ͻÿ�.
-- ^^ -> d^^b , T^T -> dT^Tb
CREATE OR REPLACE FUNCTION GET_HEADPHONE
(
    P_STR VARCHAR2
)
RETURN VARCHAR2
IS
    RESULT VARCHAR2(200);
BEGIN
    RESULT := 'd'||P_STR||'b';
    RETURN RESULT; -- �ڷ����� ���� ������ ��������
END;
/
VAR vSTR VARCHAR2;
EXEC :vSTR := GET_HEADPHONE('&arg');
PRINT vSTR;

-- �ǽ����� 1
-- ����� �Է¹޾� �ش� ����� ������ ����Ͽ� �����ϴ� �Լ��� ����� ����Ͻÿ�
-- �Լ��� : FN_SALARY_CALC, ���ε� ������ : VAR_CALC
CREATE OR REPLACE FUNCTION FN_SALARY_CALC
(
    V_EMPID EMPLOYEE.EMP_ID%TYPE
)
RETURN NUMBER
IS
    CALC_SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT SALARY INTO CALC_SAL
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMPID;
    CALC_SAL := CALC_SAL*12;
    RETURN CALC_SAL;
END;
/
VAR vCAL NUMBER;
EXEC :vCAL := FN_SALARY_CALC('&EMP_ID');
PRINT vCAL;
-- select������ ����
SELECT FN_SALARY_CALC('&EMP_ID') FROM DUAL;
SELECT EMP_NAME "�����", FN_SALARY_CALC(EMP_ID) "����" FROM EMPLOYEE;
-- �ǽ�����2
-- �����ȣ�� �Է¹޾Ƽ� ������ �����ϴ� �����Լ� FN_GET_GENDER �� �����ϰ� �����غ�����.
CREATE OR REPLACE FUNCTION FN_GET_GENDER
(
    V_EMPID EMPLOYEE.EMP_ID%TYPE
)
RETURN VARCHAR2
IS
    V_GENDER EMPLOYEE.EMP_NO%TYPE;
BEGIN
    SELECT EMP_NO INTO V_GENDER
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMPID;
    IF (SUBSTR(V_GENDER,8,1) = '1') THEN
        RETURN '��';
    ELSE
        RETURN '��';
    END IF;
    RETURN V_GENDER;
END;
/
VAR vGENDER VARCHAR2;
SELECT FN_GET_GENDER('&EMP_ID') FROM DUAL;
-- �ǽ�3
-- ����ڷκ��� �Է¹��� ��������� �˻��Ͽ� �ش� ����� ���޸��� ��� ���� �Լ��� �ۼ��Ͻÿ�
-- ��,FN_GET_JOB_NAME �� �Լ� �̸����� �ϰ� �ش� ����� ���ٸ� ' �ش������� ' �� ����Ͻÿ�
CREATE OR REPLACE FUNCTION FN_GET_JOB_NAME
(
    V_EMPNAME EMPLOYEE.EMP_NAME%TYPE
)
RETURN VARCHAR2
IS
    V_JOBCODE EMPLOYEE.JOB_CODE%TYPE;
    V_JOBNAME VARCHAR2(10);
BEGIN
--    SELECT JOB_CODE 
--    INTO V_JOBCODE
--    FROM EMPLOYEE
--    WHERE EMP_NAME = V_EMPNAME;
    
    SELECT JOB_NAME 
    INTO V_JOBNAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = V_EMPNAME;
    RETURN V_JOBNAME;
EXCEPTION WHEN NO_DATA_FOUND 
THEN RETURN '�ش�������';
END;
/
SELECT FN_GET_JOB_NAME('&EMP_NAME') FROM DUAL;
SELECT EMP_NAME "�����", FN_GET_JOB_NAME(EMP_NAME) "���޸�" FROM EMPLOYEE;
-- PS/SQL ����
-- 1. �͸���
-- 2. Strored Procedure
-- 3. Function
-- =============== ����Ŭ ��ü Trigger 
-- Ʈ���� : ��Ƽ�, �������
-- Ư�� �̺�Ʈ�� DDL, DML������ ����Ǿ��� ��
-- �ڵ������� �Ϸ��� ����(Operation) ó���� ����ǵ��� �ϴ� �����ͺ��̽� ��ü �� �ϳ���
-- ex) ȸ��Ż�� �̷���� ��� ȸ�� Ż�� ������ �����Ⱓ �����ؾ� �Ǵ� ��찡 ����
-- ȸ��Ż�� �̷���� �� �ش� ������ �ڵ����� ������ �� �ֵ��� ������ �� ����.
-- or ������ ������ ������, ������ �����Ϳ� ���� �α�(�̷�)�� ����� ��� Ʈ���� ��� ����
-- ================= Ʈ���� �����
-- CREATE OR REPLACE TRIGGER Ʈ���Ÿ�
-- BEFORE (OR AFTER)
-- DELETE (OR UPDATE OR INSERT) ON ���̺��
-- [FOR EACH ROW]
-- BEGIN
--      (���๮)
-- END;
-- /
-- ���� ��� ���̺� ���ο� �����Ͱ� ������ ' ���Ի���� �Ի��Ͽ����ϴ�. ' �� ����ϱ�
CREATE OR REPLACE TRIGGER TRG_EMP_NEW
AFTER
INSERT ON EMP_DUPLICATE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('���Ի���� �Ի��Ͽ����ϴ�.');
END;
/
INSERT INTO EMP_DUPLICATE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
VALUES('224', '���Ͽ�', '991215-1394355', '01046652154', 'J5', 'S5');
ROLLBACK;
DROP TRIGGER TRG_EMP_NEW;
-- �������� 1. 