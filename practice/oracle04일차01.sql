-- ����Ŭ 4����

--7. ������, �����ڵ�, ����(��) ��ȸ
SELECT EMP_NAME "������", JOB_CODE "�����ڵ�", TO_CHAR((SALARY*12)*NVL(BONUS, 1), +'L999,999,999') "����(��)" FROM EMPLOYEE;
--8. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� �����߿� ��ȸ��.
SELECT EMP_ID "���", EMP_NAME "�����", DEPT_CODE "�μ��ڵ�", HIRE_DATE "�Ի���" FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;
--9. ������, �Ի���, ���ñ����� �ٹ��ϼ� ��ȸ 
SELECT EMP_NAME "������", HIRE_DATE "�Ի���", ROUND(SYSDATE - HIRE_DATE)||'��' "�ٹ��ϼ�" FROM EMPLOYEE;
--10. ������, �μ��ڵ�, �������, ����(��) ��ȸ
--	* �ֹι�ȣ�� �̻��� ������� ���ܽ�Ű�� ���� �ϵ���(200,201,214 �� ����)
--	* HINT : NOT IN ���
SELECT EMP_NAME "������", DEPT_CODE "�μ��ڵ�", TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)),'YYYY"�� "MM"�� "DD"��"') "�������",
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,6)))||'��' "����(��)" FROM EMPLOYEE;
--11. ������, �μ����� ����ϼ���.
SELECT EMP_NAME "�����", CASE WHEN DEPT_CODE = 'D5' THEN '�ѹ���' WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
WHEN DEPT_CODE = 'D9' THEN '������' END "�μ���" FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9') ORDER BY DEPT_CODE ASC;

--* ��Ÿ�Լ�
-- 1. DECODE(IF��)
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��','3','��','4','��','����') "����" FROM EMPLOYEE;
-- 2. CASE(SWITCH)��
SELECT CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '��'
WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '��' WHEN SUBSTR(EMP_NO,8,1) = '3' THEN '��' WHEN SUBSTR(EMP_NO,8,1) = '4' THEN '��'
ELSE '����' END "����" FROM EMPLOYEE;

-- �׷��Լ� : Ư���� ����� �������� �׷��� �����Ǿ� �����
-- �׷�� 1���� ����� ��ȯ, ��� �� 1�ุ ����.
SELECT TO_CHAR(SALARY,'L999,999,999') FROM EMPLOYEE;
SELECT SUM(SALARY) FROM EMPLOYEE;
SELECT AVG(SALARY) FROM EMPLOYEE;
SELECT COUNT(SALARY) FROM EMPLOYEE;
SELECT MAX(SALARY) FROM EMPLOYEE;
SELECT MIN(SALARY) FROM EMPLOYEE;
-- GROUP BY��
-- ������ �׷��������� ����� �׷��Լ��� �� �Ѱ��� ������� ����
-- �׷��Լ��� �̿� �������� ������� �����ϱ� ���ؼ��� �׷��Լ��� ����� �׷��� ������
-- GROUP BY ���� ����Ͽ� ����ϸ� ��.
-- ���/ �μ��� ����� ������ ���� ���Ͻÿ�
SELECT SUM(SALARY), DEPT_CODE FROM EMPLOYEE GROUP BY DEPT_CODE;
SELECT SUM(SALARY), JOB_CODE FROM EMPLOYEE GROUP BY JOB_CODE;
-- EX)1
-- EMPLOYEE ���̺��� �μ��ڵ� �׷캰 �޿��� �հ�, �׷캰 �޿��� ���(����ó��), �ο����� ��ȸ�ϰ�
-- �μ��ڵ� ������ �����Ͻÿ�
SELECT SUM(SALARY) "�޿��� �հ�",ROUND(AVG(SALARY)) "�޿��� ���",COUNT(SALARY) "�ο���",
DEPT_CODE "�μ��ڵ�" FROM EMPLOYEE GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;
-- EX)2
-- EMPLOYEE ���̺��� �μ��ڵ� �׷캰, ���ʽ��� ���޹޴� ��� ���� ��ȸ�ϰ� �μ��ڵ� ������ �����Ͻÿ�
-- BONUS Į���� ���� �����Ѵٸ� �� ���� 1�� ī����, ���ʽ��� ���޹޴� ����� ���� �μ��� �ִ�.
SELECT DEPT_CODE "�μ��ڵ�", COUNT(BONUS) "���ʽ� ����" FROM EMPLOYEE WHERE BONUS IS NOT NULL GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;
-- EX)3
-- EMPLOYEE ���̺��� ������ J1�� ������� �����ϰ� ���޺� ����� �� ��ձ޿��� ����ϼ���.
SELECT JOB_CODE "���޺�", COUNT(JOB_CODE) "���޺� ��� ��", ROUND(AVG(SALARY)) "��ձ޿�" FROM EMPLOYEE 
WHERE JOB_CODE != 'J1' GROUP BY JOB_CODE;
-- EX)4
-- EMPLOYEE ���̺��� ������ J1�� ������� �����ϰ� �Ի�⵵�� �ο����� ��ȸ�ؼ�
-- �Ի�⵵ �������� ������������ �����ϼ���
SELECT EXTRACT(YEAR FROM HIRE_DATE) "�Ի�⵵", COUNT(EXTRACT(YEAR FROM HIRE_DATE)) "�ο���" 
FROM EMPLOYEE WHERE JOB_CODE != 'J1' 
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY EXTRACT(YEAR FROM HIRE_DATE);
-- EX)5
-- EMPLOYEE ���̺��� EMP_NO 8��° �ڸ��� 1,3 �̸� ��, 2,4 �̸� �� �� ����� ��ȸ�ϰ�
-- ������ �޿��� ���(����), �޿��� �հ�, �ο����� ��ȸ�� �� �ο����� �������� ����
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��','3','��','4','��') "����",
ROUND(AVG(SALARY)) "�޿��� ���", SUM(SALARY) "�޿��� �հ�", COUNT(*) "�ο���" FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��','3','��','4','��');
-- EX)6
-- �μ��� ���޺� �޿��� �հ踦 ���Ͻÿ�
SELECT JOB_CODE "����", SUM(SALARY) "�޿��� ��" FROM EMPLOYEE
GROUP BY JOB_CODE;
-- EX)7
-- �μ��� ���� �ο����� ���Ͻÿ�
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��','3','��','4','��') "����",
COUNT(*) "�ο���" FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��','3','��','4','��');
-- HAVING��
-- SELECT * FROM EMPLOYEE WHERE ~(����)
-- SELECT SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE HAVING(����)
-- �׷��Լ��� ���� ���ؿ� �׷쿡 ���� ������ ������ �� �����
-- WHERE ���� �����ؼ� ����� �� �˾ƾ� ��
-- EX)1
SELECT COUNT(SALARY) FROM EMPLOYEE
GROUP BY DEPT_CODE HAVING COUNT(SALARY) > 5;
-- EX)2
-- �μ��� ���޺� �ο����� 3�� �̻��� �μ��ڵ�, �����ڵ�, �ο��� ���
SELECT DEPT_CODE, JOB_CODE, COUNT(*) FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE HAVING COUNT(*) > 2
ORDER BY 2 ASC;

-- EX)3
-- �Ŵ����� �����ϴ� ����� 2�� �̻��� �Ŵ��� ���̵�� �����ϴ� ������� ����ϼ���
SELECT MANAGER_ID, COUNT(*) FROM EMPLOYEE
GROUP BY ROLLUP(MANAGER_ID) HAVING COUNT(*) > 1;

SELECT SUM(SALARY), DEPT_CODE, JOB_CODE FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE); -- ROLLUP +���޺� �հ踦 �߰��ؼ� �˷���
-- ���� ������(SET OPERATION)
-- UNION ������, UNION ALL ������ +������
-- ���� 1. �÷��� ������ ���� �� 2. �÷��� Ÿ���� ���� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE SALARY > 3000000;
-- INTERSECT ������
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE SALARY > 3000000;
-- MINUS ������
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE SALARY > 3000000;