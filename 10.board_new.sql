-- 회원테이블 생성
-- id(pk), email(unique, not null), name(not null), password(not null)
create table author(id bigint primary key, email varchar(255) not null unique, name varchar(255), password varchar(255) not null);

-- 주소테이블
-- id, country(not null), city(not null), street(not null), author_id(fk, not null)
create table address(id bigint primary key, country varchar(255) not null,  city varchar(255) not null,  street varchar(255) not null, author_id bigint not null unique, foreign key(author_id) references author(id));

-- post 테이블
-- id, title(not null), contents
create table post(id bigint auto_increment primary key, title varchar(255) not null, contents varchar(3000));

-- 연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key, author_id bigint not null, post_id bigint not null, foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 복합키를 이용한 연결(junction) 테이블
create table author_post_list(author_id bigint not null, post_id bigint not null, primary key(author_id, post_id) foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 회원가입 및 주소생성
insert into author(email, name, password) values('qwer@qwer.qwer', '김철수', 1234);
insert into address(country, city, street, author_id) values('kroea', 'seoul', 'sinlim', 3);

-- 글쓰기
-- 최초생성자
insert into post(title, contents) values('qwer', 'qwerqwer');
insert into author_post_list(author_id, post_id) values(2, 3);
-- 추후참여자
-- update
insert into author_post_list(author_id, post_id) values(1, 3);

-- 글 전체목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select쿼리 생성
select p.title, p.contents, a.name from post p inner join author_post_list apl on p.id=apl.post_id inner join author a on apl.author_id=a.id order by p.id;


select ol.id, p.name, od.product_quantity, od.product_price, (select sum(od.product_quantity * od.product_price) from order_list ol inner join order_detail od on ol.id=od.order_id where o.id=1 group by o.id) ;
