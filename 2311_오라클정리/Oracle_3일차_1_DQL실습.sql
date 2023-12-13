-- 오라클 3일차(1.5일)
-- DQL 실습
-- 실습문제
-- SELECT EMP_NAME FROM EMPLOYEE
-- SELECT FROM DEPARTMENT
--1. EMPLOYEE 테이블에서 이름 끝이 연으로 끝나는 사원의 이름을 출력하시오
SELECT EMP_NAME 
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';
--2. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를
--출력하시오
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--3. EMPLOYEE 테이블에서 메일주소의 's'가 들어가면서, DEPT_CODE가 D9 또는 D6이고
--고용일이 90/01/01 ~ 01/12/01이면서, 월급이 270만원이상인 사원의 전체 정보를 출력하시오
SELECT *
FROM EMPLOYEE
--WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6') AND SALARY >= 2700000
WHERE DEPT_CODE IN ('D9','D6') AND SALARY >= 2700000
--AND EMAIL LIKE '%s%' AND (HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/12/01');
AND EMAIL LIKE '%s%' AND (HIRE_DATE BETWEEN '90/01/01' AND '01/12/01');
--4. EMPLOYEE 테이블에서 EMAIL ID 중 @ 앞자리가 5자리인 직원을 조회한다면?
-- 와일드카드 : %(0개이상), _(자리수, 1개이상)
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '_____@%';
--5. EMPLOYEE 테이블에서 EMAIL ID 중 '_' 앞자리가 3자리인 직원을 조회한다면?
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '___\_%' ESCAPE '\';
-- 6. 관리자(MANAGER_ID)도 없고 부서 배치(DEPT_CODE)도 받지 않은  직원의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;
-- 7. 부서배치를 받지 않았지만 보너스를 지급하는 직원 전체 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;
--8. EMPLOYEE 테이블에서 이름,연봉, 총수령액(보너스포함), 
-- 실수령액(총 수령액-(월급*세금 3%*12))
--가 출력되도록 하시오
SELECT
    EMP_NAME, -- 이름
    SALARY*12||'원' AS "연봉", -- 연봉
    --'원' AS "단위1",
    SALARY*12+SALARY*NVL(BONUS, 0)||'원' AS "총수령액", -- 총수령액(보너스포함)
    --'원' AS "단위2",
    SALARY*12+SALARY*NVL(BONUS, 0) - (SALARY*0.03*12) AS "실수령액",
    '원' AS "단위3"
FROM EMPLOYEE;
--9. EMPLOYEE 테이블에서 이름, 근무 일수를 출력해보시오 
--(SYSDATE를 사용하면 현재 시간 출력)
-- Math 절대값, 올림, 반올림, 버림, ...
SELECT EMP_NAME, FLOOR(SYSDATE - HIRE_DATE) AS "근무일수"
FROM EMPLOYEE;

SELECT SYSDATE, SYSTIMESTAMP
FROM DUAL;
--10. EMPLOYEE 테이블에서 20년 이상 근속자의 이름,월급,보너스율를 출력하시오.
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE FLOOR((SYSDATE-HIRE_DATE)/365) >= 20;

-- 최종 실습 문제
-- 문제1. 
-- 입사일이 5년 이상, 10년 이하인 직원의 이름,주민번호,급여,입사일을 검색하여라
SELECT EMP_NAME "이름", EMP_NO AS 주민번호, SALARY AS "급여", HIRE_DATE "입사일"
FROM EMPLOYEE
WHERE FLOOR((SYSDATE-HIRE_DATE)/365) BETWEEN 5 AND 10;
-- 문제2.
-- 재직중이 아닌 직원의 이름,부서코드, 고용일, 근무기간, 퇴직일을 검색하여라 
--(퇴사 여부 : ENT_YN)
SELECT EMP_NAME "이름", DEPT_CODE "부서코드", HIRE_DATE "고용일"
, (ENT_DATE-HIRE_DATE)||'일' "근무기간", ENT_DATE "퇴직일"
FROM EMPLOYEE
WHERE ENT_YN = 'Y';
-- 문제3.
-- 근속년수가 10년 이상인 직원들을 검색하여
-- 출력 결과는 이름,급여,근속년수(소수점X)를 근속년수가 오름차순으로 정렬하여 출력하라
-- 단, 급여는 50% 인상된 급여로 출력되도록 하여라.
SELECT EMP_NAME "이름", SALARY*1.5 "급여", FLOOR((SYSDATE-HIRE_DATE)/365) "근속년수"
FROM EMPLOYEE
WHERE FLOOR((SYSDATE-HIRE_DATE)/365) >= 10
--ORDER BY 근속년수;
ORDER BY 3;
-- SELECT 실행순서
-- FROM - WHERE - SELECT - ORDER BY
-- ORDER BY 정렬
-- 오름차순
-- 1,2,3,4,5,6,7,8,9,10 / abcde.... / 옛날부터 / NULL나중
-- 내림차순
-- 10,9,8,7,6,5,4,3,2,1 / zyxw.... / 최신부터 / NULL먼저
SELECT * FROM EMPLOYEE ORDER BY HIRE_DATE DESC;

-- 문제4.
-- 입사일이 99/01/01 ~ 10/01/01 인 사람 중에서 급여가 2000000 원 이하인 사람의
-- 이름,주민번호,이메일,폰번호,급여를 검색 하시오
SELECT EMP_NAME, EMP_NO, EMAIL, PHONE, SALARY
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '99/01/01' AND '10/01/01'
AND SALARY <= 2000000;

-- 문제5.
-- 급여가 2000000원 ~ 3000000원 인 여직원 중에서 4월 생일자를 검색하여 
-- 이름,주민번호,급여,부서코드를 주민번호 순으로(내림차순) 출력하여라
-- 단, 부서코드가 null인 사람은 부서코드가 '없음' 으로 출력 하여라.
SELECT EMP_NAME, EMP_NO, SALARY, NVL(DEPT_CODE,'없음') "DEPT_CODE"
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 3000000 AND EMP_NO LIKE '__04__-2%';

-- 문제6.
-- 남자 사원 중 보너스가 없는 사원의 오늘까지 근무일을 측정하여 
-- 1000일 마다(소수점 제외) 
-- 급여의 10% 보너스를 계산하여 이름,특별 보너스 (계산 금액) 결과를 출력하여라.
-- 단, 이름 순으로 오름 차순 정렬하여 출력하여라.
-- 2000일 근속, 2500000 -> 500000
SELECT EMP_NAME, FLOOR(FLOOR(SYSDATE - HIRE_DATE)/1000)*SALARY*0.1 "특별보너스"
FROM EMPLOYEE
WHERE EMP_NO LIKE '%-1%' AND BONUS IS NULL;


