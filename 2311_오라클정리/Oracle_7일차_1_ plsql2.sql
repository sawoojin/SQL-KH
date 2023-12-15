-- 오라클 7일차 PL/SQL
-- 기본 SQL문법에서 안된 것을 추가하여 사용할 수 있도록 해줌
-- ex) 변수선언, 제어문, ...
SET SERVEROUTPUT ON;

SET TIMING ON;
SET TIMING OFF;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;
/
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
BEGIN
    SELECT EMP_ID
    INTO VEMPID
    FROM EMPLOYEE
    WHERE EMP_NAME = '&이름';
END;
/

-- @실습문제3
-- EMPLOYEE 테이블에서 사번의 마지막 번호를 구한뒤 +1한 사번에 사용자로부터
-- 입력받은 이름, 주민번호, 전화번호, 직급코드, 급여등급을 등록하는 PL/SQL을 작성하시오.
-- 1. 마지막번호를 구하는 쿼리문은 어떻게 될 것인가?
-- 2. 마지막번호는 변수에 저장해서 레코드 등록시 사용
-- 3. 이름 입력받고 주민번호 입력받고 전화번호 입력받고 직급코드 입력받고 급여등급 입력받아서
-- EMPLOYEE테이블에 INSERT하시오!
DECLARE
    LAST_NUM EMPLOYEE.EMP_ID%TYPE;
BEGIN
    SELECT MAX(EMP_ID)
    INTO LAST_NUM
    FROM EMPLOYEE;
    
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(LAST_NUM+1, '&NAME', '&PSN', '&PHONE', '&JCODE', '&SL');
    COMMIT;
--EXCEPTION
--    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/
SELECT * FROM EMPLOYEE ORDER BY 1 DESC;
ROLLBACK;
-- 원인과 조치방안을 작성하시오
-- 원인 : EMPLOYEE테이블은 컬럼이 14개인데 입력한 값은 6개이다. 그래서 값의 수가 충분하지 않습니다.
-- 조치방안1 : 입력한 값이 6개라서 발생한 문제이므로 8개 추가하여 14개로 맞춰준다.
-- 조치방안2 : 입력한 값이 6개이고 6개만 입력하기 위해서 컬럼을 지정해준다.
/*
오류 보고 -
ORA-06550: 줄 8, 열17:PL/SQL: ORA-00947: 값의 수가 충분하지 않습니다
ORA-06550: 줄 8, 열5:PL/SQL: SQL Statement ignored
06550. 00000 -  "line %s, column %s:\n%s"
*Cause:    Usually a PL/SQL compilation error.
*Action:
*/

-- =========================== PL/SQL의 조건문 ============================
-- 1. IF (조건식) THEN (실행문) END IF;
-- @실습문제1
-- 사원번호를 입력받아서 사원의 사번, 이름, 급여, 보너스율을 출력하시오
-- 단, 직급코드가 J1인 경우 '저희 회사 대표님입니다.'를 출력하시오.
-- 사번 : 222
-- 이름 : 이태림
-- 급여 : 2460000
-- 보너스율 : 0.35
-- 저희 회사 대표님입니다.
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    --SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    SELECT *
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||EMP_INFO.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스율 : '||EMP_INFO.BONUS*100||'%');
    
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('저희 회사 대표님입니다.');
    END IF;
    -- IF () THEN ~ END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/

-- 2. IF (조건식) THEN (실행문) ELSE (실행문) END IF;
-- @실습문제2
-- 사원번호를 입력받아서 사원의 사번, 이름, 부서명, 직급명을 출력하시오.
-- 단, 직급코드가 J1인 경우 '대표', 그 외에는 '일반직원'으로 출력하시오.
-- 사번 : 201
-- 이름 : 송종기
-- 부서명 : 총무부
-- 직급명 : 부사장
-- 소속 : 일반직원
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    JNAME JOB.JOB_NAME%TYPE;
    JCODE JOB.JOB_CODE%TYPE;
    EMPTEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, JOB_CODE
    INTO EMPID, ENAME, DTITLE, JNAME, JCODE
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    LEFT OUTER JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMP_ID';
    
    IF (JCODE = 'J1')
    THEN EMPTEAM := '임원';
    ELSIF (JCODE = 'J2') 
    THEN EMPTEAM := '부사장';
    ELSE EMPTEAM := '일반직원';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : '||DTITLE);
    DBMS_OUTPUT.PUT_LINE('직급명 : '||JNAME);
    DBMS_OUTPUT.PUT_LINE('소속 : '||EMPTEAM);
END;
/
-- 3. IF (조건식) THEN (실행문) ELSIF (조건식) THEN (실행문) ELSE (실행문) END IF;
-- @실습문제3
-- 사번을 입력 받은 후 급여에 따라 등급을 나누어 출력하도록 하시오.
-- 그때 출력 값은 사번, 이름, 급여, 급여등급을 출력하시오.
-- 500만원 이상(그외) : A
-- 400만원 ~ 499만원 : B
-- 300만원 ~ 399만원 : C
-- 200만원 ~ 299만원 : D
-- 100만원 ~ 199만원 : E
-- 0만원 ~ 99만원 : F

-- 사번 : 201
-- 이름 : 송종기
-- 급여 : 5000000
-- 급여등급 : A
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL   EMPLOYEE.SALARY%TYPE;
    SLEVEL VARCHAR2(2);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMPID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    SAL := SAL / 10000;
    IF( SAL >= 0 AND SAL <= 99)
    THEN SLEVEL := 'F';
    ELSIF(SAL BETWEEN 100 AND 199) THEN SLEVEL := 'E';
    ELSIF(SAL BETWEEN 200 AND 299) THEN SLEVEL := 'D';
    ELSIF(SAL BETWEEN 300 AND 399) THEN SLEVEL := 'C';
    ELSIF(SAL BETWEEN 400 AND 499) THEN SLEVEL := 'B';
    ELSE SLEVEL := 'A';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SAL);
    DBMS_OUTPUT.PUT_LINE('급여등급 : '||SLEVEL);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_ID = '&사번';

-- 4. CASE문
-- CASE 변수
--      WHEN 값1 THEN 실행문1
--      WHEN 값2 THEN 실행문2
--      WHEN 값3 THEN 실행문3
--      WHEN 값4 THEN 실행문4
-- END CASE;
-- 입력받은 값이 1이면 빨간색입니다. 2면 노랑색입니다. 3이면 초록색입니다를 출력하세요.
DECLARE
    INPUTVAL NUMBER;
BEGIN
    INPUTVAL := '&INPUTVAL';
    CASE INPUTVAL
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('빨간색입니다.');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('노랑색입니다.');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('초록색입니다.');
    END CASE;
END;
/

-- ================= 급여등급 출력문을 CASE문으로 바꿔보기 ======================
DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL   EMPLOYEE.SALARY%TYPE;
    SLEVEL VARCHAR2(2);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMPID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    SAL := FLOOR(SAL / 1000000);
    CASE SAL
        WHEN 0 THEN SLEVEL := 'F';
        WHEN 1 THEN SLEVEL := 'E';
        WHEN 2 THEN SLEVEL := 'D';
        WHEN 3 THEN SLEVEL := 'C';
        WHEN 4 THEN SLEVEL := 'B';
        ELSE SLEVEL := 'A';
    END CASE;
--    IF( SAL >= 0 AND SAL <= 99)
--    THEN SLEVEL := 'F';
--    ELSIF(SAL BETWEEN 100 AND 199) THEN SLEVEL := 'E';
--    ELSIF(SAL BETWEEN 200 AND 299) THEN SLEVEL := 'D';
--    ELSIF(SAL BETWEEN 300 AND 399) THEN SLEVEL := 'C';
--    ELSIF(SAL BETWEEN 400 AND 499) THEN SLEVEL := 'B';
--    ELSE SLEVEL := 'A';
--    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SAL);
    DBMS_OUTPUT.PUT_LINE('급여등급 : '||SLEVEL);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found~');
END;
/
-- PL/SQL에서 제어문 중 조건문 IF
-- 1. IF (조건식) THEN (실행문) END IF;
-- 2. IF (조건식) THEN (실행문) ELSE (실행문) END IF;
-- 3. IF (조건식) THEN (실행문) ELSIF (조건식) THEN (실행문) ELSE (실행문) END IF;

-- ============================= PL/SQL의 반복문 ===================================
-- 1. LOOP
-- 2. WHILE LOOP
-- 3. FOR LOOP

-- 1. LOOP
-- 예제 1 ~ 5까지 반복 출력하기
DECLARE
    N NUMBER := 1;
BEGIN
    -- for(var i = 0; i < 5; i++) console.log(i);
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
        EXIT WHEN N > 5;
--        IF(N > 5)
--        THEN EXIT;
--        END IF;
    END LOOP;
END;
/
-- @실습문제1
-- 1 ~ 10 사이의 난수를 5개 출력해보시오.
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(FLOOR(DBMS_RANDOM.VALUE(1,11)));
        N := N + 1;
        EXIT WHEN N > 5;
    END LOOP;
END;
/
-- 2. WHILE LOOP
-- 제어 조건이 TRUE인 동안만 문장이 반복 실행됨
-- LOOP를 실행할 때 조건이 처음부터 FALSE이면 한번도 수행되지 않을 수 있음.
-- EXIT절이 없어도 조건절에 반복문 중지 조건을 기술할 수 있음.
-- WHILE(조건식) LOOP (실행문) END LOOP;
-- 1 ~ 5까지 WHILE LOOP으로 출력해보기
DECLARE
    N NUMBER := 1;
BEGIN
    WHILE(N <= 5) LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/
-- @실습문제2
-- 사용자로부터 2~9사이의 수를 입력받아 구구단을 출력하시오.
-- 2 * 1 = 2
-- 2 * 2 = 4
-- ...
-- 2 * 9 = 18

-- 2 ~ 9 사이의 수를 입력하세요.
DECLARE
    N NUMBER := 1;
    DAN NUMBER;
BEGIN
    DAN := '&단';
    IF (DAN BETWEEN 2 AND 9) 
    THEN         
        WHILE(N < 10) LOOP
            DBMS_OUTPUT.PUT_LINE(DAN||' * '||N||' = '||DAN * N);
            N := N + 1;
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('2 ~ 9 사이의 수를 입력하세요.');
    END IF;
END;
/

-- @실습문제3
-- 1 ~ 30까지의 수 중에서 홀수만 출력하시오~
-- 2로 나눈 나머지가 0이 아니면 홀수임.
-- 제어문 : 조건문, 반복문, 분기문(continue, break)
DECLARE
    N NUMBER := 0;
BEGIN
    WHILE(N < 30) LOOP
         N := N + 1;
         CONTINUE WHEN MOD(N,2) = 0;
         DBMS_OUTPUT.PUT_LINE(N);
         -- MOD(N, 2)
--         IF(MOD(N,2) != 0)
--         THEN DBMS_OUTPUT.PUT_LINE(N);
--         END IF;
    END LOOP;
END;
/


-- LOOP (실행문) EXIT WHEN(N > 6) END LOOP;
-- WHILE(N > 6) LOOP (실행문) END LOOP;

-- 3. FOR LOOP
-- FOR LOOP문에서 카운트용 변수는 자동 선언되므로, 따로 변수 선언할 필요가 없음.
-- 카운트 값은 자동으로 1씩 증가함.
-- REVERSE는 1씩 감소함.
-- FOR LOOP를 이용하여 1 ~ 5까지 출력하시오.
BEGIN
    FOR D IN 1..100
    LOOP
        IF(D > 1)
        THEN DBMS_OUTPUT.PUT_LINE(D);
        END IF;
    END LOOP;
END;
/
-- @실습문제4
-- EMPLOYEE 테이블의 사번이 200 ~ 210인 직원들의 사원번호, 사원명, 이메일을 출력하시오~!
DECLARE
    EINFO EMPLOYEE%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('ID          NAME              EMAIL');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    FOR I IN 200..210
    LOOP
        SELECT *
        INTO EINFO
        FROM EMPLOYEE
        WHERE EMP_ID = I;
        DBMS_OUTPUT.PUT_LINE(EINFO.EMP_ID||'        '||EINFO.EMP_NAME||'        '||EINFO.EMAIL);
    END LOOP;
END;
/

-- @실습문제5
-- KH_NUMBER_TBL은 숫자타입의 컬럼 NO와 날짜타입의 컬럼 INPUT_DATE를 가지고 있다.
-- KH_NUMBER_TBL 테이블에 0 ~ 99 사이의 난수를 10개 저장하시오. 날짜는 상관없음.
CREATE TABLE KH_NUMBER_TBL
(
    NO NUMBER,
    INPUT_DATE DATE DEFAULT SYSDATE
);
SELECT COUNT(*) FROM KH_NUMBER_TBL;
ROLLBACK;
BEGIN
    FOR N IN 1..10000
    LOOP
        INSERT INTO KH_NUMBER_TBL
        VALUES(FLOOR(DBMS_RANDOM.VALUE(0,99)), DEFAULT);
    END LOOP;
    COMMIT;
END;
/

-- =========================== PL/SQL 예외처리 =================================
-- 시스템 오류(메모리 초과, 인덱스 중복 키 등)는 오라클이 정의하는 에러로
-- 보통 PL/SQL 실행 엔진이 오류 조건을 탐지하여 발생시키는 예외임.
-- 1. 미리 정의된 예외처리
-- 2. 사용자 정의 예외처리
-- 3. 미리 정의되지 않은 예외처리(심화)
-- NO_DATA_FOUND
-- SELECT INTO 문장의 결과로 선택된 행이 하나도 없을 경우
-- DUP_VAL_ON_INDEX
-- UNIQUE 인덱스가 설정된 컬럼에 중복 데이터를 입력할 경우
-- CASE_NOT_FOUND
-- CASE문장에서 ELSE 구문도 없고 WHEN절에 명시된 조건을 만족하는 것이 없을 경우
-- ACCESS_INTO_NULL
-- 초기화되지 않은 오브젝트에 값을 할당하려고 할 때
-- COLLECTION_IS_NULL
-- 초기화되지 않은 중첩 테이블이나 VARRAY같은 컬렉션을 EXISTS외에 다른 메소드로 접근을 시도할 경우
-- CURSOR_ALREADY_OPEN
-- 이미 오픈된 커서를 다시 오픈하려고 시도하는 경우
-- INVALID_CURSOR
-- 허용되지 않은 커서에 접근할 경우 (OPEN되지 않은 커서를 닫으려고 할 경우)
-- INVALID_NUMBER
-- SQL문장에서 문자형 데이터를 숫자형으로 변환할 때 제대로 된 숫자로 변환되지 않을 경우
-- LOGIN_DENIED
-- 잘못된 사용자명이나 비밀번호로 접속을 시도할 때
BEGIN
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(200, '이백용자', '991214-2312323', '01029293838', 'J5', 'S5');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/

--DECLARE
--BEGIN
--EXCEPTION
--    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NONO');
--END;
--/

























