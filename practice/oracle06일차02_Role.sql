-- ����Ŭ 6���� ����Ŭ ��ü Role
-- ====================== 3. ROLE
-- �����ڰ���
-- ����ڿ��� ���� ���� ������ �ѹ��� �ο��� �� �ִ� �����ͺ��̽� ��ü
-- ����ڿ��� ������ �ο��� �� �� ���� �ο��ϰ� �Ǹ� ���� �ο� �� ȸ���� ������.
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER KH IDENTIFIED BY KH;
GRANT CONNECT, RESOURCE TO KH;
CREATE ROLE VIEWRESOURCE;
-- DROP ROLE VIEWRESOURCE;

-- DCL(Data Control Language) : GRANT / REVOKE
-- ���Ѻο� �� ȸ���� ������ ��������
-- ������ ����
-- sys : DB����/ ���� ����, �α��� �ɼ����� as sysdba ����
-- system : �Ϲݰ�����
-- ROLE�� �ο��� �ý��� ����
SELECT * FROM DBA_SYS_PRIVS WHERE ROLE = 'CONNECT';
-- ���̺� ����
SELECT * FROM ROLE_TAB_PRIVS;
--
-- KHUSER02�� KH�� COFFEE ���̺��� ��ȸ�� �� �ִ� ����
GRANT SELECT ON KH.COFFEE TO KHUSER02;
GRANT INSERT ON KH.COFFEE TO KHUSER02;
-- ���� ȸ��
REVOKE SELECT ON KH.COFFEE FROM KHUSER02;
REVOKE INSERT ON KH.COFFEE FROM KHUSER02;