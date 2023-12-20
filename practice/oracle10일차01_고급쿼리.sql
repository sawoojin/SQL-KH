-- 오라클 10일차, 고급쿼리
-- 1. TOP-N 분석
-- 2. WITH 구문
-- 3. 계층형 쿼리(Hierarchical Query)
-- 4. 윈도우 함수
-- 특정 컬럼에서 가장 큰 N개의 값 또는 가장 작은 N개의 값을 구해야 할 경우에 사용
-- EX) 가장 적게 팔린 제품 10가지는? 회사에서 급여가 가장 높은 사람 3명은?
SELECT MAX(SALARY) FROM EMPLOYEE;
-- # ROWNUM, ROWID
-- 테이블을 생성하면 자동으로 만들어짐.
-- ROWID : 테이블의 특정 레코드를 랜덤하게 접근하기 위한 논리적인 주소값
-- ROWNUM : 각 행에 대한 일련번호, 오라클에서 내부적으로 부여하는 컬럼.
SELECT ROWNUM, ROWID, EMP_ID FROM EMPLOYEE;
SELECT ROWNUM, SALARY FROM EMPLOYEE ORDER BY 2 DESC;
-- 급여를 내림차순 정렬 후 ROWNUM으로 넘버링해서 TOP3를 구하려고 했지만
-- ROWNUM이 부여된 후 ORDER BY를 하였기 때문이다..
-- 해결 : ORDER BY 이후에 ROWNUM을 부여한다.
SELECT ROWNUM, EMP_NAME, SALARY
FROM 
(SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY 2 DESC);

-- 실습1
-- D5부서에서 연봉이 가장 높은 사람 3명의 전체정보를 출력하세요
SELECT ROWNUM, E.*
FROM  
(SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D5' ORDER BY SALARY DESC) E
WHERE ROWNUM < 4;
-- 실습2
-- 부서별 급여평균 TOP3 부서의 부서코드와 부서명, 평균급여를 출력하세요
SELECT * FROM
(
SELECT ROWNUM RNUM, E.*
FROM
(SELECT DEPT_CODE, DEPT_TITLE, TO_CHAR(ROUND(AVG(SALARY)), 'L999,999,999') AVG_SAL 
FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
GROUP BY DEPT_CODE, DEPT_TITLE 
ORDER BY 3 DESC) E 
)
WHERE RNUM BETWEEN 4 AND 6;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
-- 2. WITH
-- 서브쿼리에 이름을붙여두고 인라인뷰로 사용 시 서브쿼리의 이름을 FROM 절에 길술할 수 이승ㅁ
-- 같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있고 실행속도도 빨라짐
-- ㅏ숑법
-- WITH 이름 AS (서브쿼리)
-- SELECT * FROM (서브쿼리명)
-- 옞
-- EMPLOYEE 테이블에서 연봉 TOP 5DLS 직원의 전체 정보를 출력하시오
SELECT ROWNUM, F.*
FROM
(SELECT * FROM EMPLOYEE ORDER BY SALARY DESC) F
WHERE ROWNUM < 6;
-- 실습1
-- D5 부서에서 연봉이 가장 높은 사람 3명의 전체정보
SELECT ROWNUM, E.*
FROM 
(SELECT * FROM EMPLOYEE );
-- 실습 2
-- 부서별 급여평균 TOP3 부서의 부서코드와 부서며으 평균급여를 출력
WITH TOPN_DEPT SAL AS (SELECT DEPT_CODE, DEPT_TITLE, ROUND(AVG(SALARY))) AVG_SAL
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_CODE, DEPT_tITLE
ORDER BY AVG_SAL DESC

WHERE ROWNUM < 4;
-- 4 ~ 6위?
-- 윈도우 함수
-- 1. 순위함수
-- 1.1 RANK() OVER
-- 1.1.1 사용법 : RANK() OVER(ORDER BY컬럼멍 ASC | DESC)
-- 특정 컬럼을 기준으로 랭킹을 부여함. 중복 순위 다음은 해당 객수만큼 컨너가고 나이로 반환됨
-- 회사 연봉 순위
SELECT ROWNUM, TOPN_SAL
FROM (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC) E;
WITH TOPN_SAL AS (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC)
SELECT ROWNUM, TOP_SAL.*
FROM TOPN_SAL;
SELECT EMP_NAME ,SALARY, RANK() OVER(ORDER BY SALARY DESC) 연봉순위
FROM EMPLOYEE;
--
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
--실습문제. 기본급여의 등수가 1등부터 10등까지인 직원의 이름, 급여, 순위를 출력하시오
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE WHERE ROWNUM BETWEEN 1 AND 10;
-- 계층형 쿼리
-- JOIN을 통해 수평적으로 기준컬럼을 연결시킨 것과 달리 기준컬럼을 가지고 수직적인 관계로 만듬
-- 조직도, 메뉴, 단답형 게시판 등 프렉탈 구조의 표현에 적합함.
-- 오라클에서 사용되는 구문
-- 1. START WITH : 부모행(루트)를 지정
-- 2. CONNECT BY : 부모 자식관계를 지정
-- 3. PRIOR : START WITH 절에서 제시한 부모행의 기준컬럼을 지정함
-- 4. LEVEL : 의사컬럼(PSEUDO COLUM), 계층정보를 나타내는 가상컬럼, SELECT, WHERE, ORDER BY 에서 사용가능
-- 예제 1명이라도 직원을 관리하는 매니저의 정보를 출력하세요
--@실습예제1
--MENU_TBL 테이블을 생성하는데 숫자인 NO칼럼이 PRIMARY KEY로 있고,문자로 크기가 100인
--MENU_NAME 칼럼이 있고 숫자로 된 PARENT_NO 라고 하는 컬럼이 있음
CREATE TABLE MENU_TBL
(
    NO NUMBER PRIMARY KEY,
    MENU_NAME VARCHAR2(100),
    PARENT_NO NUMBER
);
SELECT * FROM MENU_TBL;
INSERT INTO MENU_TBL
VALUES(100,'주메뉴1',NULL);
INSERT INTO MENU_TBL
VALUES(200,'주메뉴2',NULL);
INSERT INTO MENU_TBL
VALUES(300,'주메뉴3',NULL);
INSERT INTO MENU_TBL
VALUES(1000,'서브메뉴A',100);
INSERT INTO MENU_TBL
VALUES(2000,'서브메뉴B',200);
INSERT INTO MENU_TBL
VALUES(3000,'서브메뉴C',300);
INSERT INTO MENU_TBL
VALUES(1001,'상세메뉴A1',1000);
INSERT INTO MENU_TBL
VALUES(1002,'상세메뉴A2',1000);
INSERT INTO MENU_TBL
VALUES(1003,'상세메뉴A3',1000);
INSERT INTO MENU_TBL
VALUES(3001,'상세메뉴C1',3000);
SELECT LPAD(' ㄴ' , (LEVEL-1)*5,'')|| MENU_NAME "메뉴"
FROM MENU_TBL
START WITH PARENT_NO IS NULL
CONNECT BY PRIOR NO= PARENT_NO;
SELECT LPAD('ㄴ' , (LEVEL-1)*5,'')||MENU_NAME|| NVL2(PARENT_NO, ' ('||PARENT_NO||')','')AS "메뉴판"
FROM MENU_TBL
START WITH NO IN (100,200,300)
CONNECT BY PRIOR NO = PARENT_NO;
