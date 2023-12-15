-- ����Ŭ 6���� TCL
-- =================== TCL(Transaction Control Language) ========================
-- =================== COMMIT, ROLLBACK, SAVEPOINT       ========================
-- =================== Ʈ����� ó�� ���                 ========================
-- Ʈ�����(Transaction)�̶�?
-- �Ѳ����� ����Ǿ�� �� �ּ��� �۾� ������ ����.
-- ATM ���, ������ü ���� Ʈ������� ��
-- 1. ī�� ����
-- 2. �޴� ����
-- 3. �ݾ� �Է�
-- 4. ��й�ȣ �Է�
-- 5. ��� �Ϸ� (�ܱ� ����)

-- ORACLE DBMS Ʈ�����?
-- INSERT ����� Oracle�� Ʈ����� ó�� -> �� �ڿ� �߰� �۾��� ���������� ó����
-- INSERT - INSERT - INSERT - ... - COMMIT(Ʈ����� �Ϸ�, ���� ����)
-- INSERT - DELETE - UPDATE - INSERT - ... - ROLLBACK;(Ʈ����� �Ϸ�, ����)

-- ========================== TCL ��ɾ� ===============================
-- 1. COMMIT : Ʈ����� �۾��� ���� �Ϸ�Ǿ� ���� ������ ������ ����(��� savepoint ����)
-- 2. ROLLBACK : Ʈ����� �۾��� ��� ����ϰ� ���� �ֱ� COMMIT �������� �̵�.
-- 3. SAVEPOINT <savepoint��> : ���� Ʈ����� �۾� ������ �̸��� ������. �ӽ�����
-- �ϳ��� Ʈ����ǿ��� ������ ���� �� ����.

CREATE TABLE USER_TCL 
(
    USER_NO NUMBER UNIQUE,
    USER_NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(30) PRIMARY KEY
);
-- INSERT �Ͽ���
-- COMMIT > Ʈ����� �Ϸ�, ���� ����, ROLLBACK �ϸ� �� �������� �̵�
-- INSERT �̿���
-- ROLLBACK �ϸ� ���� �����? > �Ͽ��ڷ� ��
-- INSERT �̿���
-- COMMIT > Ʈ����� �Ϸ�, ���� ����, ROLLBACK �ϸ� �� �������� �̵�
-- INSERT �����
-- ROLLBACK �ϸ� ���� �����? > �̿��ڷ� ��
-- INSERT �����
-- SAVEPOINT UNTIL3 > Savepoint��(��) �����Ǿ����ϴ�.
-- INSERT �����
-- ROLLBACK TO UNTIL3 �ϸ� ���� �����? > ����ڷ� ��
-- INSERT �����
-- ROLLBACK �ϸ� ���� �����? > �̿���
INSERT INTO USER_TCL
VALUES(1, '�Ͽ���', 'khuser01');
SELECT * FROM USER_TCL;
COMMIT;
ROLLBACK;
INSERT INTO USER_TCL VALUES(2, '�̿���', 'khuser02');
INSERT INTO USER_TCL VALUES(3, '�����', 'khuser03');
SAVEPOINT UNTIL3;
-- Savepoint��(��) �����Ǿ����ϴ�.
INSERT INTO USER_TCL VALUES(4, '�����', 'khuser04');
ROLLBACK TO UNTIL3;
INSERT INTO USER_TCL VALUES(4, '�����', 'khuser04');
ROLLBACK;



