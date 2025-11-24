-- mariadb 서버에 터미널창에서 접속(db gui툴로 접속시 커넥션 객체 생성하여 연결)
mariadb -u root -p -- 엔터 후 비밀번호 별도 입력

-- 스키마(database) 생성
create database board;

-- 스키마 삭제
drop database board;

-- 스키마 목록조회
show databases;

-- 스키마 선택
use 스키마명;

-- 문자인코딩 세팅 조회(암기x)
show variables like 'character_set_server';

-- 문자인코딩 변경(암기x)
alter database board default character set = utf8mb4;

-- 테이블 목록조회
show tables;

-- spl문은 대문자가 관례이고 시스템에서 대소문자를 구분하지않음
-- 테이블명/컬럼명 등은 소문자가 관례이고, 대소문자 차이가 있음
-- 테이블 생성
create table author(id int primary key, name varchar(255), email varchar(255), password varchar(255));

-- 테이블 컬럼정보 조회
describe author;

-- 테이블 데이터 전체조회
select * from author;

-- 테이블 생성 명령문 조회(중요하지않음)
show create table author;

-- posts테이블 신규 생성(id, title, contents, author_id)
create table posts(id int, title varchar(255), contants varchar(255), author_id int, primary key(id), foreign key(author_id) references author(id));


-- 테이블 제약조건 조회
select * from information_schema.key_column_usage where table_name='posts';

-- 테이블 index조회
show index from posts(테이블명);

-- alter : 테이블의 구조를 변경
-- 테이블의 이름변경
alter talble posts rename post;
-- 테이블의 컬럼 추가
alter table post add column age int;
-- 테이블의 컬럼 삭제
alter table author drop column age;
-- 테이블의 컬럼명 변경
alter table post change column contents content varchar(255);
-- 테이블 컬럼의 타입과 제약조건 변경
alter table post modify column content varchar(3000);
alter table author modify column email varchar(255) not null unique;

-- 실습1. author테이블에 address컬럼을 추가(varchar255). name은 not null로 변경
alter table author add column address varchar(255);
alter table author modify column name varchar(255) not null;
-- 실습2. post테이블에 title을 not null로 변경. content는 contents로 이름 변경
alter table post modify column title varchar(255) not null;
alter table post change column content contents varchar(3000);

-- 테이블 삭제
drop table posts(테이블명);

-- 일련의 쿼리를 실행 시킬때 특정 쿼리에서 에러가 나지 않도록 if exists를 많이 사용
drop table if exists post(테이블명);

