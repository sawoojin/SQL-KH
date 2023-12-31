-- 神虞適 敗呪税 曽嫌1
-- 1. 舘析楳 敗呪 - 衣引葵 食君鯵
-- 2. 陥掻楳 敗呪 - 衣引葵 1鯵(益血敗呪)

-- 神虞適 敗呪税 曽嫌2
-- 1. 庚切 坦軒 敗呪
--  a. LENGTH, LENGTHB : 掩戚 姥敗
--  b. INSTR, INSTRB : 是帖 姥敗
--  c. LPAD/RPAD     : 朔 員拭 辰趨捜
--  d. LTRIM/RTRIM   : 働舛庚切 薦暗(因拷薦暗)
--  e. TRIM
--  f. SUBSTR        : 庚切伸 設虞捜
--  g. CONCAT / ||   : 庚切伸 杯団捜
--  h. REPLACE       : 庚切伸 郊蚊捜
-- 2. 収切 坦軒 敗呪
--  - ABS, FLOOR, CEIL(穿含葵 1鯵), MOD, ROUND, TRUNC(穿含葵 2鯵 亜管)
-- 3. 劾促 坦軒 敗呪
--  1. SYSDATE
SELECT SYSDATE FROM DUAL;
--  2. ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
--  3. MONTHS_BETWEEN()
SELECT MONTHS_BETWEEN('24/04/25', SYSDATE) FROM DUAL;
-- ex1) EMPLOYEE 砺戚鷺拭辞 紫据税 戚硯, 脊紫析, 脊紫 板 3鯵杉戚 吉 劾促研 繕噺馬獣神.
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE,3)
FROM EMPLOYEE;
-- ex2) EMPLOYEE 砺戚鷺拭辞 紫据税 戚硯, 脊紫析, 悦巷 鯵杉呪研 繕噺馬獣神.
SELECT EMP_NAME, HIRE_DATE, 
FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),
TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE),1)
FROM EMPLOYEE;
--  4. LAST_DAY()
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('24/04/25') FROM DUAL;
SELECT LAST_DAY('20/02/22') FROM DUAL;
-- ex3) EMPLOYEE 砺戚鷺拭辞 紫据戚硯, 脊紫析, 脊紫杉税 原走厳劾聖 繕噺馬室推.
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;
--  5. EXTRACT
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE)||'鰍' "鰍"
, EXTRACT(MONTH FROM SYSDATE)||'杉' "杉"
, EXTRACT(DAY FROM SYSDATE)||'析' "析"
FROM DUAL;
-- ex4) EMPLOYEE 砺戚鷺拭辞 紫据戚硯, 脊紫 鰍亀, 脊紫 杉, 脊紫 析聖 繕噺馬獣神.
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE)||'鰍' "鰍"
, EXTRACT(MONTH FROM HIRE_DATE)||'杉' "杉"
, EXTRACT(DAY FROM HIRE_DATE)||'析' "析"
FROM EMPLOYEE;
-- @叔柔庚薦
/*
    神潅採稽 析遂切松亜 浦企拭 怪形逢艦陥.
    浦差巷 奄娃戚 1鰍 6鯵杉聖 廃陥虞壱 亜舛馬檎
    湛腰属, 薦企析切澗 情薦昔走 姥馬壱
    砧腰属, 薦企析促猿走 股嬢醤 拝 束鴻税 益県呪研 姥背爽室推!!
    (舘, 1析 3晦研 股澗陥壱 廃陥.)
*/
SELECT ADD_MONTHS(SYSDATE,18) "薦企劾促"
, (ADD_MONTHS(SYSDATE,18)-SYSDATE)*3 "束剛呪"
FROM DUAL;

-- 4. 莫痕発 敗呪
-- a. TO_CHAR()
-- b. TO_DATE()
-- c. TO_NUMBER()
-- EMPLOYEE砺戚鷺拭辞 脊紫析戚 00/01/01 ~ 10/01/01 紫戚昔 送据税 舛左研 窒径馬獣神.
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN TO_DATE('00/01/01') AND TO_DATE('10/01/01');
DESC EMPLOYEE;
-- TO_NUMBER() 森薦
SELECT TO_NUMBER('1,000,000', '9,999,999') - TO_NUMBER('500,000', '999,999') FROM DUAL;
SELECT TO_NUMBER('1000000') - TO_NUMBER('500000') FROM DUAL;
-- TO_CHAR() 森薦
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY"鰍" MM"杉" DD"析"') FROM EMPLOYEE;

-- 4. NULL 坦軒 敗呪
SELECT * FROM EMPLOYEE;
SELECT EMP_NAME, SALARY, SALARY*NVL(BONUS,0), NVL(MANAGER_ID,'蒸製') FROM EMPLOYEE;
-- 5. DECODE / CASE 敗呪





-- @敗呪 置曽叔柔庚薦
--1. 送据誤引 戚五析 , 戚五析 掩戚研 窒径馬獣神
--		  戚硯	    戚五析		戚五析掩戚
--	ex)  畠掩疑 , hong@kh.or.kr   	  13
SELECT EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL) FROM EMPLOYEE;
--2. 送据税 戚硯引 戚五析 爽社掻 焼戚巨 採歳幻 窒径馬獣神
--	ex) 葛針旦	no_hc
--	ex) 舛掻馬	jung_jh
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL,'@',1,1)-1)
, RTRIM(EMAIL, '@kh.or.kr')
, REPLACE(EMAIL, '@kh.or.kr', '')
FROM EMPLOYEE;
--3. 60鰍企拭 殿嬢貝 送据誤引 鰍持, 左格什 葵聖 窒径馬獣神. 益凶 左格什 葵戚 null昔 井酔拭澗 0 戚虞壱 窒径 鞠惟 幻球獣神
--	    送据誤    鰍持      左格什
--	ex) 識疑析	    1962	    0.3
--	ex) 勺精費	    1963  	    0
SELECT EMP_NAME "送据誤", 1900+TO_NUMBER(SUBSTR(EMP_NO,1,2)) "鰍持", NVL(BONUS,0) "左格什"
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO,1,2) >= 60 AND SUBSTR(EMP_NO,1,2) <= 69;
--WHERE SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69;
WHERE EMP_NO LIKE '6%';

SELECT EMP_NAME "送据誤", (SUBSTR(EMP_NO,1,2)) "鰍持", NVL(BONUS,0) "左格什"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 90 AND 99
UNION
SELECT EMP_NAME "送据誤", (SUBSTR(EMP_NO,1,2)) "鰍持", NVL(BONUS,0) "左格什"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 0 AND 9;

--4. '010' 輩球肉 腰硲研 床走 省澗 紫寓税 穿端 舛左研 窒径馬獣神.
SELECT * FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--5. 送据誤引 脊紫鰍杉聖 窒径馬獣神 
--	舘, 焼掘人 旭戚 窒径鞠亀系 幻級嬢 左獣神
--	    送据誤		脊紫鰍杉
--	ex) 穿莫儀		2012鰍 12杉
--	ex) 穿走尻		1997鰍 3杉
SELECT EMP_NAME "送据誤"
, TO_CHAR(HIRE_DATE, 'YYYY"鰍 "MM"杉"') "脊紫鰍杉1"
, EXTRACT(YEAR FROM HIRE_DATE)||'鰍 '||EXTRACT(MONTH FROM HIRE_DATE)||'杉' "脊紫鰍杉2"
FROM EMPLOYEE;
--6. 送据誤引 爽肯腰硲研 繕噺馬獣神
--	舘, 爽肯腰硲 9腰属 切軒採斗 魁猿走澗 '*' 庚切稽 辰趨辞 窒径 馬獣神
--	ex) 畠掩疑 771120-1******
SELECT EMP_NAME
, SUBSTR(EMP_NO, 1, 8)||'******'
, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;


--7. 送据誤, 送厭坪球, 尻裟(据) 繕噺
--  舘, 尻裟精 ��57,000,000 生稽 妊獣鞠惟 敗
--     尻裟精 左格什匂昔闘亜 旋遂吉 1鰍帖 厭食績
SELECT 
    EMP_NAME "送据誤"
    , JOB_CODE "送厭坪球"
    , TO_CHAR(SALARY*12+SALARY*NVL(BONUS,0), 'L999,999,999') "尻裟(据)"
FROM EMPLOYEE;
--8. 採辞坪球亜 D5, D9昔 送据級 掻拭辞 2004鰍亀拭 脊紫廃 送据掻拭 繕噺敗.
--   紫腰 紫据誤 採辞坪球 脊紫析
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND TO_CHAR(HIRE_DATE, 'YYYY') = 2004;
SELECT TO_CHAR(HIRE_DATE, 'YYYY'), EXTRACT(YEAR FROM HIRE_DATE) FROM EMPLOYEE;
--9. 送据誤, 脊紫析, 神潅猿走税 悦巷析呪 繕噺 
--	* 爽源亀 匂敗 , 社呪繊 焼掘澗 獄顕
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE-HIRE_DATE)
FROM EMPLOYEE;
--10. 送据誤, 採辞坪球, 持鰍杉析, 蟹戚(幻) 繕噺
--   舘, 持鰍杉析精 爽肯腰硲拭辞 蓄窒背辞, 
--   しししし鰍 しし杉 しし析稽 窒径鞠惟 敗.
--   蟹戚澗 爽肯腰硲拭辞 蓄窒背辞 劾促汽戚斗稽 痕発廃 陥製, 域至敗
SELECT EMP_NAME, DEPT_CODE
, 1900+SUBSTR(EMP_NO,1,2)||'鰍'
||SUBSTR(EMP_NO,3,2)||'杉'
||SUBSTR(EMP_NO,5,2)||'析' "持鰍杉析"
, EXTRACT(YEAR FROM SYSDATE)-(1900+SUBSTR(EMP_NO,1,2)) "蟹戚(幻)"
FROM EMPLOYEE;
--11. 紫据誤引, 採辞誤聖 窒径馬室推.
--   採辞坪球亜 D5戚檎 恥巷採, D6戚檎 奄塙採, D9戚檎 慎穣採稽 坦軒馬獣神.(case 紫遂)
--   舘, 採辞坪球亜 D5, D6, D9 昔 送据税 舛左幻 繕噺馬壱, 採辞坪球 奄層生稽 神硯託授 舛慶敗.








SELECT TO_CHAR(TO_DATE('98','RRRR'),'YYYY') TEST1,
TO_CHAR(TO_DATE('05','RRRR'),'YYYY') TEST2,
TO_CHAR(TO_DATE('98','YYYY'),'YYYY') TEST3,
TO_CHAR(TO_DATE('05','YYYY'),'YYYY') TEST4 FROM DUAL;

SELECT TO_DATE('98','RRRR') TEST1,
TO_DATE('05','RRRR') TEST2,
TO_DATE('98','YYYY') TEST3,
TO_DATE('05','YYYY') TEST4 FROM DUAL;



