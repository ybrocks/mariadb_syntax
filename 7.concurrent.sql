-- read uncommited : 커밋되지 않은 데이터 read 가능 -> dirty read 문제 발생
-- 실습절차
-- 1)워크벤치에서 auto_commit 해제. update실행. commit하지않음.(transaction1)
-- 2)터미널을 열어 select했을때 위 update변경사항이 읽히는지 확인(transaction2)
-- 결론 : mariadb는 기본이 repeatable read 이므로 dirty read 발생x

-- read committed : 커밋한 데이터만 read 가능 -> phantom read발생(또는 non-repeatable read)
-- 실습절차
-- 1)워크벤치에서 아래 코드 실행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
commit;
-- 2)터미널을 열어 아래 코드 실행
insert into author(email) values('ggggg@naver.com');

-- repeatable read : 읽기의 일관성 보장 -> lost update문제 발생 -> 배타lock(배타적잠금)으로 해결
-- lost update문제 발생하는 상황
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 2);
    select post_count into count from author where id=2;
    do sleep(15);
    update author set post_count=count+1 where id=2;
    commit;
end //
DELIMITER ;
call concurrent_test1();
-- 터미널에서는 아래코드 실행
select post_count from author where id=2;
-- 배타락(for update)을 통해 lost update문제를 해결한 상황
-- select for update를 하게되면 트랜잭션이 실행되는동안 lock이 걸리고, 트랜잭션이 종료된 후 lock이 풀림
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 2);
    select post_count into count from author where id=2 for update;
    do sleep(15);
    update author set post_count=count+1 where id=2;
    commit;
end //
DELIMITER ;
call concurrent_test2();
-- 터미널에서는 아래코드 실행
select post_count from author where id=2 for update;
-- serializable : 모든 트랜잭션 순차적 실행 -> 동시성문제없음(성능저하)