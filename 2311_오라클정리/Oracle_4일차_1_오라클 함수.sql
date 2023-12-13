-- ����Ŭ 4���� (�Լ� ���� �ǽ� 7������)

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
SELECT 
    EMP_NAME
    , DECODE(DEPT_CODE, 'D5', '�ѹ���', 'D6', '��ȹ��', 'D9', '������') "�μ���"    
    , CASE
        WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
        WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
        WHEN DEPT_CODE = 'D9' THEN '������'
      END "�μ���(case)"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9') ORDER BY DEPT_CODE;



-- * ��Ÿ �Լ�
-- 1. DECODE(IF��)
SELECT SUBSTR(EMP_NO,8,1) FROM EMPLOYEE;
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��','3','��','4','��','����') "����" FROM EMPLOYEE;
-- 2. CASE(SWITCH��)
SELECT 
    CASE
        WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '��'
        WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '��'
        WHEN SUBSTR(EMP_NO,8,1) = '3' THEN '��'
        WHEN SUBSTR(EMP_NO,8,1) = '4' THEN '��'
        ELSE '����'
    END "����"
FROM EMPLOYEE;

-- �׷��Լ� : Ư���� ����� �������� �׷��� �����Ǿ� �����,
-- �׷�� 1���� ����� ��ȯ, ��� �� 1�ุ ����.
SELECT TO_CHAR(SALARY, 'L999,999,999') FROM EMPLOYEE;
SELECT SUM(SALARY) FROM EMPLOYEE;
SELECT AVG(SALARY) FROM EMPLOYEE;
SELECT COUNT(SALARY) FROM EMPLOYEE;
SELECT MAX(SALARY) FROM EMPLOYEE;
SELECT MIN(SALARY) FROM EMPLOYEE;
-- GROUP BY��
-- ������ �׷��������� ����� �׷��Լ��� �� �Ѱ��� ������� ������.
-- �׷��Լ��� �̿��Ͽ� �������� ������� �����ϱ� ���ؼ��� �׷��Լ��� �����
-- �׷��� ������ GROUP BY ���� ����Ͽ� ����ϸ� ��.
-- ��� ����� ������ ���� ���Ͻÿ�.
-- �μ��� ����� ������ ���� ���Ͻÿ�.
SELECT SUM(SALARY), DEPT_CODE FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- ���޺� ������ ������ ���� ���Ͻÿ�.
SELECT SUM(SALARY), JOB_CODE FROM EMPLOYEE
GROUP BY JOB_CODE;
-- �ǽ�����1
-- EMPLOYEE ���̺��� �μ��ڵ� �׷캰 �޿��� �հ�, �׷캰 �޿��� ���(����ó��), �ο����� ��ȸ�ϰ�
-- �μ��ڵ� ������ �����Ͻÿ�.
SELECT SUM(SALARY), FLOOR(AVG(SALARY)), COUNT(*), DEPT_CODE 
FROM EMPLOYEE 
GROUP BY DEPT_CODE 
ORDER BY DEPT_CODE;
-- �ǽ�����2
-- EMPLOYEE ���̺��� �μ��ڵ� �׷캰, ���ʽ��� ���޹޴� ��� ���� ��ȸ�ϰ� �μ��ڵ� ������ �����Ͻÿ�.
-- BONUSĮ���� ���� �����Ѵٸ� �� ���� 1�� ī����, ���ʽ��� ���޹޴� ����� ���� �μ��� ����.
SELECT COUNT(*), DEPT_CODE
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;
SELECT EMP_NAME, BONUS FROM EMPLOYEE WHERE DEPT_CODE = 'D1';

-- �ǽ�����3
-- EMPLOYEE ���̺��� ������ J1�� ������� �����ϰ� ���޺� ����� �� ��ձ޿��� ����ϼ���.
SELECT COUNT(*), FLOOR(AVG(SALARY)), JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE != 'J1'
GROUP BY JOB_CODE
ORDER BY JOB_CODE;
-- �ǽ�����4
-- EMPLOYEE ���̺��� ������ J1�� ������� �����ϰ� �Ի�⵵�� �ο����� ��ȸ�ؼ�,
-- �Ի�⵵ �������� ������������ �����ϼ���.
SELECT * FROM EMPLOYEE;
SELECT COUNT(HIRE_DATE), EXTRACT(YEAR FROM HIRE_DATE) "�Ի�⵵"
FROM EMPLOYEE
WHERE JOB_CODE <> 'J1'
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY EXTRACT(YEAR FROM HIRE_DATE);
-- �ǽ�����5
-- EMPLOYEE ���̺��� EMP_NO�� 8��° �ڸ��� 1, 3�̸� '��', 2, 4�̸� '��'�� ����� ��ȸ�ϰ�,
-- ������ �޿��� ���(����ó��), �޿��� �հ�, �ο����� ��ȸ�� �� �ο����� ���������� �����Ͻÿ�.
SELECT FLOOR(AVG(SALARY)), SUM(SALARY), COUNT(*)
, DECODE(SUBSTR(EMP_NO, 8, 1), '1','��', '2', '��', '3','��','4','��') "����"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1','��', '2', '��', '3','��','4','��')
ORDER BY 1 DESC;

-- �ǽ�����6
-- �μ��� ���޺� �޿��� �հ踦 ���Ͻÿ�
SELECT SUM(SALARY), DEPT_CODE, JOB_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;
-- �ǽ�����7
-- �μ��� ���� �ο����� ���Ͻÿ�
SELECT COUNT(*), DEPT_CODE, DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��')
FROM EMPLOYEE
GROUP BY DEPT_CODE, DECODE(SUBSTR(EMP_NO,8,1),'1','��','2','��')
ORDER BY DEPT_CODE;

-- HAVING��
-- SELECT * FROM EMPLOYEE WHERE ~(����)
-- SELECT SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE HAVING (����)
-- �׷��Լ��� ���� ���ؿ� �׷쿡 ���� ������ ������ �� �����.
-- WHERE ���� �����ؼ� ����� �� �˾ƾ� ��.
-- �μ��� �ο����� ���غ�����
-- �μ��� �޿��� ���� ���غ�����
SELECT COUNT(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- �ǽ�����1, �μ��� �ο��� 5���� ���� �μ��� ����Ͻÿ�.
SELECT COUNT(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE HAVING COUNT(*) > 5;
-- �ǽ�����2
-- �μ��� ���޺� �ο����� 3���̻��� �μ��ڵ�, �����ڵ�, �ο����� ����غ�����.
SELECT COUNT(*), DEPT_CODE, JOB_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(*) > 2
ORDER BY 2 ASC;
-- �ǽ�����3
-- �Ŵ����� �����ϴ� ����� 2�� �̻��� �Ŵ��� ���̵�� �����ϴ� ������� ����ϼ���!
SELECT COUNT(*), MANAGER_ID
FROM EMPLOYEE
GROUP BY MANAGER_ID
HAVING COUNT(*) >= 2 AND MANAGER_ID IS NOT NULL;

-- ���޺� �޿� �հ�
SELECT SUM(SALARY), JOB_CODE
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE);
-- �μ��� �޿� �հ踦 ROLLUP���� ����غ�����!
SELECT SUM(SALARY), DEPT_CODE, JOB_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE IS NOT NULL
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
HAVING DEPT_CODE IS NOT NULL;
-- �μ��� �޿� �հ踦 CUBE�� ������ּ���.
SELECT SUM(SALARY), DEPT_CODE, JOB_CODE
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE); -- ROLLUP���� ��µǴ� ����� ����.
-- �� ���� �κ��� ���޺� �հ踦 �߰��ؼ� �������

-- ���� ������(SET OPERATION)
-- UNION, UNION ALL
-- ���� 1. �÷��� ������ ���� ��. 2. �÷��� Ÿ���� ���� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE SALARY > 3000000;

-- INTERSECT(������, ��������)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE SALARY > 3000000;

-- MINUS(������)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE WHERE SALARY > 3000000;

-- ROLLUP����� UNION ���
SELECT SUM(SALARY), DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
UNION
SELECT SUM(SALARY), NULL
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT * FROM DEPARTMENT;

