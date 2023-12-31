-- 오라클 6일차 오라클객체 INDEX
-- SQL 명령문의 처리속도를 향상시키기 위해 컬럼에 대해 생성하는 오라클 객체
-- - KEY - VALUE 형태로 생성이 되며 KEY에는 인덱스로 만들 컬럼값,
-- VALUE에는 행이 저장된 주소값이 저장된다.
-- 장점 : 검색속도가 빨라지고 시스템에 걸리는 부하를 줄여 전체 성능 향상.
-- 단점 : 1. 인덱스를 위한 추가 저장 공간이 필요하고 인덱스를 생성하는데 시간이 걸림
--        2. 데이터의 변경작업(INSERT/UPDATE/DELETE)가 자주 일어나는 테이블에 INDEX 생성시
--           오히려 성능 저하가 발생할 수 있음.
-- 인덱스를 만들면 좋은 컬럼
-- 데이터값이 중복된 것이 없는 고유한 데이터값을 가지는 컬럼에 만드는 것이 좋음.
-- 효율적인 인덱스 사용 예
-- 1. WHERE 절에 자주 사용되는 컬럼에 인덱스 생성
-- > 전체 데이터 중에 10 ~ 15%이내의 데이터를 검색하는 경우, 중복이 많지 않은 컬럼이어야 함.
-- 2. 두개 이상의 컬럼 WHERE절이나 JOIN조건으로 자주 사용되는 경우
-- 3. 한번 입력된 데이터의 변경이 자주 일어나지 않는 경우
-- 4. 한 테이블에 저장된 데이터 용량이 상당히 큰 경우
SELECT * FROM EMPLOYEE;
-- INDEX 생성
CREATE INDEX IND_EMP_ENAME ON EMPLOYEE(EMP_NAME);
-- INDEX 확인
SELECT * FROM USER_IND_COLUMNS;
-- INDEX 삭제
DROP INDEX IND_EMP_ENAME;
CREATE INDEX IND_EMP_ENAME ON EMPLOYEE(EMP_NAME, EMP_NO, HIRE_DATE);
-- 튜닝시 사용되는 명령어
EXPLAIN PLAN FOR
SELECT * FROM EMPLOYEE
WHERE EMP_NO LIKE '%04%';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- 2
SET TIMING ON;
SELECT * FROM EMPLOYEE WHERE EMP_NO LIKE '%04%';
-- F10으로 실행하여 오라클 PLAN 확인해 인덱스 성능 확인
-- SET TIMING OFF;
-- ===================== PL/SQL
-- Oracle's Procedural Language Extension to SQL 의 약자
-- 오라클 자체에 내장되어 있는 절차적 언어로써, SQL의 단점을 보완하여 SQL문장에서
-- 변수의 정의, 조건처리, 반복처리 등을 지원함.
-- PL/SQL 의 유형
-- 1. 익명블록(Annoymous Block)
-- 2. 프로시저(Procedure)
-- 3. 함수(Function)

-- PL/SQL의 구조(익명블록)
-- 1. 선언부(선택) : DECLARE
-- 2. 실행부(필수) : BIGIN
-- 3. 예외처리부(선택) : EXCEPION
-- 4. END; (필수)
-- 5.(필수)
SET SERVEROUTPUT ON;
SET TIMING OFF;
-- 기본 자료형 
-- VARCAHR2, NUMBER, DATE, BOOLEAN
-- 복합 자료형
-- RECORD, CURSOR, COLLECTION
-- 2.1 %TYPE변수
-- 내가 가져오려고 했던 테이블의 컬럼 타입을 그대로 가져오는 방법
DECLARE
    VEMPNO EMPLYEE.EMP_NO%TYPE;
    VENAME VARCHAR2(30);
    VSAL NUMBER;
    VHDATE DATE;
-- %TYPE 속성을 사용하여 선언한 VEMPNO변수는 해당 테이블의 컬럼과 같은 자료형과
-- 크기를 그대로 참조해서 만들어짐.
-- 컬럼의 자료형이 변경되면 참조하는 레퍼런스 변수의 자료형과 크기도 자동으로 반영되므로
-- 별도의 수정할 필요하 없는 장점이 있음
BEGIN
    SELECT EMP_NO, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPNO, VENAME, VSAL, VHDATE
    FROM EMPLOYEE
    WHERE EMP_ID = '203';
    DBMS_OUTPUT.PUT_LINE(VEMPNO||':'||VENAME||':'||VSAL||':'||VHDATE);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found');
END;
/
-- @실습문제1
-- 사번, 사원명, 직급명을 담을 수 있는 참조변수(%TYPE)를 통해서
-- 송종기 사원의 사번, 사워명, 직급명을 익명블럭을 통해 출력하세요
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
----------- 3. 입력받기
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '200';
    DBMS_OUTPUT.PUT_LINE('사번 : '||VEMP.EMP_ID||', 이름 : '||VEMP.EMP_NAME);
END;
/
-- 실습2
-- 사원번호를 입력받아서 행당 사원의 사원번호, 이름, 부서코드, 부서명을 출력하세요
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : '||VEMP.EMP_ID||', 이름 : '||VEMP.EMP_NAME||', 부서명 : '||VEMP.DEPT_TITLE);
END;
/
SELECT STUDENT_NAME "학생이름", STUDENT_NO "학번", STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '경기%'
AND STUDENT_ADDRESS LIKE '강원%'
--AND ENTRANCE_DATE LIKE '9%'
ORDER BY STUDENT_NAME ASC;