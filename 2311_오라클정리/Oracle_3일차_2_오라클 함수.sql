-- 오라클 함수의 종류1
-- 1. 단일행 함수 - 결과값 여러개
-- 2. 다중행 함수 - 결과값 1개(그룹함수)

-- 오라클 함수의 종류2
-- 1. 문자 처리 함수
--  a. LENGTH, LENGTHB : 길이 구함
--  b. INSTR, INSTRB : 위치 구함
--  c. LPAD/RPAD     : 빈 곳에 채워줌
--  d. LTRIM/RTRIM   : 특정문자 제거(공백제거)
--  e. TRIM
--  f. SUBSTR        : 문자열 잘라줌
--  g. CONCAT / ||   : 문자열 합쳐줌
--  h. REPLACE       : 문자열 바꿔줌
-- 2. 숫자 처리 함수
--  - ABS, FLOOR, CEIL(전달값 1개), MOD, ROUND, TRUNC(전달값 2개 가능)
-- 3. 날짜 처리 함수
--  1. SYSDATE
SELECT SYSDATE FROM DUAL;
--  2. ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
--  3. MONTHS_BETWEEN()
SELECT MONTHS_BETWEEN('24/04/25', SYSDATE) FROM DUAL;
-- ex1) EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 3개월이 된 날짜를 조회하시오.
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE,3)
FROM EMPLOYEE;
-- ex2) EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무 개월수를 조회하시오.
SELECT EMP_NAME, HIRE_DATE, 
FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),
TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE),1)
FROM EMPLOYEE;
--  4. LAST_DAY()
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('24/04/25') FROM DUAL;
SELECT LAST_DAY('20/02/22') FROM DUAL;
-- ex3) EMPLOYEE 테이블에서 사원이름, 입사일, 입사월의 마지막날을 조회하세요.
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;
--  5. EXTRACT
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE)||'년' "년"
, EXTRACT(MONTH FROM SYSDATE)||'월' "월"
, EXTRACT(DAY FROM SYSDATE)||'일' "일"
FROM DUAL;
-- ex4) EMPLOYEE 테이블에서 사원이름, 입사 년도, 입사 월, 입사 일을 조회하시오.
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE)||'년' "년"
, EXTRACT(MONTH FROM HIRE_DATE)||'월' "월"
, EXTRACT(DAY FROM HIRE_DATE)||'일' "일"
FROM EMPLOYEE;
-- @실습문제
/*
    오늘부로 일용자씨가 군대에 끌려갑니다.
    군복무 기간이 1년 6개월을 한다라고 가정하면
    첫번째, 제대일자는 언제인지 구하고
    두번째, 제대일짜까지 먹어야 할 짬밤의 그릇수를 구해주세요!!
    (단, 1일 3끼를 먹는다고 한다.)
*/
SELECT ADD_MONTHS(SYSDATE,18) "제대날짜"
, (ADD_MONTHS(SYSDATE,18)-SYSDATE)*3 "짬밥수"
FROM DUAL;

-- 4. 형변환 함수
-- a. TO_CHAR()
-- b. TO_DATE()
-- c. TO_NUMBER()
-- EMPLOYEE테이블에서 입사일이 00/01/01 ~ 10/01/01 사이인 직원의 정보를 출력하시오.
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN TO_DATE('00/01/01') AND TO_DATE('10/01/01');
DESC EMPLOYEE;
-- TO_NUMBER() 예제
SELECT TO_NUMBER('1,000,000', '9,999,999') - TO_NUMBER('500,000', '999,999') FROM DUAL;
SELECT TO_NUMBER('1000000') - TO_NUMBER('500000') FROM DUAL;
-- TO_CHAR() 예제
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') FROM EMPLOYEE;

-- 4. NULL 처리 함수
SELECT * FROM EMPLOYEE;
SELECT EMP_NAME, SALARY, SALARY*NVL(BONUS,0), NVL(MANAGER_ID,'없음') FROM EMPLOYEE;
-- 5. DECODE / CASE 함수





-- @함수 최종실습문제
--1. 직원명과 이메일 , 이메일 길이를 출력하시오
--		  이름	    이메일		이메일길이
--	ex)  홍길동 , hong@kh.or.kr   	  13
SELECT EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL) FROM EMPLOYEE;
--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
--	ex) 노옹철	no_hc
--	ex) 정중하	jung_jh
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL,'@',1,1)-1)
, RTRIM(EMAIL, '@kh.or.kr')
, REPLACE(EMAIL, '@kh.or.kr', '')
FROM EMPLOYEE;
--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오. 그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--	    직원명    년생      보너스
--	ex) 선동일	    1962	    0.3
--	ex) 송은희	    1963  	    0
SELECT EMP_NAME "직원명", 1900+TO_NUMBER(SUBSTR(EMP_NO,1,2)) "년생", NVL(BONUS,0) "보너스"
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO,1,2) >= 60 AND SUBSTR(EMP_NO,1,2) <= 69;
--WHERE SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69;
WHERE EMP_NO LIKE '6%';

SELECT EMP_NAME "직원명", (SUBSTR(EMP_NO,1,2)) "년생", NVL(BONUS,0) "보너스"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 90 AND 99
UNION
SELECT EMP_NAME "직원명", (SUBSTR(EMP_NO,1,2)) "년생", NVL(BONUS,0) "보너스"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 0 AND 9;

--4. '010' 핸드폰 번호를 쓰지 않는 사람의 전체 정보를 출력하시오.
SELECT * FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--5. 직원명과 입사년월을 출력하시오 
--	단, 아래와 같이 출력되도록 만들어 보시오
--	    직원명		입사년월
--	ex) 전형돈		2012년 12월
--	ex) 전지연		1997년 3월
SELECT EMP_NAME "직원명"
, TO_CHAR(HIRE_DATE, 'YYYY"년 "MM"월"') "입사년월1"
, EXTRACT(YEAR FROM HIRE_DATE)||'년 '||EXTRACT(MONTH FROM HIRE_DATE)||'월' "입사년월2"
FROM EMPLOYEE;
--6. 직원명과 주민번호를 조회하시오
--	단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서 출력 하시오
--	ex) 홍길동 771120-1******
SELECT EMP_NAME
, SUBSTR(EMP_NO, 1, 8)||'******'
, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;


--7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
SELECT 
    EMP_NAME "직원명"
    , JOB_CODE "직급코드"
    , TO_CHAR(SALARY*12+SALARY*NVL(BONUS,0), 'L999,999,999') "연봉(원)"
FROM EMPLOYEE;
--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND TO_CHAR(HIRE_DATE, 'YYYY') = 2004;
SELECT TO_CHAR(HIRE_DATE, 'YYYY'), EXTRACT(YEAR FROM HIRE_DATE) FROM EMPLOYEE;
--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--	* 주말도 포함 , 소수점 아래는 버림
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE-HIRE_DATE)
FROM EMPLOYEE;
--10. 직원명, 부서코드, 생년월일, 나이(만) 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
SELECT EMP_NAME, DEPT_CODE
, 1900+SUBSTR(EMP_NO,1,2)||'년'
||SUBSTR(EMP_NO,3,2)||'월'
||SUBSTR(EMP_NO,5,2)||'일' "생년월일"
, EXTRACT(YEAR FROM SYSDATE)-(1900+SUBSTR(EMP_NO,1,2)) "나이(만)"
FROM EMPLOYEE;
--11. 사원명과, 부서명을 출력하세요.
--   부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.








SELECT TO_CHAR(TO_DATE('98','RRRR'),'YYYY') TEST1,
TO_CHAR(TO_DATE('05','RRRR'),'YYYY') TEST2,
TO_CHAR(TO_DATE('98','YYYY'),'YYYY') TEST3,
TO_CHAR(TO_DATE('05','YYYY'),'YYYY') TEST4 FROM DUAL;

SELECT TO_DATE('98','RRRR') TEST1,
TO_DATE('05','RRRR') TEST2,
TO_DATE('98','YYYY') TEST3,
TO_DATE('05','YYYY') TEST4 FROM DUAL;



