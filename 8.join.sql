-- case1 : author inner join post
-- 글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 조회(author와 post의 교집합-author가 왼쪽)
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
select a.*, p.* from author a inner join post p on a.id=p.author_id;
-- 글쓴적있는 글쓴이만 조회하면 a* / 글쓴이가 있는 글만 조회하면 p*

-- case2 : post inner join author
-- 글쓴이가 있는 글과 해당글의 글쓴이를 조회(post와 author의 교집합-post가 왼쪽)
select * from post p inner join author a on p.author_id=a.id; 
-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*, a.email from post p inner join author a on p.author_id=a.id;

-- case3 : author left join post
-- 글쓴이는 모두조회, 만약 쓴 글이 있다면 글도 함께 조회(author는 모두출력,교집합인post도 함께 조회)
select * from author a left join post p on a.id=p.author_id;

-- case4 : post left join author
-- 글을 모두 조회, 글쓴이가 있다면 글쓴이도 함께 조회(post는 모두출력, 교집합인 author도 함께 조회)
select * from post p left join author a on a.id=p.author_id;

-- 글쓴이가 있는 글 중에서 글의 제목과 저자의 email을 출력하되, 저자의 나이가 30세 이상인글만 출력
select p.title, a.email, a.age from post p inner join author a on p.author_id=a.id where a.age>=30;

-- 실습) 글의 저자의 이름이 null이 아닌 글 목록만을 출력
select p.* from post p inner join author a on p.author_id=a.id where a.name is not null;

-- 조건에 맞는 도서와 저자 리스트 출력
-- 없어진 기록 찾기

-- union : 두 테이블의 select 결과를 횡으로 결합
-- union시킬때 컬럼의 개수와 컬럼의 타입이 같아야함
select name, email from author union select title, contents from post;
-- union은 기본적으로 distinct적용. 중복허용하려면 union all 사용.
select name, email from author union all select title, contents from post;

-- 서브쿼리 : select문 안에 또다른 select문을 서브쿼리라고함
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author의 목록 조회(중복제거)
select distinct a.* from author a inner join post p on a.id=p.author_id;
-- null값은 in조건절에서 자동으로 제외
select * from author where id in(select author_id from post);
-- 컬럼 위치에 서브쿼리
-- 회원별로 본인의 쓴 글의 개수를 출력 ex)email, post_count
-- 서브쿼리
select email, (select count(*)from post p where p.author_id=a.id) as post_count from author a;
-- from절 위치에 서브쿼리
select a.* from (select * from author) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화하여, 하나의 행(row)처럼 취급
select author_id from post group by author_id;
select author_id, count(*) from post group by author_id;
-- 회원별로 본인의 쓴 글의 개수를 출력 left join으로 출력 ex)email, post_count
select a.email, count(*) from author a left join post p on a.id=p.author_id group by a.id;
select a.email, count(p.id) from author a left join post p on a.id=p.author_id group by a.email;

-- 집계함수
select count(*) from author;
select sum(age) from author;
select avg(age) from author;
-- 소수점 3번째 자리에서 반올림
select round(avg(age), 3) from author;

-- group by와 집계함수
-- 회원의 이름별 회원수를 출력하고, 이름별 나이의 평균값을 출력하라.
select name, count(*) as count, avg(age) as age from author a group by name;

-- where와 group by
-- 날짜값이 null인 데이터는 제외하고, 날짜별 post 글의 개수 출력
select date_format(created_time, '%Y-%m-%d'), count(*) from post where created_time is not null group by date_format(created_time, '%Y-%m-%d');

-- 자동차 종류별 특정 옵션이 포함된 자통차 수 구하기
-- 입양 시각 구하기(1)

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 3번 이상 쓴 사람 author_id찾기
select author_id, count(*) from post group by author_id having count(*) > 2;
select author_id from post group by author_id having count(*) > 2;

-- sql 코테 정리
select aa, count(*) 
from A inner join B on xx 
where bb='xx' 
group by aa 
having count(*)>=2
order by yy limit 1;

-- 동명 동물 수 찾기 -> having
-- 카테고리 별 도서 판매량 집계하기 -> join까지
-- 조건에 맞는 사용자와 총 거래금액 조회하기 -> join까지