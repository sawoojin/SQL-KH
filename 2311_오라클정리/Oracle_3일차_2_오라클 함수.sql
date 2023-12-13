-- ����Ŭ �Լ��� ����1
-- 1. ������ �Լ� - ����� ������
-- 2. ������ �Լ� - ����� 1��(�׷��Լ�)

-- ����Ŭ �Լ��� ����2
-- 1. ���� ó�� �Լ�
--  a. LENGTH, LENGTHB : ���� ����
--  b. INSTR, INSTRB : ��ġ ����
--  c. LPAD/RPAD     : �� ���� ä����
--  d. LTRIM/RTRIM   : Ư������ ����(��������)
--  e. TRIM
--  f. SUBSTR        : ���ڿ� �߶���
--  g. CONCAT / ||   : ���ڿ� ������
--  h. REPLACE       : ���ڿ� �ٲ���
-- 2. ���� ó�� �Լ�
--  - ABS, FLOOR, CEIL(���ް� 1��), MOD, ROUND, TRUNC(���ް� 2�� ����)
-- 3. ��¥ ó�� �Լ�
--  1. SYSDATE
SELECT SYSDATE FROM DUAL;
--  2. ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
--  3. MONTHS_BETWEEN()
SELECT MONTHS_BETWEEN('24/04/25', SYSDATE) FROM DUAL;
-- ex1) EMPLOYEE ���̺��� ����� �̸�, �Ի���, �Ի� �� 3������ �� ��¥�� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE,3)
FROM EMPLOYEE;
-- ex2) EMPLOYEE ���̺��� ����� �̸�, �Ի���, �ٹ� �������� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, HIRE_DATE, 
FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),
TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE),1)
FROM EMPLOYEE;
--  4. LAST_DAY()
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('24/04/25') FROM DUAL;
SELECT LAST_DAY('20/02/22') FROM DUAL;
-- ex3) EMPLOYEE ���̺��� ����̸�, �Ի���, �Ի���� ���������� ��ȸ�ϼ���.
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;
--  5. EXTRACT
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE)||'��' "��"
, EXTRACT(MONTH FROM SYSDATE)||'��' "��"
, EXTRACT(DAY FROM SYSDATE)||'��' "��"
FROM DUAL;
-- ex4) EMPLOYEE ���̺��� ����̸�, �Ի� �⵵, �Ի� ��, �Ի� ���� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE)||'��' "��"
, EXTRACT(MONTH FROM HIRE_DATE)||'��' "��"
, EXTRACT(DAY FROM HIRE_DATE)||'��' "��"
FROM EMPLOYEE;
-- @�ǽ�����
/*
    ���úη� �Ͽ��ھ��� ���뿡 �������ϴ�.
    ������ �Ⱓ�� 1�� 6������ �Ѵٶ�� �����ϸ�
    ù��°, �������ڴ� �������� ���ϰ�
    �ι�°, ������¥���� �Ծ�� �� «���� �׸����� �����ּ���!!
    (��, 1�� 3���� �Դ´ٰ� �Ѵ�.)
*/
SELECT ADD_MONTHS(SYSDATE,18) "���볯¥"
, (ADD_MONTHS(SYSDATE,18)-SYSDATE)*3 "«���"
FROM DUAL;

-- 4. ����ȯ �Լ�
-- a. TO_CHAR()
-- b. TO_DATE()
-- c. TO_NUMBER()
-- EMPLOYEE���̺��� �Ի����� 00/01/01 ~ 10/01/01 ������ ������ ������ ����Ͻÿ�.
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN TO_DATE('00/01/01') AND TO_DATE('10/01/01');
DESC EMPLOYEE;
-- TO_NUMBER() ����
SELECT TO_NUMBER('1,000,000', '9,999,999') - TO_NUMBER('500,000', '999,999') FROM DUAL;
SELECT TO_NUMBER('1000000') - TO_NUMBER('500000') FROM DUAL;
-- TO_CHAR() ����
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY"��" MM"��" DD"��"') FROM EMPLOYEE;

-- 4. NULL ó�� �Լ�
SELECT * FROM EMPLOYEE;
SELECT EMP_NAME, SALARY, SALARY*NVL(BONUS,0), NVL(MANAGER_ID,'����') FROM EMPLOYEE;
-- 5. DECODE / CASE �Լ�





-- @�Լ� �����ǽ�����
--1. ������� �̸��� , �̸��� ���̸� ����Ͻÿ�
--		  �̸�	    �̸���		�̸��ϱ���
--	ex)  ȫ�浿 , hong@kh.or.kr   	  13
SELECT EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL) FROM EMPLOYEE;
--2. ������ �̸��� �̸��� �ּ��� ���̵� �κи� ����Ͻÿ�
--	ex) ���ö	no_hc
--	ex) ������	jung_jh
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL,'@',1,1)-1)
, RTRIM(EMAIL, '@kh.or.kr')
, REPLACE(EMAIL, '@kh.or.kr', '')
FROM EMPLOYEE;
--3. 60��뿡 �¾ ������� ���, ���ʽ� ���� ����Ͻÿ�. �׶� ���ʽ� ���� null�� ��쿡�� 0 �̶�� ��� �ǰ� ����ÿ�
--	    ������    ���      ���ʽ�
--	ex) ������	    1962	    0.3
--	ex) ������	    1963  	    0
SELECT EMP_NAME "������", 1900+TO_NUMBER(SUBSTR(EMP_NO,1,2)) "���", NVL(BONUS,0) "���ʽ�"
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO,1,2) >= 60 AND SUBSTR(EMP_NO,1,2) <= 69;
--WHERE SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69;
WHERE EMP_NO LIKE '6%';

SELECT EMP_NAME "������", (SUBSTR(EMP_NO,1,2)) "���", NVL(BONUS,0) "���ʽ�"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 90 AND 99
UNION
SELECT EMP_NAME "������", (SUBSTR(EMP_NO,1,2)) "���", NVL(BONUS,0) "���ʽ�"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 0 AND 9;

--4. '010' �ڵ��� ��ȣ�� ���� �ʴ� ����� ��ü ������ ����Ͻÿ�.
SELECT * FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--5. ������� �Ի����� ����Ͻÿ� 
--	��, �Ʒ��� ���� ��µǵ��� ����� ���ÿ�
--	    ������		�Ի���
--	ex) ������		2012�� 12��
--	ex) ������		1997�� 3��
SELECT EMP_NAME "������"
, TO_CHAR(HIRE_DATE, 'YYYY"�� "MM"��"') "�Ի���1"
, EXTRACT(YEAR FROM HIRE_DATE)||'�� '||EXTRACT(MONTH FROM HIRE_DATE)||'��' "�Ի���2"
FROM EMPLOYEE;
--6. ������� �ֹι�ȣ�� ��ȸ�Ͻÿ�
--	��, �ֹι�ȣ 9��° �ڸ����� �������� '*' ���ڷ� ä���� ��� �Ͻÿ�
--	ex) ȫ�浿 771120-1******
SELECT EMP_NAME
, SUBSTR(EMP_NO, 1, 8)||'******'
, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;


--7. ������, �����ڵ�, ����(��) ��ȸ
--  ��, ������ ��57,000,000 ���� ǥ�õǰ� ��
--     ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT 
    EMP_NAME "������"
    , JOB_CODE "�����ڵ�"
    , TO_CHAR(SALARY*12+SALARY*NVL(BONUS,0), 'L999,999,999') "����(��)"
FROM EMPLOYEE;
--8. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� �����߿� ��ȸ��.
--   ��� ����� �μ��ڵ� �Ի���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND TO_CHAR(HIRE_DATE, 'YYYY') = 2004;
SELECT TO_CHAR(HIRE_DATE, 'YYYY'), EXTRACT(YEAR FROM HIRE_DATE) FROM EMPLOYEE;
--9. ������, �Ի���, ���ñ����� �ٹ��ϼ� ��ȸ 
--	* �ָ��� ���� , �Ҽ��� �Ʒ��� ����
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE-HIRE_DATE)
FROM EMPLOYEE;
--10. ������, �μ��ڵ�, �������, ����(��) ��ȸ
--   ��, ��������� �ֹι�ȣ���� �����ؼ�, 
--   ���������� ������ �����Ϸ� ��µǰ� ��.
--   ���̴� �ֹι�ȣ���� �����ؼ� ��¥�����ͷ� ��ȯ�� ����, �����
SELECT EMP_NAME, DEPT_CODE
, 1900+SUBSTR(EMP_NO,1,2)||'��'
||SUBSTR(EMP_NO,3,2)||'��'
||SUBSTR(EMP_NO,5,2)||'��' "�������"
, EXTRACT(YEAR FROM SYSDATE)-(1900+SUBSTR(EMP_NO,1,2)) "����(��)"
FROM EMPLOYEE;
--11. ������, �μ����� ����ϼ���.
--   �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.(case ���)
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ�ϰ�, �μ��ڵ� �������� �������� ������.








SELECT TO_CHAR(TO_DATE('98','RRRR'),'YYYY') TEST1,
TO_CHAR(TO_DATE('05','RRRR'),'YYYY') TEST2,
TO_CHAR(TO_DATE('98','YYYY'),'YYYY') TEST3,
TO_CHAR(TO_DATE('05','YYYY'),'YYYY') TEST4 FROM DUAL;

SELECT TO_DATE('98','RRRR') TEST1,
TO_DATE('05','RRRR') TEST2,
TO_DATE('98','YYYY') TEST3,
TO_DATE('05','YYYY') TEST4 FROM DUAL;



