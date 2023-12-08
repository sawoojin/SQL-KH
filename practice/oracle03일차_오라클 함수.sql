-- 오라클 함수
-- 단일행 함수 - 결과값 여러개
-- 다중행 함수 - 결과값 1개(그룹함수)

-- 오라클 함수 종류2
--1. 문자 처리 함수
-- a. LENGTH, LENGTHB
-- b. INSTR, INSTRB : 위치
-- c. LPAD/RPAD : 빈칸 채우기
-- d. LTRIM/RTRIM : 공백(조건)제거
-- e. TRIM 
-- f. SUBSTR : 문자열 가르기
-- g. CONCAT / ||
-- h. REPLACE 
--2. 숫자 처리 함수
-- ABS, FLOOR, CEIL, 1/ MOD, ROUND, TRUNC 2전달값 
--3. 날짜 처리 함수
-- a. SYSDATE
SELECT SYSDATE FROM DUAL;
-- b. ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
-- c. MONTHS_BETWEEN()
SELECT MONTHS_BETWEEN('24/04/25', SYSDATE) FROM DUAL;
-- ex1) EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 3개월이 된날짜를 조회하시오
SELECT EMP_NAME "이름", HIRE_DATE "입사일", ADD_MONTHS(HIRE_DATE, 3) "입사후 3개월" FROM EMPLOYEE;
-- ex2) EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무 개월수를 조회하시오
SELECT EMP_NAME "이름", HIRE_DATE "입사일", FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'개월'  "근무 개월수" FROM EMPLOYEE;
-- d. LAST_DAY()
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('24/04/25') FROM DUAL;
-- ex) EMPLOYEE 테이블에서 사원이름, 입사일, 입사월의 마지막날을 조회하세요
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) FROM EMPLOYEE;
-- e. EXTRACT
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
-- ex) 사원이름, 입사 년 월 일
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE), EXTRACT(MONTH FROM HIRE_DATE),EXTRACT(DAY FROM HIRE_DATE) FROM EMPLOYEE;
-- 군머를 오늘 갓다 군복무는 1년 6개월하면 1, 제대일자는? 2, 남은 짬밥그릇수 (1일3끼)
SELECT ADD_MONTHS(SYSDATE, 18) "저녁", (ADD_MONTHS(SYSDATE, 18)-SYSDATE)*3 "짬밥" FROM DUAL;
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEE;
--4. NULL 처리 함수
SELECT SALARY*NVL(BONUS,0) FROM EMPLOYEE;
--5. DECODE / CASE 함수
SELECT * FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '00/01/01' AND '10/01/01';
-- @함수 최종실습문제
--1. 직원명과 이메일 , 이메일 길이를 출력하시오
SELECT EMP_NAME "이름", EMAIL "이메일", LENGTH(EMAIL) "이메일길이" FROM EMPLOYEE;
--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
SELECT EMP_NAME "이름", SUBSTR(EMAIL, 1, INSTR(EMAIL,'@',1,1)-1) "이메일 아이디" FROM EMPLOYEE;
--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오. 그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
SELECT EMP_NAME "직원명", 19||SUBSTR(EMP_NO, 1,2) "년생", NVL(BONUS, 0) "보너스" 
FROM EMPLOYEE WHERE SUBSTR(EMP_NO, 1,2) BETWEEN 60 AND 69;
--4. '010' 핸드폰 번호를 쓰지 않는 사람의 전체 정보를 출력하시오.
SELECT * FROM EMPLOYEE WHERE NOT SUBSTR(PHONE,1,3) = 010;
--5. 직원명과 입사년월을 출력하시오 
SELECT EMP_NAME "직원명", EXTRACT(YEAR FROM HIRE_DATE)||'년 '||EXTRACT(MONTH FROM HIRE_DATE)||'월' "입사년월" FROM EMPLOYEE;
--6. 직원명과 주민번호를 조회하시오
SELECT EMP_NAME "직원명", SUBSTR(EMP_NO,1,8)||'******' "주민번호" FROM EMPLOYEE;
--7. 직원명, 직급코드, 연봉(원) 조회
SELECT EMP_NAME "직원명", JOB_CODE "직급코드", '￦'||TO_CHAR(((SALARY*12)*NVL(BONUS, 1)), +'999,999,999') "연봉(원)" FROM EMPLOYEE;
--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_CODE "부서코드", HIRE_DATE "입사일" FROM EMPLOYEE WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;
--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
SELECT EMP_NAME "직원명", HIRE_DATE "입사일", ROUND(SYSDATE - HIRE_DATE)||'일' "근무일수" FROM EMPLOYEE;
--10. 직원명, 부서코드, 생년월일, 나이(만) 조회
--	* 주민번호가 이상한 사람들은 제외시키고 진행 하도록(200,201,214 번 제외)
--	* HINT : NOT IN 사용
SELECT EMP_NAME "직원명", DEPT_CODE "부서코드", TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)),'YYYY"년 "MM"월 "DD"일"') "생년월일",
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,6)))||'세' "나이(만)" FROM EMPLOYEE;
--11. 사원명과, 부서명을 출력하세요.
SELECT EMP_NAME "사원명", CASE WHEN DEPT_CODE = 'D5' THEN '총무부' WHEN DEPT_CODE = 'D6' THEN '기획부'
WHEN DEPT_CODE = 'D9' THEN '영업부' END "부서명" FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9') ORDER BY DEPT_CODE ASC;

