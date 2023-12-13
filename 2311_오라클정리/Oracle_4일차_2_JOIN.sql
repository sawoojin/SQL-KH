-- ����Ŭ4���� JOIN
-- JOIN
-- �� �� �̻��� ���̺��� �������� ������ �ִ� �����͵���
-- ���� �з��Ͽ� ���ο� ������ ���̺��� ����
-- -> ���� ���̺��� ���ڵ带 �����Ͽ� �ϳ��� ���ڵ�� ����
-- ANSI ǥ�� ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- ����Ŭ ���� ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID;

-- @�ǽ�����1
-- �μ���� �������� ����ϼ���.(DEPARTMENT, LOCATION ���̺� �̿�)
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
DESC DEPARTMENT;

--11. ������, �μ����� ����ϼ���.
--   �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.(case ���)
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ�ϰ�, �μ��ڵ� �������� �������� ������.
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- @�ǽ�����2
-- ������ ���޸��� ����ϼ���!
SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE E
-- �÷����� ���� �� ��Ī���� ���̺�� ���̱�
--JOIN JOB J ON E.JOB_CODE = J.JOB_CODE; 
-- �÷����� ������ USING Ű���� ��� ����
JOIN JOB J USING(JOB_CODE); 

-- @�ǽ�����3
-- ������� �������� ����ϼ���~~
SELECT LOCAL_NAME, NATIONAL_NAME
FROM LOCATION L
--JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;
JOIN NATIONAL N USING(NATIONAL_CODE);

-- KH���� ���̺�ȿ��� JOIN�� ���̺�
-- 1. EMPLOYEE AND DEPARTMENT(�μ���)
-- 2. EMPLOYEE AND JOB(���޸�)
-- 3. DEPARTMENT AND LOCATION(������)
-- 4. LOCATION AND NATIONAL(������)

-- ========== JOIN�� ���� ===================
-- 1. INNER JOIN : ������, �Ϲ������� ����ϴ� ����
-- 2. OUTER JOIN : ������, ��� ����ϴ� ����
-- 1. ������ �μ����� ����Ͻÿ�.
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- �̷��� ���������� ��µ�.
-- ���������� ��µǵ��� OUTER ���� ���
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- LEFT OUTER JOIN�� ���� ���̺��� ������ �ִ� ��� �����͸� ���(�ϵ���,�̿���)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- RIGHT OUTER JOIN�� ������ ���̺��� ������ �ִ� ��� �����͸� ���(������, ��������, �ؿܿ���3��)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- FULL OUTER JOIN�� ��� ���̺��� ������ �ִ� ��� �����͸� ����ϴ� ����
-- ����Ŭ ���� ����, JOIN ����غ���
-- 1. INNER JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID;
-- 2. LEFT OUTER JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID(+);
-- 3. RIGHT OUTER JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE(+) = DEPT_ID;
-- 4. FULL OUTER JOIN
-- �������� ����

-- @JOIN ���սǽ�
--1. �ֹι�ȣ�� 1970��� ���̸鼭 ������ �����̰�, 
-- ���� ������ �������� �����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE (SUBSTR(EMP_NO,1,2) BETWEEN 70 AND 79) AND SUBSTR(EMP_NO,8,1) IN ('2', '4')
AND EMP_NAME LIKE '��%';
--2. �̸��� '��'�ڰ� ���� �������� ���, �����, �μ����� ��ȸ�Ͻÿ�.
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '%��%';
--3. �ؿܿ����ο� �ٹ��ϴ� �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE LIKE '�ؿܿ���_��';
--4. ���ʽ�����Ʈ�� �޴� �������� �����, ���ʽ�����Ʈ, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
SELECT EMP_NAME "�����", BONUS "���ʽ�����Ʈ"
, DEPT_TITLE "�μ���", LOCAL_NAME "�ٹ�������"
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
LEFT OUTER JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL;
--5. �μ��ڵ尡 D2�� �������� �����, ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE DEPT_CODE = 'D2';
--6. �޿�������̺��� �ִ�޿�(MAX_SAL)���� ���� �޴� �������� �����, ���޸�, �޿�, ������ ��ȸ�Ͻÿ�.
-- (������̺�� �޿�������̺��� SAL_LEVEL�÷��������� ������ ��)
-- ������ ����!
SELECT EMP_NAME, JOB_NAME, SALARY, SALARY*12
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE SALARY > MAX_SAL;
--7. �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� �����, �μ���, ������, �������� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_CODE IN ('KO', 'JP');
--8. ���ʽ�����Ʈ�� ���� ������ �߿��� ������ ����� ����� �������� �����, ���޸�, �޿��� ��ȸ�Ͻÿ�. 
--��, join�� IN ����� ��
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL AND JOB_CODE IN ('J4','J7');
SELECT * FROM JOB;
--9. �������� ������ ����� ������ ���� ��ȸ�Ͻÿ�.
SELECT DECODE(ENT_YN, 'N', '����', '����') "��������", COUNT(*) "��"
FROM EMPLOYEE
GROUP BY ENT_YN;





