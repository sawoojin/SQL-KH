-- 오라클 6일차 TCL
-- =================== TCL(Transaction Control Language) ========================
-- =================== COMMIT, ROLLBACK, SAVEPOINT       ========================
-- =================== 트랜잭션 처리 언어                 ========================
-- 트랜잭션(Transaction)이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말함.
-- ATM 출금, 계좌이체 등이 트랜잭션의 예
-- 1. 카드 투입
-- 2. 메뉴 선택
-- 3. 금액 입력
-- 4. 비밀번호 입력
-- 5. 출금 완료 (잔금 부족)

-- ORACLE DBMS 트랜잭션?
-- INSERT 수행시 Oracle은 트랜잭션 처리 -> 그 뒤에 추가 작업이 있을것으로 처리함
-- INSERT - INSERT - INSERT - ... - COMMIT(트랜잭션 완료, 최종 저장)
-- INSERT - DELETE - UPDATE - INSERT - ... - ROLLBACK;(트랜잭션 완료, 원복)

-- ========================== TCL 명령어 ===============================
-- 1. COMMIT : 트랜잭션 작업이 정상 완료되어 변경 내용을 영구히 저장(모든 savepoint 삭제)
-- 2. ROLLBACK : 트랜잭션 작업을 모두 취소하고 가장 최근 COMMIT 시점으로 이동.
-- 3. SAVEPOINT <savepoint명> : 현재 트랜잭션 작업 시점에 이름을 지정함. 임시저장
-- 하나의 트랜잭션에서 구역을 나눌 수 있음.

CREATE TABLE USER_TCL 
(
    USER_NO NUMBER UNIQUE,
    USER_NAME VARCHAR2(20) NOT NULL,
    USER_ID VARCHAR2(30) PRIMARY KEY
);
-- INSERT 일용자
-- COMMIT > 트랜잭션 완료, 최종 저장, ROLLBACK 하면 이 시점으로 이동
-- INSERT 이용자
-- ROLLBACK 하면 어디로 갈까요? > 일용자로 감
-- INSERT 이용자
-- COMMIT > 트랜잭션 완료, 최종 저장, ROLLBACK 하면 이 시점으로 이동
-- INSERT 삼용자
-- ROLLBACK 하면 어디로 갈까요? > 이용자로 감
-- INSERT 삼용자
-- SAVEPOINT UNTIL3 > Savepoint이(가) 생성되었습니다.
-- INSERT 사용자
-- ROLLBACK TO UNTIL3 하면 어디로 갈까요? > 삼용자로 감
-- INSERT 사용자
-- ROLLBACK 하면 어디로 갈까요? > 이용자
INSERT INTO USER_TCL
VALUES(1, '일용자', 'khuser01');
SELECT * FROM USER_TCL;
COMMIT;
ROLLBACK;
INSERT INTO USER_TCL VALUES(2, '이용자', 'khuser02');
INSERT INTO USER_TCL VALUES(3, '삼용자', 'khuser03');
SAVEPOINT UNTIL3;
-- Savepoint이(가) 생성되었습니다.
INSERT INTO USER_TCL VALUES(4, '사용자', 'khuser04');
ROLLBACK TO UNTIL3;
INSERT INTO USER_TCL VALUES(4, '사용자', 'khuser04');
ROLLBACK;



