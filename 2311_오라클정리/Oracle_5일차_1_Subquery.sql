-- 오라클 5일차 서브쿼리
-- ================== 서브쿼리(SubQuery) ==========================
-- 하나의 SQL문 안에 포함되어 있는 또 다른 SQL문
-- 메인 쿼리가 서브 쿼리를 포함하는 종속적인 관계
-- 서브쿼리는 반드시 소괄호로 묶어야 함
-- 서브쿼리 안에 ORDER BY는 지원 안됨!

-- 전지연 직원의 관리자 이름을 출력하세요.
SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME LIKE '전지연';
SELECT EMP_NAME FROM EMPLOYEE 
WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME LIKE '전지연');
--WHERE EMP_ID = '214';
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 출력하세요.
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE;
-- 3047662
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE);
--WHERE SALARY > 3047662;

-- ================== 서브쿼리의 종류 =========================
-- 1. 단일행 서브쿼리
-- 2. 다중행 서브쿼리
-- 3. 다중열 서브쿼리
-- 4. 다중행 다중열 서브쿼리
-- 5. 상(호연)관 서브쿼리
-- 6. 스칼라 서브쿼리
-- ==================== 2. 다중행 서브쿼리 ===========================
-- 송종기나 박나라가 속한 부서에 속한 직원들의 전체 정보를 출력하세요.
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '송종기')
UNION
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '박나라');

SELECT * FROM EMPLOYEE 
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('송종기', '박나라'));

-- @실습문제1
-- 차태연, 전지연 사원의 급여등급과 같은 사원의 직급명, 사원명을 출력하세요.
-- 1. 차태연, 전지원의 급여등급을 구함
-- 2. 구한 급여등급을 조건절에 이용하여 직급명, 사원명을 출력한다.
-- 3. 직급명은 EMPLOYEE 테이블에 없으므로 JOB테이블과 조인하여 가져와야함.
SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연');
SELECT JOB_NAME, EMP_NAME 
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연'));

-- @실습문제2
-- 2.Asia1지역에 근무하는 직원의 정보(부서코드, 사원명)를 출력하세요.
-- 1. Asia1지역에 근무하는 부서의 코드를 구하기
-- 2. 부서코드를 이용해서 직원의 정보 구하기
SELECT DEPT_CODE, EMP_NAME FROM EMPLOYEE 
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1');

SELECT DEPT_ID FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1';

-- ========================= 5. 상(호연)관 서브쿼리 ===============================
-- 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를 다시 메인쿼리로 반환해서 수행
-- 상호연관 관계를 가지고 실행하는 쿼리
-- > 서브쿼리의 WHERE절 수행을 위해서 메인쿼리가 먼저 수행되는 구조
-- > 메인 쿼리 테이블의 레코드에 따라 서브쿼리의 결과값도 바뀜.

-- 부하직원이 한명이라도 있는 직원의 정보를 출력하시오.
SELECT * FROM EMPLOYEE WHERE 1 = 1;
-- EMP_ID로 MANAGER_ID를 조회했을 때 존재하면 해당 행을 출력하도록 하려면?
SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
-- @실습문제1
-- 가장 많은 급여를 받는 직원을 출력하시오.
-- 단일행 서브쿼리 사용
SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
-- @실습문제2
-- 가장 적은 급여를 받는 직원을 출력하시오.
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);
-- @실습문제3
-- 심봉선과 같은 부서의 사원의 부서코드, 사원명, 월평균급여를 조회하시오.
SELECT DEPT_CODE, EMP_NAME, (SELECT FLOOR(AVG(SALARY))FROM EMPLOYEE)
FROM EMPLOYEE E 
WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE 
AND EMP_NAME = '심봉선');
-- @실습문제4
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는
-- 직원의 부서코드, 사원명, 급여, (부서별 급여평균) 정보를 출력하시오.
SELECT DEPT_CODE, EMP_NAME, SALARY
, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "부서별 급여평균"
FROM EMPLOYEE E
WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') 
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);

SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D5';

-- =================== 6. 스칼라 서브쿼리 =============================
-- 결과값이 1개인 상관서브쿼리, SELECT문 뒤에 사용됨.
-- SQL에서 단일값을 스칼라값이라고 함.
-- 예제1. 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회하세요!
SELECT EMP_ID, EMP_NAME, MANAGER_ID
, (SELECT EMP_NAME FROM EMPLOYEE M WHERE M.EMP_ID = E.MANAGER_ID) "관리자명" 
FROM EMPLOYEE E;
-- @실습문제1
-- 사원명, 부서명, 부서의 평균임금(자신이 속한 부서의 평균임금)을 스칼라 서브쿼리를 이용해서
-- 출력하세요.
SELECT EMP_NAME, DEPT_TITLE
, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "부서별 평균임금"
FROM EMPLOYEE E
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 확인용
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE 
WHERE DEPT_CODE = (SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE = '총무부');
-- @실습문제2
-- 직급이 J1이 아닌 사원 중에서 자신의 부서 평균급여보다 적은 급여를 받는 사원출력하시오
-- 부서코드, 사원명, 급여, 부서의 급여평균을 출력하시오.
SELECT DEPT_CODE, EMP_NAME, SALARY
FROM EMPLOYEE E
WHERE JOB_CODE != 'J1' 
AND SALARY < (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);
-- @실습문제3
-- 자신이 속한 직급의 평균급여보다 많이 받는 직원의 이름, 직급, 급여를 출력하시오.
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE = E.JOB_CODE);

SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE = 'J4';
-- @실습문제4
-- 모든 직원의 사번, 이름, 소속부서를 조회한 후 부서명을 오름차순으로 정렬하시오.
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
ORDER BY 3 ASC;

SELECT EMP_ID, EMP_NAME
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE)  "부서명"
FROM EMPLOYEE E
ORDER BY 3 ASC;

