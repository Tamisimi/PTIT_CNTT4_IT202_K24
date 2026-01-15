create database if not exists social_trigger;
use social_trigger;

-- Bài 1:
create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

delimiter //
create trigger after_post_insert after insert on posts for each row
begin update users set post_count = post_count + 1 where user_id = new.user_id; end//

create trigger after_post_delete after delete on posts for each row
begin update users set post_count = post_count - 1 where user_id = old.user_id; end//
delimiter ;

insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');

-- Bài 2: 
create table likes (
    like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

delimiter //
create trigger after_like_insert after insert on likes for each row
begin update posts set like_count = like_count + 1 where post_id = new.post_id; end//

create trigger after_like_delete after delete on likes for each row
begin update posts set like_count = like_count - 1 where post_id = old.post_id; end//
delimiter ;

create view user_statistics as
select u.user_id, u.username, u.post_count, coalesce(sum(p.like_count), 0) as total_likes
from users u left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

-- Bài 3:
alter table likes add constraint unique_user_post unique (user_id, post_id);

delimiter //
create trigger before_like_insert before insert on likes for each row
begin
    declare owner int;
    select user_id into owner from posts where post_id = new.post_id;
    if owner = new.user_id then
        signal sqlstate '45000' set message_text = 'Không thể like bài của chính mình';
    end if;
end//

drop trigger if exists after_like_insert;
create trigger after_like_insert after insert on likes for each row
begin update posts set like_count = like_count + 1 where post_id = new.post_id; end//

drop trigger after_like_delete;
create trigger after_like_delete after delete on likes for each row
begin update posts set like_count = like_count - 1 where post_id = old.post_id; end//

create trigger after_like_update after update on likes for each row
begin
    if new.post_id <> old.post_id then
        update posts set like_count = like_count - 1 where post_id = old.post_id;
        update posts set like_count = like_count + 1 where post_id = new.post_id;
    end if;
end//
delimiter ;

-- Bài 4:
create table post_history (
    history_id int primary key auto_increment,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
);

delimiter //
create trigger before_post_update before update on posts for each row
begin
    if new.content <> old.content or (new.content is null <> old.content is null) then
        insert into post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        values (old.post_id, old.content, new.content, now(), old.user_id);
    end if;
end//
delimiter ;

-- Bài 5:
delimiter //
create procedure add_user(in p_username varchar(50), in p_email varchar(100), in p_created_at date)
begin
    insert into users (username, email, created_at) values (p_username, p_email, p_created_at);
end//

create trigger before_user_insert before insert on users for each row
begin
    if new.email not like '%@%.%' then
        signal sqlstate '45000' set message_text = 'Email không hợp lệ';
    end if;
    if new.username regexp '[^a-zA-Z0-9_]' then
        signal sqlstate '45000' set message_text = 'Username chỉ được chứa chữ,số,_';
    end if;
end//
delimiter ;

-- Bài 6:
create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending','accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);

delimiter //
create trigger after_friendship_insert after insert on friendships for each row
begin if new.status = 'accepted' then update users set follower_count = follower_count + 1 where user_id = new.followee_id; end if; end//

create trigger after_friendship_delete after delete on friendships for each row
begin if old.status = 'accepted' then update users set follower_count = follower_count - 1 where user_id = old.followee_id; end if; end//

create trigger after_friendship_update after update on friendships for each row
begin
    if old.status = 'pending' and new.status = 'accepted' then update users set follower_count = follower_count + 1 where user_id = new.followee_id; end if;
    if old.status = 'accepted' and new.status = 'pending' then update users set follower_count = follower_count - 1 where user_id = new.followee_id; end if;
end//

create procedure follow_user(in p_follower int, in p_followee int, in p_status enum('pending','accepted'))
begin
    if p_follower = p_followee then signal sqlstate '45000' set message_text = 'Không thể follow chính mình'; end if;
    if exists(select 1 from friendships where follower_id = p_follower and followee_id = p_followee) then
        if p_status is null then delete from friendships where follower_id = p_follower and followee_id = p_followee;
        else update friendships set status = p_status where follower_id = p_follower and followee_id = p_followee; end if;
    elseif p_status is not null then
        insert into friendships (follower_id, followee_id, status) values (p_follower, p_followee, p_status);
    end if;
end//

create view user_profile as
select u.user_id, u.username, u.follower_count, u.post_count,
       coalesce(sum(p.like_count),0) as total_likes,
       (select group_concat(content order by created_at desc separator ' | ') 
        from posts where user_id = u.user_id limit 3) as recent_posts
from users u left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;
delimiter ;
