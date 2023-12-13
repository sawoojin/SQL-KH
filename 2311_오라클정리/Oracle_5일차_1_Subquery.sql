-- ����Ŭ 5���� ��������
-- ================== ��������(SubQuery) ==========================
-- �ϳ��� SQL�� �ȿ� ���ԵǾ� �ִ� �� �ٸ� SQL��
-- ���� ������ ���� ������ �����ϴ� �������� ����
-- ���������� �ݵ�� �Ұ�ȣ�� ����� ��
-- �������� �ȿ� ORDER BY�� ���� �ȵ�!

-- ������ ������ ������ �̸��� ����ϼ���.
SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME LIKE '������';
SELECT EMP_NAME FROM EMPLOYEE 
WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME LIKE '������');
--WHERE EMP_ID = '214';
-- �� ������ ��� �޿����� ���� �޿��� �ް� �ִ� ������ ���, �̸�, �����ڵ�, �޿��� ����ϼ���.
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE;
-- 3047662
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE);
--WHERE SALARY > 3047662;

-- ================== ���������� ���� =========================
-- 1. ������ ��������
-- 2. ������ ��������
-- 3. ���߿� ��������
-- 4. ������ ���߿� ��������
-- 5. ��(ȣ��)�� ��������
-- 6. ��Į�� ��������
-- ==================== 2. ������ �������� ===========================
-- �����⳪ �ڳ��� ���� �μ��� ���� �������� ��ü ������ ����ϼ���.
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '������')
UNION
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '�ڳ���');

SELECT * FROM EMPLOYEE 
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('������', '�ڳ���'));

-- @�ǽ�����1
-- ���¿�, ������ ����� �޿���ް� ���� ����� ���޸�, ������� ����ϼ���.
-- 1. ���¿�, �������� �޿������ ����
-- 2. ���� �޿������ �������� �̿��Ͽ� ���޸�, ������� ����Ѵ�.
-- 3. ���޸��� EMPLOYEE ���̺� �����Ƿ� JOB���̺�� �����Ͽ� �����;���.
SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('���¿�', '������');
SELECT JOB_NAME, EMP_NAME 
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('���¿�', '������'));

-- @�ǽ�����2
-- 2.Asia1������ �ٹ��ϴ� ������ ����(�μ��ڵ�, �����)�� ����ϼ���.
-- 1. Asia1������ �ٹ��ϴ� �μ��� �ڵ带 ���ϱ�
-- 2. �μ��ڵ带 �̿��ؼ� ������ ���� ���ϱ�
SELECT DEPT_CODE, EMP_NAME FROM EMPLOYEE 
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1');

SELECT DEPT_ID FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1';

-- ========================= 5. ��(ȣ��)�� �������� ===============================
-- ���������� ���� ���������� �ְ� ���������� ������ ���� �� ����� �ٽ� ���������� ��ȯ�ؼ� ����
-- ��ȣ���� ���踦 ������ �����ϴ� ����
-- > ���������� WHERE�� ������ ���ؼ� ���������� ���� ����Ǵ� ����
-- > ���� ���� ���̺��� ���ڵ忡 ���� ���������� ������� �ٲ�.

-- ���������� �Ѹ��̶� �ִ� ������ ������ ����Ͻÿ�.
SELECT * FROM EMPLOYEE WHERE 1 = 1;
-- EMP_ID�� MANAGER_ID�� ��ȸ���� �� �����ϸ� �ش� ���� ����ϵ��� �Ϸ���?
SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
-- @�ǽ�����1
-- ���� ���� �޿��� �޴� ������ ����Ͻÿ�.
-- ������ �������� ���
SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
-- @�ǽ�����2
-- ���� ���� �޿��� �޴� ������ ����Ͻÿ�.
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);
-- @�ǽ�����3
-- �ɺ����� ���� �μ��� ����� �μ��ڵ�, �����, ����ձ޿��� ��ȸ�Ͻÿ�.
SELECT DEPT_CODE, EMP_NAME, (SELECT FLOOR(AVG(SALARY))FROM EMPLOYEE)
FROM EMPLOYEE E 
WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE 
AND EMP_NAME = '�ɺ���');
-- @�ǽ�����4
-- ������ J1, J2, J3�� �ƴ� ����߿��� �ڽ��� �μ��� ��ձ޿����� ���� �޿��� �޴�
-- ������ �μ��ڵ�, �����, �޿�, (�μ��� �޿����) ������ ����Ͻÿ�.
SELECT DEPT_CODE, EMP_NAME, SALARY
, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "�μ��� �޿����"
FROM EMPLOYEE E
WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') 
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);

SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D5';

-- =================== 6. ��Į�� �������� =============================
-- ������� 1���� �����������, SELECT�� �ڿ� ����.
-- SQL���� ���ϰ��� ��Į���̶�� ��.
-- ����1. ��� ����� ���, �̸�, �����ڻ��, �����ڸ��� ��ȸ�ϼ���!
SELECT EMP_ID, EMP_NAME, MANAGER_ID
, (SELECT EMP_NAME FROM EMPLOYEE M WHERE M.EMP_ID = E.MANAGER_ID) "�����ڸ�" 
FROM EMPLOYEE E;
-- @�ǽ�����1
-- �����, �μ���, �μ��� ����ӱ�(�ڽ��� ���� �μ��� ����ӱ�)�� ��Į�� ���������� �̿��ؼ�
-- ����ϼ���.
SELECT EMP_NAME, DEPT_TITLE
, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "�μ��� ����ӱ�"
FROM EMPLOYEE E
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- Ȯ�ο�
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE 
WHERE DEPT_CODE = (SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE = '�ѹ���');
-- @�ǽ�����2
-- ������ J1�� �ƴ� ��� �߿��� �ڽ��� �μ� ��ձ޿����� ���� �޿��� �޴� �������Ͻÿ�
-- �μ��ڵ�, �����, �޿�, �μ��� �޿������ ����Ͻÿ�.
SELECT DEPT_CODE, EMP_NAME, SALARY
FROM EMPLOYEE E
WHERE JOB_CODE != 'J1' 
AND SALARY < (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);
-- @�ǽ�����3
-- �ڽ��� ���� ������ ��ձ޿����� ���� �޴� ������ �̸�, ����, �޿��� ����Ͻÿ�.
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE = E.JOB_CODE);

SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE = 'J4';
-- @�ǽ�����4
-- ��� ������ ���, �̸�, �ҼӺμ��� ��ȸ�� �� �μ����� ������������ �����Ͻÿ�.
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
ORDER BY 3 ASC;

SELECT EMP_ID, EMP_NAME
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE)  "�μ���"
FROM EMPLOYEE E
ORDER BY 3 ASC;

