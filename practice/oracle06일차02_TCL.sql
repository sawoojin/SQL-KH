-- ����Ŭ 6���� TCL
-- ================= TCL(Transaction Control Language
-- ================= COMMIT, ROLLBACK, SAVEPOINT
-- ================= Ʈ����� ó�� ���
-- �Ѳ����� ����Ǿ�� �� �ּ��� �۾� ������ ����.
-- ATM ���, ������ü ���� Ʈ������� ��
-- 1. ī�� ����
-- 2. �޴� ����
-- 3. �ݾ� �Է�
-- 4. ��й�ȣ �Է�
-- 5. �ܱ� ���� / ��ݿϷ�
-- ORACLE DBMS Ʈ�����?
-- INSERT ����� Oracle�� Ʈ����� ó�� > �� �ڿ� �߰� �۾��� ���� ������ ó��
-- INSERT - INSERT - INSERT - ... -COMMIT(Ʈ����� �Ϸ�) / - ROLLBACK(Ʈ����� �Ϸ� - ���󺹱�)
-- ================= TCL ��ɾ�
-- COMMIT : Ʈ����� �۾��� ���� �Ϸ�Ǿ� ���� ������ ������ ���� (��� savepoint ����)
-- ROLLBACK : Ʈ����� �۾��� ��� ����ϰ� ���� �ֱ� COMMIT �������� �̵�.
-- SAVEPOINT [�̸�] : ���� Ʈ����� �۾� ������ �̸��� �ο��� �ӽ�����
-- �ϳ��� Ʈ����ǿ��� ������ ���� �� ����
CREATE TABLE USER_TCL
(
    USER_NO NUMBER UNIQUE,
    USER_NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(30) PRIMARY KEY
);
INSERT INTO USER_TCL VALUES(1, '�Ͽ���', 'khuser01');
SELECT * FROM USER_TCL;
COMMIT;
INSERT INTO USER_TCL VALUES(2, '�̿���', 'khuser02');
ROLLBACK;
INSERT INTO USER_TCL VALUES(3, '3����', 'khuser03');
SAVEPOINT UNTIL3;
INSERT INTO USER_TCL VALUES(4, '4����', 'khuser04');
-- ROLLBACK TO SAVEPOINT�̸�;
ROLLBACK TO UNTIL3;
SELECT * FROM USER_TCL;