-- 오라클 6일차 오라클 객체 INDEX
-- ================================ 4. INDEX =======================================
-- -> SQL 명령문의 처리속도를 향상시키기 위해서 컬럼에 대해서 생성하는 오라클 객체
-- - KEY - VALUE 형태로 생성이 되며 KEY에는 인덱스로 만들 컬럼값, VALUE에는 행이 저장된 주소값이 저장됨
-- * 장점 : 검색속도가 빨라지고 시스템에 걸리는 부하를 줄여서 시스템 전체 성능을 향상시킬 수 있음.
-- * 단점 : 1. 인덱스를 위한 추가 저장 공간이 필요하고 인덱스를 생성하는데 시간이 걸림
--          2. 데이터의 변경작업(INSERT/UPDATE/DELETE)이 자주 일어나는 테이블에 INDEX 생성시
--          오히려 성능 저하가 발생할 수 있음.
-- * 어떤 컬럼에 인덱스를 만들면 좋을까?
-- -> 데이터값이 중복된 것이 없는 고유한 데이터값을 가지는 컬럼에 만드는 것이 제일 좋음.
--    그리고 자주 사용되는 컬럼에 만들면 좋음
-- * 효율적인 인덱스 사용 예
-- 1. WHERE절에 자주 사용되는 컬럼에 인덱스 생성
--  > 전체 데이터 중에 10 ~ 15% 이내의 데이터를 검색하는 경우, 중복이 많지 않은 컬럼이어야 함.
-- 2. 두 개 이상의 컬럼 WHERE절이나 조인(JOIN)조건으로 자주 사용되는 경우
-- 3. 한번 입력된 데이터의 변경이 자주 일어나지 않는 경우
-- 4. 한 테이블에 저장된 데이터 용량이 상당히 클 경우
SELECT * FROM EMPLOYEE;

-- 인덱스 생성
CREATE INDEX IND_EMP_ENAME
ON EMPLOYEE(EMP_NAME);
-- 인덱스 확인
SELECT * FROM USER_IND_COLUMNS;
-- 인덱스 삭제
DROP INDEX IND_EMP_ENAME;

CREATE INDEX IDX_EMP_COLUMNS
ON EMPLOYEE(EMP_NAME, EMP_NO, HIRE_DATE);

-- 튜닝시 사용되는 명령어
-- #1
EXPLAIN PLAN FOR
SELECT * FROM EMPLOYEE
WHERE EMP_NO LIKE '%04%';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- #2
SET TIMING ON;
SELECT * FROM EMPLOYEE
WHERE EMP_NO LIKE '%04%';
-- F10으로 실행하여 오라클 PLAN 확인하여 인덱스 성능 확인
--SET TIMING OFF;

-- ================================= 1. PL/SQL ===================================
-- Oracle's Procedural Language Extension to SQL의 약자
-- > 오라클 자체에 내장되어 있는 절차적 언어로써, SQL의 단점을 보완하여 SQL문장 내에서
-- 변수의 정의, 조건처리, 반복처리 등을 지원함.

-- PL/SQL의 유형
-- 1. 익명블록(Anonymous Block)
-- 2. 프로시저(Procedure)
-- 3. 함수(Function)

-- PL/SQL의 구조(익명블록)
-- 1. 선언부(선택) : DECLARE
-- 2. 실행부(필수) : BEGIN
-- 3. 예외처리부(선택) : EXCEPTION
-- 4. END; (필수)
-- 5. /(필수)
SET SERVEROUTPUT ON;

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO PL/SQL');
END;
/
-- PL/SQL에서 변수쓰는 방법
DECLARE
    VID NUMBER;
BEGIN
    SELECT EMP_ID
    INTO VID
    FROM EMPLOYEE
    WHERE EMP_NAME = '선동일';
    DBMS_OUTPUT.PUT_LINE('ID = '||VID);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data~');
END;
/
SET TIMING OFF;

-- ============================= 2. PL/SQL 변수 ==================================
-- # 변수의 자료형
-- 1. 기본 자료형
-- VARCHAR2, NUMBER, DATE, BOOLEAN, ...
-- 2. 복합 자료형
-- Record, Cursor, Collection
-- 2.1 %TYPE 변수
-- 내가 가져오려고 했던 테이블의 컬럼 타입을 그대로 가져오는 방법.
DESC EMPLOYEE;
DECLARE
    VEMPNO EMPLOYEE.EMP_NO%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSAL   EMPLOYEE.SALARY%TYPE;
    VHDATE EMPLOYEE.HIRE_DATE%TYPE;
    -- %TYPE 속성을 사용하여 선언한 VEMPNO변수는 해당 테이블의 컬럼과 같은 자료형과
    -- 크기를 그대로 참조해서 만들어짐.
    -- 컬럼의 자료형이 변경되면 참조하는 레퍼런스 변수의 자료형과 크기도 자동으로 반영되므로
    -- 별도로 수정할 필요가 없는 장점이 있음.
BEGIN
    SELECT EMP_NO, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPNO, VENAME, VSAL, VHDATE
    FROM EMPLOYEE
    WHERE EMP_ID = '203';
    DBMS_OUTPUT.PUT_LINE(VEMPNO||':'||VENAME||':'||VSAL||':'||VHDATE);
    -- 변수에 담은 값을 출력하게 해주는 부분
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found');        
END;
/
-- @실습문제1
-- 사번, 사원명, 직급명을 담을 수 있는 참조변수(%TYPE)를 통해서
-- 송종기 사원의 사번, 사원명, 직급명을 익명블럭을 통해 출력하세요.
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VJNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_NAME
    INTO VEMPID, VENAME, VJNAME
    FROM EMPLOYEE
    LEFT OUTER JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = '송종기';
    DBMS_OUTPUT.PUT_LINE(VEMPID||':'||VENAME||':'||VJNAME);
--EXCEPTION
END;
/

-- 2.2 %ROWTYPE
-- 행(ROW) 단위로 참조하는 속성, 전체 컬럼의 데이터를 사용할때 유용함
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철';
    DBMS_OUTPUT.PUT_LINE(VEMP.EMP_ID||':'||VEMP.EMP_NAME);
--EXCEPTION
END;
/

-- ===================== 3. PL/SQL 입력받기 =====================
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : '||VEMP.EMP_ID||', 이름 : '||VEMP.EMP_NAME);
END;
/
-- @실습문제2
-- 사원번호를 입력받아서 해당 사원의 사원번호, 이름, 부서코드, 부서명을 출력하세요.
-- 1. 결과값을 출력하는 쿼리문 작성
-- 2. PL/SQL 익명블록에 적용
-- 3. 사원번호 입력받아서 PL/SQL로 출력하기
DECLARE
    --VEMP EMPLOYEE%ROWTYPE;
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDCODE DEPARTMENT.DEPT_ID%TYPE;
    VDNAME DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    INTO VEMPID, VENAME, VDCODE, VDNAME
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE(VENAME||':'||VDCODE||':'||VDNAME);
END;
/













