-- ����Ŭ 3����(1.5��)
-- DQL �ǽ�
-- �ǽ�����
-- SELECT EMP_NAME FROM EMPLOYEE
-- SELECT FROM DEPARTMENT
--1. EMPLOYEE ���̺��� �̸� ���� ������ ������ ����� �̸��� ����Ͻÿ�
SELECT EMP_NAME 
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��';
--2. EMPLOYEE ���̺��� ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ����� �̸�, ��ȭ��ȣ��
--����Ͻÿ�
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--3. EMPLOYEE ���̺��� �����ּ��� 's'�� ���鼭, DEPT_CODE�� D9 �Ǵ� D6�̰�
--������� 90/01/01 ~ 01/12/01�̸鼭, ������ 270�����̻��� ����� ��ü ������ ����Ͻÿ�
SELECT *
FROM EMPLOYEE
--WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6') AND SALARY >= 2700000
WHERE DEPT_CODE IN ('D9','D6') AND SALARY >= 2700000
--AND EMAIL LIKE '%s%' AND (HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/12/01');
AND EMAIL LIKE '%s%' AND (HIRE_DATE BETWEEN '90/01/01' AND '01/12/01');
--4. EMPLOYEE ���̺��� EMAIL ID �� @ ���ڸ��� 5�ڸ��� ������ ��ȸ�Ѵٸ�?
-- ���ϵ�ī�� : %(0���̻�), _(�ڸ���, 1���̻�)
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '_____@%';
--5. EMPLOYEE ���̺��� EMAIL ID �� '_' ���ڸ��� 3�ڸ��� ������ ��ȸ�Ѵٸ�?
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '___\_%' ESCAPE '\';
-- 6. ������(MANAGER_ID)�� ���� �μ� ��ġ(DEPT_CODE)�� ���� ����  ������ �̸� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;
-- 7. �μ���ġ�� ���� �ʾ����� ���ʽ��� �����ϴ� ���� ��ü ���� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;
--8. EMPLOYEE ���̺��� �̸�,����, �Ѽ��ɾ�(���ʽ�����), 
-- �Ǽ��ɾ�(�� ���ɾ�-(����*���� 3%*12))
--�� ��µǵ��� �Ͻÿ�
SELECT
    EMP_NAME, -- �̸�
    SALARY*12||'��' AS "����", -- ����
    --'��' AS "����1",
    SALARY*12+SALARY*NVL(BONUS, 0)||'��' AS "�Ѽ��ɾ�", -- �Ѽ��ɾ�(���ʽ�����)
    --'��' AS "����2",
    SALARY*12+SALARY*NVL(BONUS, 0) - (SALARY*0.03*12) AS "�Ǽ��ɾ�",
    '��' AS "����3"
FROM EMPLOYEE;
--9. EMPLOYEE ���̺��� �̸�, �ٹ� �ϼ��� ����غ��ÿ� 
--(SYSDATE�� ����ϸ� ���� �ð� ���)
-- Math ���밪, �ø�, �ݿø�, ����, ...
SELECT EMP_NAME, FLOOR(SYSDATE - HIRE_DATE) AS "�ٹ��ϼ�"
FROM EMPLOYEE;

SELECT SYSDATE, SYSTIMESTAMP
FROM DUAL;
--10. EMPLOYEE ���̺��� 20�� �̻� �ټ����� �̸�,����,���ʽ����� ����Ͻÿ�.
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE FLOOR((SYSDATE-HIRE_DATE)/365) >= 20;

-- ���� �ǽ� ����
-- ����1. 
-- �Ի����� 5�� �̻�, 10�� ������ ������ �̸�,�ֹι�ȣ,�޿�,�Ի����� �˻��Ͽ���
SELECT EMP_NAME "�̸�", EMP_NO AS �ֹι�ȣ, SALARY AS "�޿�", HIRE_DATE "�Ի���"
FROM EMPLOYEE
WHERE FLOOR((SYSDATE-HIRE_DATE)/365) BETWEEN 5 AND 10;
-- ����2.
-- �������� �ƴ� ������ �̸�,�μ��ڵ�, �����, �ٹ��Ⱓ, �������� �˻��Ͽ��� 
--(��� ���� : ENT_YN)
SELECT EMP_NAME "�̸�", DEPT_CODE "�μ��ڵ�", HIRE_DATE "�����"
, (ENT_DATE-HIRE_DATE)||'��' "�ٹ��Ⱓ", ENT_DATE "������"
FROM EMPLOYEE
WHERE ENT_YN = 'Y';
-- ����3.
-- �ټӳ���� 10�� �̻��� �������� �˻��Ͽ�
-- ��� ����� �̸�,�޿�,�ټӳ��(�Ҽ���X)�� �ټӳ���� ������������ �����Ͽ� ����϶�
-- ��, �޿��� 50% �λ�� �޿��� ��µǵ��� �Ͽ���.
SELECT EMP_NAME "�̸�", SALARY*1.5 "�޿�", FLOOR((SYSDATE-HIRE_DATE)/365) "�ټӳ��"
FROM EMPLOYEE
WHERE FLOOR((SYSDATE-HIRE_DATE)/365) >= 10
--ORDER BY �ټӳ��;
ORDER BY 3;
-- SELECT �������
-- FROM - WHERE - SELECT - ORDER BY
-- ORDER BY ����
-- ��������
-- 1,2,3,4,5,6,7,8,9,10 / abcde.... / �������� / NULL����
-- ��������
-- 10,9,8,7,6,5,4,3,2,1 / zyxw.... / �ֽź��� / NULL����
SELECT * FROM EMPLOYEE ORDER BY HIRE_DATE DESC;

-- ����4.
-- �Ի����� 99/01/01 ~ 10/01/01 �� ��� �߿��� �޿��� 2000000 �� ������ �����
-- �̸�,�ֹι�ȣ,�̸���,����ȣ,�޿��� �˻� �Ͻÿ�
SELECT EMP_NAME, EMP_NO, EMAIL, PHONE, SALARY
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '99/01/01' AND '10/01/01'
AND SALARY <= 2000000;

-- ����5.
-- �޿��� 2000000�� ~ 3000000�� �� ������ �߿��� 4�� �����ڸ� �˻��Ͽ� 
-- �̸�,�ֹι�ȣ,�޿�,�μ��ڵ带 �ֹι�ȣ ������(��������) ����Ͽ���
-- ��, �μ��ڵ尡 null�� ����� �μ��ڵ尡 '����' ���� ��� �Ͽ���.
SELECT EMP_NAME, EMP_NO, SALARY, NVL(DEPT_CODE,'����') "DEPT_CODE"
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 3000000 AND EMP_NO LIKE '__04__-2%';

-- ����6.
-- ���� ��� �� ���ʽ��� ���� ����� ���ñ��� �ٹ����� �����Ͽ� 
-- 1000�� ����(�Ҽ��� ����) 
-- �޿��� 10% ���ʽ��� ����Ͽ� �̸�,Ư�� ���ʽ� (��� �ݾ�) ����� ����Ͽ���.
-- ��, �̸� ������ ���� ���� �����Ͽ� ����Ͽ���.
-- 2000�� �ټ�, 2500000 -> 500000
SELECT EMP_NAME, FLOOR(FLOOR(SYSDATE - HIRE_DATE)/1000)*SALARY*0.1 "Ư�����ʽ�"
FROM EMPLOYEE
WHERE EMP_NO LIKE '%-1%' AND BONUS IS NULL;


