SET SERVEROUTPUT ON;
--����Ŭ 9���� Ʈ���� �Ĺݺ�
--Ʈ���Ŷ�?
--��Ƽ�, �������
--ȸ���� ���� �� ������ ȸ�������� ���� (DELETE -> INSERT)
--DELETE�� �Ǹ��� �ڵ����� INSERT�ǵ��� �ϴ� ���� Ʈ����
--������ INSERT ->���Ի���� �Ի��Ͽ����ϴ� �޽��� ���
--INSERT�� �Ǹ��� �ڵ����� ���Ի���� �Ի��Ͽ����ϴ� �޽��� ���
--======================== �ǻ��ڵ� OLD, NEW=========================
--FOR EACH ROW�� ��� (����� ��)
--1.INSERT: OLD ->NULL(�ƹ��͵� ����),NEW -> ���� ���� ���ڵ� (INSERT�� ����)
--2.UPDATE:
--3.DELETE

-- ����2. EMP_DUPLICATE ���̺� ������ �����Ͽ��� ��, EMP_TEMP ��� ���̺� ������ ��������
-- ������ �����ϴ� Ʈ���Ÿ� �����Ͻÿ�. �� Ʈ���� �̸��� TRG_EMP_DEL_INFO ��� ��.
-- 1. EMP_TEMP ���̺��� ����� ���

CREATE TABLE EMP_TEMP
AS SELECT * FROM EMP_DUPLICATE WHERE 1 = 2;
SELECT * FROM EMP_TEMP;

CREATE OR REPLACE TRIGGER TRG_EMP_DEL_INFO
AFTER
DELETE ON EMP_DUPLICATE
FOR EACH ROW
BEGIN
    INSERT INTO EMP_TEMP
    VALUES(:OLD.EMP_ID, :OLD.EMP_NAME, :OLD.EMP_NO, :OLD.EMAIL, :OLD.PHONE, :OLD.DEPT_CODE, :OLD.JOB_CODE, :OLD.SAL_LEVEL, :OLD.SALARY, :OLD.BONUS, :OLD.MANAGER_ID
    , :OLD.HIRE_DATE, :OLD.ENT_DATE, :OLD.ENT_YN);
END;
/
-- 3. Ʈ���� ���� Ȯ�� �� �׽�Ʈ �غ�
COMMIT;
DELETE FROM EMP_DUPLICATE WHERE EMP_ID = '201';
SELECT * FROM EMP_TEMP;
SELECT * FROM EMP_DUPLICATE;
-- �ǽ� 1
-- 1. ��ǰ PRODUCT ���̺���� ���ڷ� �� PCODE �÷��� �ְ� PRIMARRY KEY�� �����Ѵ�
-- ���ڿ� ũ�Ⱑ 30�� PNAME�� �÷�, ���ڿ� ũ�Ⱑ 30�� BRAND�÷�, ���ڷ� �� PRICE �÷�
-- ���ڷ� �Ǿ� �ְ� �⺻���� 0�� STOCK �÷��� ����
CREATE TABLE PRODUCT
(
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(30),
    BRAND VARCHAR2(30),
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0
);
SELECT * FROM PRODUCT;
-- 2. ��ǰ ����� PRODUCT_IO ���̺��� ���ڷ� �� IOCODE �÷��� �ְ� PRIMARY KEY �� �����Ѵ�.
-- ���ڷ� �� PCODE �÷�, ��¥�� �� PDATE �÷� ���ڷ� �� AMOUNT �÷�, ���ڿ� ũ�Ⱑ 10��
-- STATUS �÷��� ���� STATUS �÷��� �԰� �Ǵ� ��� �Է°�����
-- PCODE �� PRODUCT ���̺��� PCODE�� �����Ͽ� �ܷ�Ű�� �����Ѵ�.
CREATE TABLE PRODUCT_IO
(
    IOCODE NUMBER PRIMARY KEY,
    PCODE NUMBER, -- �÷� ���� CONSTRAINT FK_PRODUCT_IO REFERENCES PRODCUT (PCODE)
    PDATE DATE,
    AMOUNT NUMBER,
    STATUS VARCHAR2(10) CHECK(STATUS IN('�԰�','���'))
    -- ���̺� ����, FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE)
);
SELECT * FROM PRODUCT_IO;
-- ***** �ܷ�Ű ��������
ALTER TABLE PRODUCT_IO
ADD CONSTRAINT FK_PRODUCT_IO FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE);
-- 3. �������� SEQ_PRODUCT_PCODE, SEQ_PRODUVTIO_IOCODE��� �̸����� �⺻������ �����Ǿ� ����
CREATE SEQUENCE SEQ_PRODUCT_PCODE
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;
CREATE SEQUENCE SEQ_PRODUCT_IOCODE;
-- 4. Ʈ������ �̸��� TRG_PRODUCT �̰� PRODUCT_IO ���̺� �԰� �ϸ� PRODUCT ���̺�
-- STOCK�÷��� ���� �߰��ϰ� PRODUCT_IO ���̺� ��� �ϸ� STOCK �÷��� ���� ���־�� �Ѵ�.
INSERT INTO PRODUCT 
VALUES(SEQ_PRODUCT_PCODE.NEXTVAL, '�󱸰�', 'NBA', '20000', DEFAULT);
DESC PRODUCT_IO;

INSERT INTO PRODUCT_IO 
VALUES(SEQ_PRODUCT_IOCODE.NEXTVAL, 1, SYSDATE, 10, '�԰�');
INSERT INTO PRODUCT_IO
VALUES(SEQ_PRODUCT_PCODE.NEXTVAL, 1, SYSDATE, 5, '���');
COMMIT;

CREATE OR REPLACE TRIGGER TRG_PRODUCT -- INSERT �� �����ؾ� �Ǵ� ������
AFTER INSERT ON PRODUCT_IO
FOR EACH ROW
BEGIN
    IF (:NEW.STATUS = '�԰�') THEN 
        UPDATE PRODUCT  
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    ELSIF (:NEW.STATUS = '���') THEN
        UPDATE PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/
SELECT * FROM PRODUCT;
