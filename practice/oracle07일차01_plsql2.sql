-- 오라클 7일차 PL/SQL
-- 기본 SQL 문법에서 안된 것을 추가하여 사용할 수 있도록 해줌
-- EX) 변수선언, 제어문, ...
SET SERVEROUTPUT ON;
SET TIMING ON;
SET TIMING OFF;
BEGIN
 DBMS_OUTPUT.PUT_LINE('HELLO PL/SQL');
END;
/

-- 실습3
-- EMPLOYEE 테이블에서 사번의 마지막 번호를 구한뒤 +1한 사번에 사용자로부터 입력받은
-- 이름, 주민번호, 전화번호, 직급코드, 급여등급을 등록하는 PL/SQL 을 작성하시오
-- 1. 마지막번호를 구하는 쿼리문은 어떻게 될 것인가?
-- 2. 마지막 번호는 변수에 저장해서 레코드 등록시 사용
-- 3. 이름 입력받고 주민번호 입력받고 전화번호 입력받고 직급코드 입력받고 급여등급 입력받아서
-- EMPLOYEE 테이블에 INSERT 하시오
DECLARE
    LAST_NUM EMPLOYEE.EMP_ID%TYPE;
BEGIN
    SELECT MAX(EMP_ID)
    INTO LAST_NUM
    FROM EMPLOYEE;
    INSERT INTO EMPLYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(LAST_NUM+1, '&NAME', '&PSN', '&PHONE', '&JCODE', '&SL');
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 원인과 조치방안을 작성하시오
-- EMPLOYEE 테이블은 컬럼이 14개인데 입력한 값은 6개이다. 
-- ======================= PL/SQL 조건문
-- 1. IF (조건식) THEN (실행문) END IF;
-- 실습1
-- 사원번호를 입력받아서 사원의 사번, 이름, 급여, 보너스율을 출력하시오
-- 단, 직급코드가 J1인 경우 '저희 회사 대표놈입니다'를 출력하세요
-- 사번 : 222
-- 이름 : 이태림
-- 급여 : 2460000
-- 보너스율 : 0.35
-- 저희 회사 대표놈입니다
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||EMP_INFO.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스율 : '||EMP_INFO.BONUS);
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('저희 회사 대표놈입니다');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 2. IF(조건식) THEN (실행문) ELSE (실행문) END IF;
-- 실습2
-- 사원번호를 입력받아서 사원의 사번, 이름, 부서명, 직급명을 출력하시오.
-- 단, 직급코드가 J1인 경우 '대표놈' 그 외에는 '일반직원'으로 출력하세요.
-- 사번 : 201
-- 이름 : 송종기
-- 부서명 : 총무부
-- 직급명 : 부사장
-- 소속 : 일반직원
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
    JOB_INFO JOB.JOB_CODE%TYPE;
    
BEGIN
    SELECT *
    INTO EMP_INFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : '||JOB_INFO);
    DBMS_OUTPUT.PUT_LINE('직급명 : '||EMP_INFO.BONUS);
    IF (EMP_INFO.JOB_CODE = 'J1')
    THEN EMPTEAM :='저희 회사 대표놈입니다';
    ELSEIF (JCODE = 
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 3. IF (조건식) THEN (실행문) ELSIF (조건식) THEN (실행문) ELSE (실행문) END IF;
-- 실습3
-- 사번을 입력받은 후 급여에 따라 등급으로 나누어 출력하도록 하시오.
-- 그때 출력 값은 사번, 이름, 급여, 급여등급을 출력하시오
-- 500 이상 A 400-499 B 300 399B200 299 100 199 0 99F
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
    GRADE CHAR;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMP_INFO.EMP_ID, EMP_INFO.EMP_NAME, EMP_INFO.SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||EMP_INFO.SALARY);
    IF (EMP_INFO.SALARY >= 5000000)
        THEN GRADE := 'A';
    ELSIF (EMP_INFO.SALARY >= 4000000)
        THEN GRADE := 'B';
    ELSIF (EMP_INFO.SALARY >= 3000000)
        THEN GRADE := 'C';
    ELSIF (EMP_INFO.SALARY >= 2000000)
        THEN GRADE := 'D';
    ELSIF (EMP_INFO.SALARY >= 1000000)
        THEN GRADE := 'E';
    ELSE
        GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE('급여등급 : '||GRADE);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 4.CASE문
-- CASE
--      WHEN 값 THEN 실행문
--      WHEN 값 THEN 실행문
-- END CASE;
-- 입력받은 값이 1이면 빨간색입니다. 2면 노랑색입니다 3이면 초록색입니다를 출력하세요
DECLARE
    INPUTVAL NUMBER;
BEGIN
    INPUTVAL := '&입력값';
    CASE INPUTVAL
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('빨갱이');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('노랭이');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('초랭이');
    END CASE;
END;
/
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
    GRADE VARCHAR2(1);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMP_INFO.EMP_ID, EMP_INFO.EMP_NAME, EMP_INFO.SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMP_INFO.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||EMP_INFO.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||EMP_INFO.SALARY);
    GRADE := FLOOR(GRADE / 1000000);
    CASE GRADE
        WHEN 5 THEN DBMS_OUTPUT.PUT_LINE('급여등급 : A');
        WHEN 4 THEN DBMS_OUTPUT.PUT_LINE('급여등급 : B');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('급여등급 : C');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('급여등급 : D');
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('급여등급 : E');
        WHEN 0 THEN DBMS_OUTPUT.PUT_LINE('급여등급 : F');
    END CASE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- PL/SQL 에서 제어문 중 조건문 IF
-- 1. IF (조건식) THEN (실행문) END IF;
-- 2. IF (조건식) THEN (실행문) ELSE (실행문) END IF;
-- 3. IF (조건식) THEN (실행문) ELSIF (실행문) THEN (실행문) ELSE (실행문) END IF;
-- ===================== PL/SQL 반복문
-- 1. LOOP
-- 2. WHILE LOOP
-- 3. FOR LOOP
-- 예제 1~5까지 반복 출력하기
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
        EXIT WHEN N > 5;
--        IF(N > 5) THEN EXIT;
--        END IF;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 실습1
-- 1 ~ 10 사이의 난수를 5개 출력해보세요
DECLARE
    N NUMBER;
BEGIN
    N := 1;
    LOOP
        DBMS_OUTPUT.PUT_LINE(FLOOR(DBMS_RANDOM.VALUE(1,11)));
        N := N+1;
        EXIT WHEN N > 5;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 2. WHILE LOOP 
-- 제어 조건이 TRUE 인 동안만 문장이 반복 실행됨
-- LOOP를 실행할 때 조건이 처음부터 FALSE이면 한번도 수행되지 않을 수 있음
-- EXIT 절이 없어도 조건절에 반복문 중지 조건을 기술할 수 있음
-- WHILE(조건식) LOOP (실행문) END LOOP;
-- 1 ~ 5 출력
DECLARE
    N NUMBER := 1;
BEGIN
    WHILE(N <= 5) LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/
-- 실습 2
-- 사용자로부터 2~9 사이에 수를 입력받아 구구단을 출력하시오 ELSE 2~9사이의 수를 입력하세요
-- 2 * 1 = 2
DECLARE
    N NUMBER := 1;
    M NUMBER := '&숫자';
BEGIN
    IF (M >= 10) THEN DBMS_OUTPUT.PUT_LINE('2~9사이의 수를 입력하세요');
    ELSIF (M <= 1) THEN DBMS_OUTPUT.PUT_LINE('2~9사이의 수를 입력하세요');
    ELSE
        WHILE(N <= 9) LOOP
            DBMS_OUTPUT.PUT_LINE(M ||' * '|| N ||' = '|| M*N );
            N := N + 1;
        END LOOP;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/
-- 연습문제3
-- 1~30까지의 수 중에서 홀수만 출력하시오
-- LOOP (실행문) EXIT WHEN(N > 6) END LOOP;
-- WHILE(N > 6) LOOP (실행문) END LOOP;
-- 제어문 : 조건문, 반복문, 분기문(COUNTINUE, BREAK)
DECLARE
    N NUMBER := 0;
BEGIN
    WHILE (N < 30) LOOP
    N := N+1;
        CONTINUE WHEN MOD(N,2) = 0;
--        IF(MOD(N,2) = 1) THEN
        DBMS_OUTPUT.PUT_LINE(N);
--        END IF;
    END LOOP;
END;
/
-- FOR LOOP
-- FOR LOOP 문에서 카운트용 변수는 자동 선언되므로, 따로 변수 선언할 필요가 없
-- 카운트는 자동으로 1씩 증가
-- REVERSE는 1씩 감소
BEGIN
    FOR N IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/
-- 실습4
-- EMPLOYEE 테이블의 사번이 200 ~ 210인 직원들의 사원번호, 사원명, 이메일을 출력
DECLARE
    EMP_INFO EMPLOYEE%ROWTYPE;
BEGIN
    FOR EMP_REC IN (SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE) LOOP
        EXIT WHEN EMP_REC.EMP_ID > 210;
        DBMS_OUTPUT.PUT_LINE('사원번호: ' || EMP_REC.EMP_ID ||', 사원명: ' || EMP_REC.EMP_NAME ||', 이메일: ' || EMP_REC.EMAIL);
    END LOOP;
END;
/
-- 실습5
-- KH_NUMBER_TBL 은 숫자타입의 컬럼 NO와 날짜타입의 컬럼 INPUT_DATE를 포함한다
-- KH_NUMBER_TBL 테이블에 0 ~ 99 까지의 난수를 10개 저장하시오 날짜는 상관없
CREATE TABLE KH_NUMBER_TBL
(
    NO NUMBER,
    INPUT_DATE DATE DEFAULT SYSDATE
);
BEGIN
    FOR N IN 1..10 LOOP
        INSERT INTO KH_NUMBER_TBL
        VALUES(FLOOR(DBMS_RANDOM.VALUE(0,99)), DEFAULT);
    END LOOP;
END;
/
DROP TABLE KH_NUMBER_TBL;
--------------------- PS/SQL 예외처리
-- 시스템 오류(메모리 초과, 인덱스 중복 키 등)는 오라클이 정의하는 에러로
-- 보통 PL/SQL 실행 엔진이 오류 조건을 탐지하여 발생시키는 예외임
-- 1. 미리 정의된 예외처리
-- 2. 사용자 정의 예외처리
-- 3. 미리 정의되지 않은 예외처리(심화)
-- NO_DATA_FOUND
-- SELECT INTO 문장의 결과로 선택된 행이 하나도 없을 경우
-- DUP_VAL_ON_INDEX
-- UNIQUE 인덱스가 설정된 컬럼에 중복 데이터를 입력할 경우
-- CASE_NOT_FOUND : CASE 구문에서 ELSE 구문도 없고 WHEN 절에 명시된 조건을 만족하는 값이 없을 경우
-- ACCESS_INTO_NULL : 초기화되지 않은 오브젝트에 값을 할당하려고 할 경우
-- COLLECTION_IS_NULL : 초기화되지 않은 중첩 테이블이나 VARRAY같은 컬랙션을 EXISTS외의 다른 메소드로 접근할 경우
-- CURSOR_ALREADY_OPEN : 이미 오픈된 커서를 다시 오픈하려고 시도하는 경우
-- INVALID_CURSOR : 허용되지 않은 커서에 접근할 경우 (OPEN되지 않은 커서를 닫으려고 할 경우)
-- INVALID_NUMBER : 문자형 데이터를 숫자형으로 전환할 때 제대로 된 숫자가 아닐 경우
-- LOGIN_DENIED : 잘못된 사용자명이나 비밀번호로 접속 시도
BEGIN
 INSERT INTO EMPLOYEE(EMP_ID, ENP_NAME, EMP_NO, PHONE, JOB_CODE, GRADE);
 VALUES(200, ; 이백용사','991214-2312323.'01020465453','35','S5');
EXCEPTION
    WHEN                                                                                                                                                                                                                                                                                                                                                                                                
END;
/

-- DECLARE
-- BEGIN
-- EXCEPTION
--      WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
-- END;
-- /;