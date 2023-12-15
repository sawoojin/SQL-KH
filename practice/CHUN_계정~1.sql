SELECT STUDENT_NAME "학생이름", STUDENT_NO "학번", STUDENT_ADDRESS "거주지 주소" 
FROM TB_STUDENT
WHERE (STUDENT_ADDRESS LIKE '경기%' OR STUDENT_ADDRESS LIKE '강원%')
AND EXTRACT(YEAR FROM ENTRANCE_DATE) BETWEEN 1990 AND 1999
ORDER BY STUDENT_NAME ASC;
-- ==================== 10
SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름, POINT 전체평점
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);
--WHERE DEPARTMENT_NAME LIKE '음악학과';
GROUP BY ()
