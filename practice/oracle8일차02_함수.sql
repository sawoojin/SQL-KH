SET SERVEROUTPUT ON;
-- 오라클 8일차, 오라클 객체 프로시저, 함수, 트리거
-- PL/SQL 유형
-- 1. 익명블록
-- 2. 프로지서
-- 3. 함수
-- ==================== PL/SQL - Stored Procedure
-- 프로시져는 일련의 작업 절차를 정리해서 저장해둔 것
-- 함수와는 다르게 반환값이 없음.
-- 큰 업무를 분할해서 처리해야 할 경우 업무단위를 프로시져로 구현하여 처리함.
-- 여러 SQL문을 묶어서 미리 정의해두고 하나의 요청으로 실행할 수 있음
-- 저장 프로시져는 성능향상을 기대할 수 있음
-- ======================= Stored Procedure 사용법
-- CREATE OR REPLACE PROCEDURE 프로스져명(매개변수1, 매개변수2, .... )
-- 매개변수는 IN모드(데이터를 전달받을 때), OUT모드(수행된 결과를 받아갈 때)가 있음
-- IS
-- 변수선언가능 (OUT모드)
--  익명블록
-- 실행시 EXECUTE 프로시져명
CREATE TABLE EMP_DUPLICATE
AS SELECT * FROM EMPLOYEE;
-- 프로시저 생성
CREATE OR REPLACE PROCEDURE PROC_DEL_ALL_EMP
IS
BEGIN
    DELETE FROM EMP_DUPLICATE;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('데이터가 모두 삭제됨');
END;
/
-- 프로시져 실행
EXECUTE PROC_DEL_ALL_EMP;
-- Stroed Procedure 로 만들어보기 (PROC_ADD_ALL_EMP)
CREATE OR REPLACE PROCEDURE PROC_ADD_ALL_EMP
IS
BEGIN
    INSERT INTO EMP_DUPLICATE
    (SELECT * FROM EMPLOYEE);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('데이터가 모두 추가됨');
END;
/
-- 뭐시기가 컴파일되었습니다.
-- 프로시저 실행
EXECUTE PROC_ADD_ALL_EMP;
-- Stroed Procedure 매개변수 사용해보기
CREATE OR REPLACE PROCEDURE PROC_DEL_ONE_EMP(IN_EMPID IN EMP_DUPLICATE.EMP_ID%TYPE)
IS
BEGIN
    DELETE FROM EMP_DUPLICATE WHERE EMP_ID = IN_EMPID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(IN_EMPID||'번 사원이 삭제되었습니다');
END;
/
EXECUTE PROC_DEL_ONE_EMP('&IN_EMPID');
SELECT * FROM EMP_DUPLICATE;
ROLLBACK;
-- 2# 매개변수 IN, OUT모드 모두 사용하여 SELECT 해보기
CREATE OR REPLACE PROCEDURE PROC_SELECT_EMP_INFO
(
    P_EMPID IN EMPLOYEE.EMP_ID%TYPE,
    P_ENAME OUT EMPLOYEE.EMP_NAME%TYPE,
    P_SALARY OUT EMPLOYEE.SALARY%TYPE,
    P_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS 
BEGIN
    SELECT EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO P_ENAME, P_SALARY, P_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMPID;
END;
/
-- 바인드 변수 선언
VAR B_ENAME VARCHAR2(30);
VAR B_SALARY NUMBER;
VAR B_BONUS NUMBER;
EXEC PROC_SELECT_EMP_INFO('&EMPID', :B_ENAME, :B_SALARY, :B_BONUS);
PRINT B_ENAME;
PRINT B_SALARY;
PRINT B_BONUS;
-- 모아보기
VAR RESULT VARCHAR2(200);
EXEC :RESULT := (:B_ENAME||', '||:B_SALARY||', '||:B_BONUS);
PRINT RESULT;
-- @실습문제
-- 1. 기존 부서테이블의 DEPT_ID, DEPT_TITLE만 복제한 DEPT_COPY 테이블을 생성한다.
-- 2. DEPT_ID 컬럼에 PK추가하고 DEPT_ID 컬럼을 확장한다(CHAR(3))
-- 3. DEPT_COPY를 관리하는 프로시져 PROC_MAN_DEPT_COPY를 생성한다.
-- 3.1 첫번째 인자로 FLAG값 UPDATE/DELETE를 받는다.
-- 3.2 UPDATE시 데이터가 존재하지 않으면 INSERT, 데이터가 존재하면 UPDATE를 하도록 한다.
-- 3.3 DELETE시 해당부서에 사원이 존재하는지 검사하여 존재하면 경고메시지와 함께 실행취소하고
-- 그렇지 않으면 삭제하도록 한다.

-- #1
CREATE TABLE DEPT_COPY
AS SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;
SELECT * FROM DEPT_COPY;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DEPT_COPY';
DESC DEPT_COPY;
-- #2
-- #2.1 PK추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT PK_DEPT_ID PRIMARY KEY(DEPT_ID);
-- 121 실행 후 117 확인해보면 PK가 추가되어있음.
-- #2.2 컬럼 자료형 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
-- #3
CREATE OR REPLACE PROCEDURE PROC_MAN_DEPT_COPY
(
    P_FLAG IN VARCHAR2,
    P_DEPTID IN DEPARTMENT.DEPT_ID%TYPE,
    P_DTITLE IN DEPARTMENT.DEPT_TITLE%TYPE
)
IS
    P_CNT NUMBER := 0;
BEGIN
    IF (P_FLAG = 'UPDATE')
    THEN
        -- 3.2 UPDATE시 부서코드가 존재하지 않으면 부서코드, 부서명을 INSERT
        -- , 부서코드가 존재하면 부서명을 UPDATE하도록 한다.
        SELECT COUNT(*) INTO P_CNT FROM DEPT_COPY WHERE DEPT_ID = P_DEPTID;
        IF (P_CNT > 0)
        THEN 
            -- 존재하면 UPDATE
            UPDATE DEPT_COPY SET DEPT_TITLE = P_DTITLE WHERE DEPT_ID = P_DEPTID;
        ELSE
            -- 존재하지 않으면 INSERT
            INSERT INTO DEPT_COPY VALUES(P_DEPTID, P_DTITLE);
        END IF;
    ELSIF (P_FLAG = 'DELETE')
    THEN 
        -- 3.3 DELETE시 해당부서에 사원이 존재하는지 검사하여 존재하면 경고메시지와 함께 실행취소하고
        -- 그렇지 않으면 삭제하도록 한다.
        SELECT COUNT(*) INTO P_CNT FROM EMPLOYEE WHERE DEPT_CODE = P_DEPTID;
        IF (P_CNT > 0) 
        THEN
            -- 부서에 직원 존재
            DBMS_OUTPUT.PUT_LINE('ERROR : 해당 부서에 직원이 존재하므로, 부서를 삭제할 수 없습니다.');
        ELSE
            -- 부서에 직원이 없음
            DELETE FROM DEPT_COPY WHERE DEPT_ID = P_DEPTID;
        END IF;
    END IF;
    COMMIT;
END;
/
-- #3.2 동작확인
EXEC PROC_MAN_DEPT_COPY('UPDATE', 'D10', '회계부');
-- #3.3 동작확인
EXEC PROC_MAN_DEPT_COPY('DELETE', 'D10', '');
SELECT * FROM DEPT_COPY ORDER BY 2 DESC;
-- ======================== PL/SQL FUNCTION
-- RETURN 값이 존재하는 STORED PROCEDURE
-- ======================== 사용법
-- CREATE OR REPLACE FUNCTION 함수명(매개변수1, 매개변수2, ..)
-- RETURN 자료형(EX. VARCHAR2, NUMBER, ..)
-- IS
--      지역변수 선언
-- BEGIN
--      실행문
-- END;
-- /
-- ======================== 실행방법
-- EXEC 바인드 변수 := 함수명(매개변수1, 매개변수2, ..)
-- 문자열을 입력받아 양 옆에 d와b를 붙여 헤드폰을 씌워주는 함수를 작성하시오.
-- ^^ -> d^^b , T^T -> dT^Tb
CREATE OR REPLACE FUNCTION GET_HEADPHONE
(
    P_STR VARCHAR2
)
RETURN VARCHAR2
IS
    RESULT VARCHAR2(200);
BEGIN
    RESULT := 'd'||P_STR||'b';
    RETURN RESULT; -- 자료형과 같은 변수를 리턴해줌
END;
/
VAR vSTR VARCHAR2;
EXEC :vSTR := GET_HEADPHONE('&arg');
PRINT vSTR;

-- 실습예제 1
-- 사번을 입력받아 해당 사원의 연봉을 계산하여 리턴하는 함수를 만들어 출력하시오
-- 함수명 : FN_SALARY_CALC, 바인드 변수명 : VAR_CALC
CREATE OR REPLACE FUNCTION FN_SALARY_CALC
(
    V_EMPID EMPLOYEE.EMP_ID%TYPE
)
RETURN NUMBER
IS
    CALC_SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT SALARY INTO CALC_SAL
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMPID;
    CALC_SAL := CALC_SAL*12;
    RETURN CALC_SAL;
END;
/
VAR vCAL NUMBER;
EXEC :vCAL := FN_SALARY_CALC('&EMP_ID');
PRINT vCAL;
-- select문에서 실행
SELECT FN_SALARY_CALC('&EMP_ID') FROM DUAL;
SELECT EMP_NAME "사원명", FN_SALARY_CALC(EMP_ID) "연봉" FROM EMPLOYEE;
-- 실습문제2
-- 사원번호를 입력받아서 성별을 리턴하는 저장함수 FN_GET_GENDER 를 생성하고 실행해보세요.
CREATE OR REPLACE FUNCTION FN_GET_GENDER
(
    V_EMPID EMPLOYEE.EMP_ID%TYPE
)
RETURN VARCHAR2
IS
    V_GENDER EMPLOYEE.EMP_NO%TYPE;
BEGIN
    SELECT EMP_NO INTO V_GENDER
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMPID;
    IF (SUBSTR(V_GENDER,8,1) = '1') THEN
        RETURN '남';
    ELSE
        RETURN '여';
    END IF;
    RETURN V_GENDER;
END;
/
VAR vGENDER VARCHAR2;
SELECT FN_GET_GENDER('&EMP_ID') FROM DUAL;
-- 실습3
-- 사용자로부터 입력받은 사원명으로 검색하여 해당 사원의 직급명을 얻어 오는 함수를 작성하시오
-- 단,FN_GET_JOB_NAME 을 함수 이름으로 하고 해당 사원이 없다면 ' 해당사원없음 ' 을 출력하시오
CREATE OR REPLACE FUNCTION FN_GET_JOB_NAME
(
    V_EMPNAME EMPLOYEE.EMP_NAME%TYPE
)
RETURN VARCHAR2
IS
    V_JOBCODE EMPLOYEE.JOB_CODE%TYPE;
    V_JOBNAME VARCHAR2(10);
BEGIN
--    SELECT JOB_CODE 
--    INTO V_JOBCODE
--    FROM EMPLOYEE
--    WHERE EMP_NAME = V_EMPNAME;
    
    SELECT JOB_NAME 
    INTO V_JOBNAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = V_EMPNAME;
    RETURN V_JOBNAME;
EXCEPTION WHEN NO_DATA_FOUND 
THEN RETURN '해당사원없음';
END;
/
SELECT FN_GET_JOB_NAME('&EMP_NAME') FROM DUAL;
SELECT EMP_NAME "사원명", FN_GET_JOB_NAME(EMP_NAME) "직급명" FROM EMPLOYEE;
-- PS/SQL 유형
-- 1. 익명블록
-- 2. Strored Procedure
-- 3. Function
-- =============== 오라클 객체 Trigger 
-- 트리거 : 방아쇠, 연쇄반응
-- 특정 이벤트나 DDL, DML문장이 실행되었을 때
-- 자동적으로 일련의 동작(Operation) 처리가 수행되도록 하는 데이터베이스 객체 중 하나임
-- ex) 회원탈퇴가 이루어질 경우 회원 탈퇴 정보를 일정기간 저장해야 되는 경우가 있음
-- 회원탈퇴가 이루어진 후 해당 정보를 자동으로 저장할 수 있도록 설정할 수 있음.
-- or 데이터 변경이 있을때, 조작한 데이터에 대한 로그(이력)을 남기는 경우 트리거 사용 예시
-- ================= 트리거 사용방법
-- CREATE OR REPLACE TRIGGER 트리거명
-- BEFORE (OR AFTER)
-- DELETE (OR UPDATE OR INSERT) ON 테이블명
-- [FOR EACH ROW]
-- BEGIN
--      (실행문)
-- END;
-- /
-- 예제 사원 테이블에 새로운 데이터가 들어오면 ' 신입사원이 입사하였습니다. ' 를 출력하기
CREATE OR REPLACE TRIGGER TRG_EMP_NEW
AFTER
INSERT ON EMP_DUPLICATE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사하였습니다.');
END;
/
INSERT INTO EMP_DUPLICATE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
VALUES('224', '정하용', '991215-1394355', '01046652154', 'J5', 'S5');
ROLLBACK;
DROP TRIGGER TRG_EMP_NEW;
-- 연습문제 1. 