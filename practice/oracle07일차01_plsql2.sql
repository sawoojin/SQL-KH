-- ����Ŭ 7���� PL/SQL
-- �⺻ SQL �������� �ȵ� ���� �߰��Ͽ� ����� �� �ֵ��� ����
-- EX) ��������, ���, ...
SET SERVEROUTPUT ON;
SET TIMING ON;
SET TIMING OFF;
BEGIN
 DBMS_OUTPUT.PUT_LINE('HELLO PL/SQL');
END;
/

-- �ǽ�3
-- EMPLOYEE ���̺��� ����� ������ ��ȣ�� ���ѵ� +1�� ����� ����ڷκ��� �Է¹���
-- �̸�, �ֹι�ȣ, ��ȭ��ȣ, �����ڵ�, �޿������ ����ϴ� PL/SQL �� �ۼ��Ͻÿ�
-- 1. ��������ȣ�� ���ϴ� �������� ��� �� ���ΰ�?
-- 2. ������ ��ȣ�� ������ �����ؼ� ���ڵ� ��Ͻ� ���
-- 3. �̸� �Է¹ް� �ֹι�ȣ �Է¹ް� ��ȭ��ȣ �Է¹ް� �����ڵ� �Է¹ް� �޿���� �Է¹޾Ƽ�
-- EMPLOYEE ���̺� INSERT �Ͻÿ�
DECLARE
    LAST_NUM EMPLOYEE.EMP_ID%TYPE;
BEGIN
    SELECT MAX(EMP_ID)
    INTO LAST_NUM
    FROM EMPLOYEE;
    INSERT INTO EMPLYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(LAST_NUM+1, '&NAME', '&PSN', '&PHONE', '&JCODE', '&SL');
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- ���ΰ� ��ġ����� �ۼ��Ͻÿ�
-- EMPLOYEE ���̺��� �÷��� 14���ε� �Է��� ���� 6���̴�. 
-- ======================= PL/SQL ���ǹ�
-- 1. IF (���ǽ�) THEN (���๮) END IF;
-- �ǽ�1
-- �����ȣ�� �Է¹޾Ƽ� ����� ���, �̸�, �޿�, ���ʽ����� ����Ͻÿ�
-- ��, �����ڵ尡 J1�� ��� '���� ȸ�� ��ǥ���Դϴ�'�� ����ϼ���
-- ��� : 222
-- �̸� : ���¸�
-- �޿� : 2460000
-- ���ʽ��� : 0.35
-- ���� ȸ�� ��ǥ���Դϴ�
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('��� : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||EMP_INFO.SALARY);
    DBMS_OUTPUT.PUT_LINE('���ʽ��� : '||EMP_INFO.BONUS);
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('���� ȸ�� ��ǥ���Դϴ�');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 2. IF(���ǽ�) THEN (���๮) ELSE (���๮) END IF;
-- �ǽ�2
-- �����ȣ�� �Է¹޾Ƽ� ����� ���, �̸�, �μ���, ���޸��� ����Ͻÿ�.
-- ��, �����ڵ尡 J1�� ��� '��ǥ��' �� �ܿ��� '�Ϲ�����'���� ����ϼ���.
-- ��� : 201
-- �̸� : ������
-- �μ��� : �ѹ���
-- ���޸� : �λ���
-- �Ҽ� : �Ϲ�����
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
    JOB_INFO JOB.JOB_CODE%TYPE;
    
BEGIN
    SELECT *
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('��� : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�μ��� : '||JOB_INFO);
    DBMS_OUTPUT.PUT_LINE('���޸� : '||EMP_INFO.BONUS);
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN EMPTEAM :='���� ȸ�� ��ǥ���Դϴ�';
    ELSEIF (JCODE = 
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 3. IF (���ǽ�) THEN (���๮) ELSIF (���ǽ�) THEN (���๮) ELSE (���๮) END IF;
-- �ǽ�3
-- ����� �Է¹��� �� �޿��� ���� ������� ������ ����ϵ��� �Ͻÿ�.
-- �׶� ��� ���� ���, �̸�, �޿�, �޿������ ����Ͻÿ�
-- 500 �̻� A 400-499 B 300 399B200 299 100 199 0 99F
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
    GRADE CHAR;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMP_INFO.EMP_ID, EMP_INFO.EMP_NAME, EMP_INFO.SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('��� : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||EMP_INFO.SALARY);
    IF (EMP_INFO.SALARY >= 5000000)
        THEN GRADE := 'A';
    ELSIF (EMP_INFO.SALARY >= 4000000)
        THEN GRADE := 'B';
    ELSIF (EMP_INFO.SALARY >= 3000000)
        THEN GRADE := 'C';
    ELSIF (EMP_INFO.SALARY >= 2000000)
        THEN GRADE := 'D';
    ELSIF (EMP_INFO.SALARY >= 1000000)
        THEN GRADE := 'E';
    ELSE
        GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE('�޿���� : '||GRADE);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 4.CASE��
-- CASE
--      WHEN �� THEN ���๮
--      WHEN �� THEN ���๮
-- END CASE;
-- �Է¹��� ���� 1�̸� �������Դϴ�. 2�� ������Դϴ� 3�̸� �ʷϻ��Դϴٸ� ����ϼ���
DECLARE
    INPUTVAL NUMBER;
BEGIN
    INPUTVAL := '&�Է°�';
    CASE INPUTVAL
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('������');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('�뷩��');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('�ʷ���');
    END CASE;
END;
/
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
    GRADE VARCHAR2(1);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMP_INFO.EMP_ID, EMP_INFO.EMP_NAME, EMP_INFO.SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('��� : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||EMP_INFO.SALARY);
    GRADE := FLOOR(GRADE / 1000000);
    CASE GRADE
        WHEN 5 THEN DBMS_OUTPUT.PUT_LINE('�޿���� : A');
        WHEN 4 THEN DBMS_OUTPUT.PUT_LINE('�޿���� : B');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('�޿���� : C');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('�޿���� : D');
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('�޿���� : E');
        WHEN 0 THEN DBMS_OUTPUT.PUT_LINE('�޿���� : F');
    END CASE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- PL/SQL ���� ��� �� ���ǹ� IF
-- 1. IF (���ǽ�) THEN (���๮) END IF;
-- 2. IF (���ǽ�) THEN (���๮) ELSE (���๮) END IF;
-- 3. IF (���ǽ�) THEN (���๮) ELSIF (���๮) THEN (���๮) ELSE (���๮) END IF;
-- ===================== PL/SQL �ݺ���
-- 1. LOOP
-- 2. WHILE LOOP
-- 3. FOR LOOP
-- ���� 1~5���� �ݺ� ����ϱ�
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
        EXIT WHEN N > 5;
--        IF(N > 5) THEN EXIT;
--        END IF;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- �ǽ�1
-- 1 ~ 10 ������ ������ 5�� ����غ�����
DECLARE
    N NUMBER;
BEGIN
    N := 1;
    LOOP
        DBMS_OUTPUT.PUT_LINE(FLOOR(DBMS_RANDOM.VALUE(1,11)));
        N := N+1;
        EXIT WHEN N > 5;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 2. WHILE LOOP 
-- ���� ������ TRUE �� ���ȸ� ������ �ݺ� �����
-- LOOP�� ������ �� ������ ó������ FALSE�̸� �ѹ��� ������� ���� �� ����
-- EXIT ���� ��� �������� �ݺ��� ���� ������ ����� �� ����
-- WHILE(���ǽ�) LOOP (���๮) END LOOP;
-- 1 ~ 5 ���
DECLARE
    N NUMBER := 1;
BEGIN
    WHILE(N <= 5) LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/
-- �ǽ� 2
-- ����ڷκ��� 2~9 ���̿� ���� �Է¹޾� �������� ����Ͻÿ� ELSE 2~9������ ���� �Է��ϼ���
-- 2 * 1 = 2
DECLARE
    N NUMBER := 1;
    M NUMBER := '&����';
BEGIN
    IF (M >= 10) THEN DBMS_OUTPUT.PUT_LINE('2~9������ ���� �Է��ϼ���');
    ELSIF (M <= 1) THEN DBMS_OUTPUT.PUT_LINE('2~9������ ���� �Է��ϼ���');
    ELSE
        WHILE(N <= 9) LOOP
            DBMS_OUTPUT.PUT_LINE(M ||' * '|| N ||' = '|| M*N );
            N := N + 1;
        END LOOP;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- ��������3
-- 1~30������ �� �߿��� Ȧ���� ����Ͻÿ�
-- LOOP (���๮) EXIT WHEN(N > 6) END LOOP;
-- WHILE(N > 6) LOOP (���๮) END LOOP;
-- ��� : ���ǹ�, �ݺ���, �б⹮(COUNTINUE, BREAK)
DECLARE
    N NUMBER := 0;
BEGIN
    WHILE (N < 30) LOOP
    N := N+1;
        CONTINUE WHEN MOD(N,2) = 0;
--        IF(MOD(N,2) = 1) THEN
        DBMS_OUTPUT.PUT_LINE(N);
--        END IF;
    END LOOP;
END;
/
-- FOR LOOP
-- FOR LOOP ������ ī��Ʈ�� ������ �ڵ� ����ǹǷ�, ���� ���� ������ �ʿ䰡 ��
-- ī��Ʈ�� �ڵ����� 1�� ����
-- REVERSE�� 1�� ����
BEGIN
    FOR N IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/
-- �ǽ�4
-- EMPLOYEE ���̺��� ����� 200 ~ 210�� �������� �����ȣ, �����, �̸����� ���
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    FOR EMP_REC IN (SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE) LOOP
        EXIT WHEN EMP_REC.EMP_ID > 210;
        DBMS_OUTPUT.PUT_LINE('�����ȣ: ' || EMP_REC.EMP_ID ||', �����: ' || EMP_REC.EMP_NAME ||', �̸���: ' || EMP_REC.EMAIL);
    END LOOP;
END;
/
-- �ǽ�5
-- KH_NUMBER_TBL �� ����Ÿ���� �÷� NO�� ��¥Ÿ���� �÷� INPUT_DATE�� �����Ѵ�
-- KH_NUMBER_TBL ���̺� 0 ~ 99 ������ ������ 10�� �����Ͻÿ� ��¥�� �����
CREATE TABLE KH_NUMBER_TBL
(
    NO NUMBER,
    INPUT_DATE DATE DEFAULT SYSDATE
);
BEGIN
    FOR N IN 1..10 LOOP
        INSERT INTO KH_NUMBER_TBL
        VALUES(FLOOR(DBMS_RANDOM.VALUE(0,99)), DEFAULT);
    END LOOP;
END;
/
DROP TABLE KH_NUMBER_TBL;
--------------------- PS/SQL ����ó��
-- �ý��� ����(�޸� �ʰ�, �ε��� �ߺ� Ű ��)�� ����Ŭ�� �����ϴ� ������
-- ���� PL/SQL ���� ������ ���� ������ Ž���Ͽ� �߻���Ű�� ������
-- 1. �̸� ���ǵ� ����ó��
-- 2. ����� ���� ����ó��
-- 3. �̸� ���ǵ��� ���� ����ó��(��ȭ)
-- NO_DATA_FOUND
-- SELECT INTO ������ ����� ���õ� ���� �ϳ��� ���� ���
-- DUP_VAL_ON_INDEX
-- UNIQUE �ε����� ������ �÷��� �ߺ� �����͸� �Է��� ���
-- CASE_NOT_FOUND : CASE �������� ELSE ������ ���� WHEN ���� ��õ� ������ �����ϴ� ���� ���� ���
-- ACCESS_INTO_NULL : �ʱ�ȭ���� ���� ������Ʈ�� ���� �Ҵ��Ϸ��� �� ���
-- COLLECTION_IS_NULL : �ʱ�ȭ���� ���� ��ø ���̺��̳� VARRAY���� �÷����� EXISTS���� �ٸ� �޼ҵ�� ������ ���
-- CURSOR_ALREADY_OPEN : �̹� ���µ� Ŀ���� �ٽ� �����Ϸ��� �õ��ϴ� ���
-- INVALID_CURSOR : ������ ���� Ŀ���� ������ ��� (OPEN���� ���� Ŀ���� �������� �� ���)
-- INVALID_NUMBER : ������ �����͸� ���������� ��ȯ�� �� ����� �� ���ڰ� �ƴ� ���
-- LOGIN_DENIED : �߸��� ����ڸ��̳� ��й�ȣ�� ���� �õ�
BEGIN
 INSERT INTO EMPLOYEE(EMP_ID, ENP_NAME, EMP_NO, PHONE, JOB_CODE, GRADE);
 VALUES(200, ; �̹���','991214-2312323.'01020465453','35','S5');
EXCEPTION
    WHEN                                                                                                                                                                                                                                                                                                                                                                                                
END;
/

-- DECLARE
-- BEGIN
-- EXCEPTION
--      WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
-- END;
-- /;