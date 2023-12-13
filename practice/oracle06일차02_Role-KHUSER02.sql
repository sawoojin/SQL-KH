-- 오라클 6일차 오라클 객체 Role
-- ====================== 3. ROLE
-- KHUSER02 계정
-- KHUSER02에서 KH계정 소유의 COFFEE 테이블을 조회하고자 함.
-- 권한문제 조회불가 관리자 계정에서 권한부여
SELECT * FROM KH.COFFEE;
-- 권한부여시 커밋된 데이터가 조회 가능해진다.
INSERT INTO KH.COFFEE VALUES('카누디카페',1500,'카누');
COMMIT;