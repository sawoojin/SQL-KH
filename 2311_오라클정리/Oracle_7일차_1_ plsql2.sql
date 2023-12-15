-- ����Ŭ 7���� PL/SQL
-- �⺻ SQL�������� �ȵ� ���� �߰��Ͽ� ����� �� �ֵ��� ����
-- ex) ��������, ���, ...
SET SERVEROUTPUT ON;

SET TIMING ON;
SET TIMING OFF;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;
/
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
BEGIN
    SELECT EMP_ID
    INTO VEMPID
    FROM EMPLOYEE
    WHERE EMP_NAME = '&�̸�';
END;
/

-- @�ǽ�����3
-- EMPLOYEE ���̺��� ����� ������ ��ȣ�� ���ѵ� +1�� ����� ����ڷκ���
-- �Է¹��� �̸�, �ֹι�ȣ, ��ȭ��ȣ, �����ڵ�, �޿������ ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
-- 1. ��������ȣ�� ���ϴ� �������� ��� �� ���ΰ�?
-- 2. ��������ȣ�� ������ �����ؼ� ���ڵ� ��Ͻ� ���
-- 3. �̸� �Է¹ް� �ֹι�ȣ �Է¹ް� ��ȭ��ȣ �Է¹ް� �����ڵ� �Է¹ް� �޿���� �Է¹޾Ƽ�
-- EMPLOYEE���̺� INSERT�Ͻÿ�!
DECLARE
    LAST_NUM EMPLOYEE.EMP_ID%TYPE;
BEGIN
    SELECT MAX(EMP_ID)
    INTO LAST_NUM
    FROM EMPLOYEE;
    
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(LAST_NUM+1, '&NAME', '&PSN', '&PHONE', '&JCODE', '&SL');
    COMMIT;
--EXCEPTION
--    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/
SELECT * FROM EMPLOYEE ORDER BY 1 DESC;
ROLLBACK;
-- ���ΰ� ��ġ����� �ۼ��Ͻÿ�
-- ���� : EMPLOYEE���̺��� �÷��� 14���ε� �Է��� ���� 6���̴�. �׷��� ���� ���� ������� �ʽ��ϴ�.
-- ��ġ���1 : �Է��� ���� 6���� �߻��� �����̹Ƿ� 8�� �߰��Ͽ� 14���� �����ش�.
-- ��ġ���2 : �Է��� ���� 6���̰� 6���� �Է��ϱ� ���ؼ� �÷��� �������ش�.
/*
���� ���� -
ORA-06550: �� 8, ��17:PL/SQL: ORA-00947: ���� ���� ������� �ʽ��ϴ�
ORA-06550: �� 8, ��5:PL/SQL: SQL Statement ignored
06550. 00000 -  "line %s, column %s:\n%s"
*Cause:    Usually a PL/SQL compilation error.
*Action:
*/

-- =========================== PL/SQL�� ���ǹ� ============================
-- 1. IF (���ǽ�) THEN (���๮) END IF;
-- @�ǽ�����1
-- �����ȣ�� �Է¹޾Ƽ� ����� ���, �̸�, �޿�, ���ʽ����� ����Ͻÿ�
-- ��, �����ڵ尡 J1�� ��� '���� ȸ�� ��ǥ���Դϴ�.'�� ����Ͻÿ�.
-- ��� : 222
-- �̸� : ���¸�
-- �޿� : 2460000
-- ���ʽ��� : 0.35
-- ���� ȸ�� ��ǥ���Դϴ�.
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    --SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    SELECT *
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('��� : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||EMP_INFO.SALARY);
    DBMS_OUTPUT.PUT_LINE('���ʽ��� : '||EMP_INFO.BONUS*100||'%');
    
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('���� ȸ�� ��ǥ���Դϴ�.');
    END IF;
    -- IF () THEN ~ END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/

-- 2. IF (���ǽ�) THEN (���๮) ELSE (���๮) END IF;
-- @�ǽ�����2
-- �����ȣ�� �Է¹޾Ƽ� ����� ���, �̸�, �μ���, ���޸��� ����Ͻÿ�.
-- ��, �����ڵ尡 J1�� ��� '��ǥ', �� �ܿ��� '�Ϲ�����'���� ����Ͻÿ�.
-- ��� : 201
-- �̸� : ������
-- �μ��� : �ѹ���
-- ���޸� : �λ���
-- �Ҽ� : �Ϲ�����
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    JNAME JOB.JOB_NAME%TYPE;
    JCODE JOB.JOB_CODE%TYPE;
    EMPTEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, JOB_CODE
    INTO EMPID, ENAME, DTITLE, JNAME, JCODE
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    LEFT OUTER JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMP_ID';
    
    IF (JCODE = 'J1')
    THEN EMPTEAM := '�ӿ�';
    ELSIF (JCODE = 'J2') 
    THEN EMPTEAM := '�λ���';
    ELSE EMPTEAM := '�Ϲ�����';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('��� : '||EMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('�μ��� : '||DTITLE);
    DBMS_OUTPUT.PUT_LINE('���޸� : '||JNAME);
    DBMS_OUTPUT.PUT_LINE('�Ҽ� : '||EMPTEAM);
END;
/
-- 3. IF (���ǽ�) THEN (���๮) ELSIF (���ǽ�) THEN (���๮) ELSE (���๮) END IF;
-- @�ǽ�����3
-- ����� �Է� ���� �� �޿��� ���� ����� ������ ����ϵ��� �Ͻÿ�.
-- �׶� ��� ���� ���, �̸�, �޿�, �޿������ ����Ͻÿ�.
-- 500���� �̻�(�׿�) : A
-- 400���� ~ 499���� : B
-- 300���� ~ 399���� : C
-- 200���� ~ 299���� : D
-- 100���� ~ 199���� : E
-- 0���� ~ 99���� : F

-- ��� : 201
-- �̸� : ������
-- �޿� : 5000000
-- �޿���� : A
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL   EMPLOYEE.SALARY%TYPE;
    SLEVEL VARCHAR2(2);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMPID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&���';
    SAL := SAL / 10000;
    IF( SAL >= 0 AND SAL <= 99)
    THEN SLEVEL := 'F';
    ELSIF(SAL BETWEEN 100 AND 199) THEN SLEVEL := 'E';
    ELSIF(SAL BETWEEN 200 AND 299) THEN SLEVEL := 'D';
    ELSIF(SAL BETWEEN 300 AND 399) THEN SLEVEL := 'C';
    ELSIF(SAL BETWEEN 400 AND 499) THEN SLEVEL := 'B';
    ELSE SLEVEL := 'A';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('��� : '||EMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||SAL);
    DBMS_OUTPUT.PUT_LINE('�޿���� : '||SLEVEL);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_ID = '&���';

-- 4. CASE��
-- CASE ����
--      WHEN ��1 THEN ���๮1
--      WHEN ��2 THEN ���๮2
--      WHEN ��3 THEN ���๮3
--      WHEN ��4 THEN ���๮4
-- END CASE;
-- �Է¹��� ���� 1�̸� �������Դϴ�. 2�� ������Դϴ�. 3�̸� �ʷϻ��Դϴٸ� ����ϼ���.
DECLARE
    INPUTVAL NUMBER;
BEGIN
    INPUTVAL := '&INPUTVAL';
    CASE INPUTVAL
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('�������Դϴ�.');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('������Դϴ�.');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('�ʷϻ��Դϴ�.');
    END CASE;
END;
/

-- ================= �޿���� ��¹��� CASE������ �ٲ㺸�� ======================
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL   EMPLOYEE.SALARY%TYPE;
    SLEVEL VARCHAR2(2);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMPID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&���';
    SAL := FLOOR(SAL / 1000000);
    CASE SAL
        WHEN 0 THEN SLEVEL := 'F';
        WHEN 1 THEN SLEVEL := 'E';
        WHEN 2 THEN SLEVEL := 'D';
        WHEN 3 THEN SLEVEL := 'C';
        WHEN 4 THEN SLEVEL := 'B';
        ELSE SLEVEL := 'A';
    END CASE;
--    IF( SAL >= 0 AND SAL <= 99)
--    THEN SLEVEL := 'F';
--    ELSIF(SAL BETWEEN 100 AND 199) THEN SLEVEL := 'E';
--    ELSIF(SAL BETWEEN 200 AND 299) THEN SLEVEL := 'D';
--    ELSIF(SAL BETWEEN 300 AND 399) THEN SLEVEL := 'C';
--    ELSIF(SAL BETWEEN 400 AND 499) THEN SLEVEL := 'B';
--    ELSE SLEVEL := 'A';
--    END IF;
    
    DBMS_OUTPUT.PUT_LINE('��� : '||EMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||SAL);
    DBMS_OUTPUT.PUT_LINE('�޿���� : '||SLEVEL);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/
-- PL/SQL���� ��� �� ���ǹ� IF
-- 1. IF (���ǽ�) THEN (���๮) END IF;
-- 2. IF (���ǽ�) THEN (���๮) ELSE (���๮) END IF;
-- 3. IF (���ǽ�) THEN (���๮) ELSIF (���ǽ�) THEN (���๮) ELSE (���๮) END IF;

-- ============================= PL/SQL�� �ݺ��� ===================================
-- 1. LOOP
-- 2. WHILE LOOP
-- 3. FOR LOOP

-- 1. LOOP
-- ���� 1 ~ 5���� �ݺ� ����ϱ�
DECLARE
    N NUMBER := 1;
BEGIN
    -- for(var i = 0; i < 5; i++) console.log(i);
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
        EXIT WHEN N > 5;
--        IF(N > 5)
--        THEN EXIT;
--        END IF;
    END LOOP;
END;
/
-- @�ǽ�����1
-- 1 ~ 10 ������ ������ 5�� ����غ��ÿ�.
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(FLOOR(DBMS_RANDOM.VALUE(1,11)));
        N := N + 1;
        EXIT WHEN N > 5;
    END LOOP;
END;
/
-- 2. WHILE LOOP
-- ���� ������ TRUE�� ���ȸ� ������ �ݺ� �����
-- LOOP�� ������ �� ������ ó������ FALSE�̸� �ѹ��� ������� ���� �� ����.
-- EXIT���� ��� �������� �ݺ��� ���� ������ ����� �� ����.
-- WHILE(���ǽ�) LOOP (���๮) END LOOP;
-- 1 ~ 5���� WHILE LOOP���� ����غ���
DECLARE
    N NUMBER := 1;
BEGIN
    WHILE(N <= 5) LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/
-- @�ǽ�����2
-- ����ڷκ��� 2~9������ ���� �Է¹޾� �������� ����Ͻÿ�.
-- 2 * 1 = 2
-- 2 * 2 = 4
-- ...
-- 2 * 9 = 18

-- 2 ~ 9 ������ ���� �Է��ϼ���.
DECLARE
    N NUMBER := 1;
    DAN NUMBER;
BEGIN
    DAN := '&��';
    IF (DAN BETWEEN 2 AND 9) 
    THEN         
        WHILE(N < 10) LOOP
            DBMS_OUTPUT.PUT_LINE(DAN||' * '||N||' = '||DAN * N);
            N := N + 1;
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('2 ~ 9 ������ ���� �Է��ϼ���.');
    END IF;
END;
/

-- @�ǽ�����3
-- 1 ~ 30������ �� �߿��� Ȧ���� ����Ͻÿ�~
-- 2�� ���� �������� 0�� �ƴϸ� Ȧ����.
-- ��� : ���ǹ�, �ݺ���, �б⹮(continue, break)
DECLARE
    N NUMBER := 0;
BEGIN
    WHILE(N < 30) LOOP
         N := N + 1;
         CONTINUE WHEN MOD(N,2) = 0;
         DBMS_OUTPUT.PUT_LINE(N);
         -- MOD(N, 2)
--         IF(MOD(N,2) != 0)
--         THEN DBMS_OUTPUT.PUT_LINE(N);
--         END IF;
    END LOOP;
END;
/


-- LOOP (���๮) EXIT WHEN(N > 6) END LOOP;
-- WHILE(N > 6) LOOP (���๮) END LOOP;

-- 3. FOR LOOP
-- FOR LOOP������ ī��Ʈ�� ������ �ڵ� ����ǹǷ�, ���� ���� ������ �ʿ䰡 ����.
-- ī��Ʈ ���� �ڵ����� 1�� ������.
-- REVERSE�� 1�� ������.
-- FOR LOOP�� �̿��Ͽ� 1 ~ 5���� ����Ͻÿ�.
BEGIN
    FOR D IN 1..100
    LOOP
        IF(D > 1)
        THEN DBMS_OUTPUT.PUT_LINE(D);
        END IF;
    END LOOP;
END;
/
-- @�ǽ�����4
-- EMPLOYEE ���̺��� ����� 200 ~ 210�� �������� �����ȣ, �����, �̸����� ����Ͻÿ�~!
DECLARE
    EINFO EMPLOYEE%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('ID          NAME              EMAIL');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    FOR I IN 200..210
    LOOP
        SELECT *
        INTO EINFO
        FROM EMPLOYEE
        WHERE EMP_ID = I;
        DBMS_OUTPUT.PUT_LINE(EINFO.EMP_ID||'        '||EINFO.EMP_NAME||'        '||EINFO.EMAIL);
    END LOOP;
END;
/

-- @�ǽ�����5
-- KH_NUMBER_TBL�� ����Ÿ���� �÷� NO�� ��¥Ÿ���� �÷� INPUT_DATE�� ������ �ִ�.
-- KH_NUMBER_TBL ���̺� 0 ~ 99 ������ ������ 10�� �����Ͻÿ�. ��¥�� �������.
CREATE TABLE KH_NUMBER_TBL
(
    NO NUMBER,
    INPUT_DATE DATE DEFAULT SYSDATE
);
SELECT COUNT(*) FROM KH_NUMBER_TBL;
ROLLBACK;
BEGIN
    FOR N IN 1..10000
    LOOP
        INSERT INTO KH_NUMBER_TBL
        VALUES(FLOOR(DBMS_RANDOM.VALUE(0,99)), DEFAULT);
    END LOOP;
    COMMIT;
END;
/

-- =========================== PL/SQL ����ó�� =================================
-- �ý��� ����(�޸� �ʰ�, �ε��� �ߺ� Ű ��)�� ����Ŭ�� �����ϴ� ������
-- ���� PL/SQL ���� ������ ���� ������ Ž���Ͽ� �߻���Ű�� ������.
-- 1. �̸� ���ǵ� ����ó��
-- 2. ����� ���� ����ó��
-- 3. �̸� ���ǵ��� ���� ����ó��(��ȭ)
-- NO_DATA_FOUND
-- SELECT INTO ������ ����� ���õ� ���� �ϳ��� ���� ���
-- DUP_VAL_ON_INDEX
-- UNIQUE �ε����� ������ �÷��� �ߺ� �����͸� �Է��� ���
-- CASE_NOT_FOUND
-- CASE���忡�� ELSE ������ ���� WHEN���� ��õ� ������ �����ϴ� ���� ���� ���
-- ACCESS_INTO_NULL
-- �ʱ�ȭ���� ���� ������Ʈ�� ���� �Ҵ��Ϸ��� �� ��
-- COLLECTION_IS_NULL
-- �ʱ�ȭ���� ���� ��ø ���̺��̳� VARRAY���� �÷����� EXISTS�ܿ� �ٸ� �޼ҵ�� ������ �õ��� ���
-- CURSOR_ALREADY_OPEN
-- �̹� ���µ� Ŀ���� �ٽ� �����Ϸ��� �õ��ϴ� ���
-- INVALID_CURSOR
-- ������ ���� Ŀ���� ������ ��� (OPEN���� ���� Ŀ���� �������� �� ���)
-- INVALID_NUMBER
-- SQL���忡�� ������ �����͸� ���������� ��ȯ�� �� ����� �� ���ڷ� ��ȯ���� ���� ���
-- LOGIN_DENIED
-- �߸��� ����ڸ��̳� ��й�ȣ�� ������ �õ��� ��
BEGIN
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(200, '�̹����', '991214-2312323', '01029293838', 'J5', 'S5');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('�̹� �����ϴ� ����Դϴ�.');
END;
/

--DECLARE
--BEGIN
--EXCEPTION
--    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NONO');
--END;
--/

























