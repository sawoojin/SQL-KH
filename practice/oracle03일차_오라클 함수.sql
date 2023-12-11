-- ����Ŭ �Լ�
-- ������ �Լ� - ����� ������
-- ������ �Լ� - ����� 1��(�׷��Լ�)

-- ����Ŭ �Լ� ����2
--1. ���� ó�� �Լ�
-- a. LENGTH, LENGTHB
-- b. INSTR, INSTRB : ��ġ
-- c. LPAD/RPAD : ��ĭ ä���
-- d. LTRIM/RTRIM : ����(����)����
-- e. TRIM 
-- f. SUBSTR : ���ڿ� ������
-- g. CONCAT / ||
-- h. REPLACE 
--2. ���� ó�� �Լ�
-- ABS, FLOOR, CEIL, 1/ MOD, ROUND, TRUNC 2���ް� 
--3. ��¥ ó�� �Լ�
-- a. SYSDATE
SELECT SYSDATE FROM DUAL;
-- b. ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
-- c. MONTHS_BETWEEN()
SELECT MONTHS_BETWEEN('24/04/25', SYSDATE) FROM DUAL;
-- ex1) EMPLOYEE ���̺��� ����� �̸�, �Ի���, �Ի� �� 3������ �ȳ�¥�� ��ȸ�Ͻÿ�
SELECT EMP_NAME "�̸�", HIRE_DATE "�Ի���", ADD_MONTHS(HIRE_DATE, 3) "�Ի��� 3����" FROM EMPLOYEE;
-- ex2) EMPLOYEE ���̺��� ����� �̸�, �Ի���, �ٹ� �������� ��ȸ�Ͻÿ�
SELECT EMP_NAME "�̸�", HIRE_DATE "�Ի���", FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'����'  "�ٹ� ������" FROM EMPLOYEE;
-- d. LAST_DAY()
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('24/04/25') FROM DUAL;
-- ex) EMPLOYEE ���̺��� ����̸�, �Ի���, �Ի���� ���������� ��ȸ�ϼ���
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) FROM EMPLOYEE;
-- e. EXTRACT
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
-- ex) ����̸�, �Ի� �� �� ��
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE), EXTRACT(MONTH FROM HIRE_DATE),EXTRACT(DAY FROM HIRE_DATE) FROM EMPLOYEE;
-- ���Ӹ� ���� ���� �������� 1�� 6�����ϸ� 1, �������ڴ�? 2, ���� «��׸��� (1��3��)
SELECT ADD_MONTHS(SYSDATE, 18) "����", (ADD_MONTHS(SYSDATE, 18)-SYSDATE)*3 "«��" FROM DUAL;
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEE;
--4. NULL ó�� �Լ�
SELECT SALARY*NVL(BONUS,0) FROM EMPLOYEE;
--5. DECODE / CASE �Լ�
SELECT * FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '00/01/01' AND '10/01/01';
-- @�Լ� �����ǽ�����
--1. ������� �̸��� , �̸��� ���̸� ����Ͻÿ�
SELECT EMP_NAME "�̸�", EMAIL "�̸���", LENGTH(EMAIL) "�̸��ϱ���" FROM EMPLOYEE;
--2. ������ �̸��� �̸��� �ּ��� ���̵� �κи� ����Ͻÿ�
SELECT EMP_NAME "�̸�", SUBSTR(EMAIL, 1, INSTR(EMAIL,'@',1,1)-1) "�̸��� ���̵�" FROM EMPLOYEE;
--3. 60��뿡 �¾ ������� ���, ���ʽ� ���� ����Ͻÿ�. �׶� ���ʽ� ���� null�� ��쿡�� 0 �̶�� ��� �ǰ� ����ÿ�
SELECT EMP_NAME "������", 19||SUBSTR(EMP_NO, 1,2) "���", NVL(BONUS, 0) "���ʽ�" 
FROM EMPLOYEE WHERE SUBSTR(EMP_NO, 1,2) BETWEEN 60 AND 69;
--4. '010' �ڵ��� ��ȣ�� ���� �ʴ� ����� ��ü ������ ����Ͻÿ�.
SELECT * FROM EMPLOYEE WHERE NOT SUBSTR(PHONE,1,3) = 010;
--5. ������� �Ի����� ����Ͻÿ� 
SELECT EMP_NAME "������", EXTRACT(YEAR FROM HIRE_DATE)||'�� '||EXTRACT(MONTH FROM HIRE_DATE)||'��' "�Ի���" FROM EMPLOYEE;
--6. ������� �ֹι�ȣ�� ��ȸ�Ͻÿ�
SELECT EMP_NAME "������", SUBSTR(EMP_NO,1,8)||'******' "�ֹι�ȣ" FROM EMPLOYEE;