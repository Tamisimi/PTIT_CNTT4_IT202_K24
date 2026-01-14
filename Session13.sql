create database social_trigger;
use social_trigger;

-- Bài 1
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
('alice',   'alice@example.com',   '2025-01-01'),
('bob',     'bob@example.com',     '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

delimiter //

create trigger after_post_insert
after insert on posts
for each row
begin
    update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end //

create trigger after_post_delete
after delete on posts
for each row
begin
    update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end //

delimiter ;

insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!',        '2025-01-10 10:00:00'),
(1, 'second post by alice',           '2025-01-10 12:00:00'),
(2, 'bob first post',                 '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts',       '2025-01-12 15:00:00');

select * from users;

delete from posts where post_id = 2;

select * from users;

select * from posts;

-- Bài 2
create table likes (
    like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

delimiter //
create trigger after_like_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end //
delimiter ;

delimiter //
create trigger after_like_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end //
delimiter ;

create view user_statistics as
select 
    u.user_id,
    u.username,
    u.post_count,
    coalesce(sum(p.like_count), 0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

select * from posts;
select * from user_statistics;

insert into likes (user_id, post_id, liked_at) values (2, 4, now());

select * from posts where post_id = 4;
select * from user_statistics;

delete from likes 
where user_id = 3 and post_id = 4;

select * from posts where post_id = 4;
select * from user_statistics;

-- Bài 3

alter table likes
add constraint unique_user_post unique (user_id, post_id);

delimiter //
create trigger before_like_insert
before insert on likes
for each row
begin
    declare post_owner_id int;
    
    select user_id into post_owner_id
    from posts
    where post_id = new.post_id;
    
    if post_owner_id = new.user_id then
        signal sqlstate '45000'
        set message_text = 'Không thể like bài đăng của chính mình';
    end if;
end //
delimiter ;

drop trigger after_like_insert;

delimiter //
create trigger after_like_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end //
delimiter ;

drop trigger  after_like_delete;

delimiter //
create trigger after_like_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end //
delimiter ;

delimiter //
create trigger after_like_update
after update on likes
for each row
begin
    if new.post_id <> old.post_id then
        update posts
        set like_count = like_count - 1
        where post_id = old.post_id;
        
        update posts
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end //
delimiter ;


--  Thử like 
insert into likes (user_id, post_id, liked_at) 
values (1, 1, now());

--  Thêm like
insert into likes (user_id, post_id, liked_at) 
values (2, 4, now());

select * from posts where post_id = 4;
select * from user_statistics;

--  UPDATE like
update likes
set post_id = 1
where user_id = 2 and post_id = 4;

select * from posts where post_id in (1, 4);
select * from user_statistics;

--  Xóa một like
delete from likes
where user_id = 2 and post_id = 1;

select * from posts where post_id = 1;
select * from user_statistics;

-- Xem lại toàn bộ likes 
select * from likes order by like_id;


-- Bài 4
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
create trigger before_post_update
before update on posts
for each row
begin
    if new.content <> old.content or (new.content is null and old.content is not null) or (new.content is not null and old.content is null) then
        insert into post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        ) values (
            old.post_id,
            old.content,
            new.content,
            now(),
            old.user_id 
        );
    end if;
end //
delimiter ;


--Cập nhật một số bài đăng
update posts 
set content = 'hello world from alice! (edited)'
where post_id = 1;

update posts 
set content = 'bob first post - updated version'
where post_id = 3;

update posts 
set content = 'charlie sharing thoughts... revised!'
where post_id = 4;

-- Xem lịch sử chỉnh sửa
select 
    h.history_id,
    h.post_id,
    u.username as author,
    h.old_content,
    h.new_content,
    h.changed_at,
    h.changed_by_user_id
from post_history h
join users u on h.changed_by_user_id = u.user_id
order by h.changed_at desc;

-- Kiểm tra like_count hoạt động 
insert into likes (user_id, post_id, liked_at) 
values (3, 1, now());

-- Xem like_count của post 1
select post_id, content, like_count 
from posts 
where post_id = 1;

-- Xem tổng thống kê
select * from user_statistics;

-- Kiểm tra lịch sử của post 4 
select * from post_history where post_id = 4;
select * from likes where post_id = 4;


-- Bài 5
delimiter //
create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end //
delimiter ;

delimiter //
create trigger before_user_insert
before insert on users
for each row
begin
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'Email không hợp lệ: phải chứa @ và . (ví dụ: user@example.com)';
    end if;

    if new.username regexp '[^a-zA-Z0-9_]' then
        signal sqlstate '45000'
        set message_text = 'Username không hợp lệ: chỉ được chứa chữ cái, số và dấu gạch dưới (_)';
    end if;
end //
delimiter ;


--Thêm user
call add_user('david', 'david123@example.com', '2026-01-15');
call add_user('eva_1990', 'eva@example.vn', '2026-01-16');

--thêm user và email không hợp lệ
call add_user('frank', 'frank@invalid', '2026-01-17');        
call add_user('grace', 'grace@.com', '2026-01-17');            

select * from users;

-- Bài 6
create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);

-- Trigger AFTER INSERT trên friendships: tăng follower_count của followee khi status = 'accepted'
delimiter //
create trigger after_friendship_insert
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end //
delimiter ;

-- Trigger AFTER DELETE trên friendships: giảm follower_count của followee nếu trước đó là 'accepted'
delimiter //
create trigger after_friendship_delete
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end //
delimiter ;

-- Trigger AFTER UPDATE: xử lý khi thay đổi status (pending → accepted hoặc ngược lại)
delimiter //
create trigger after_friendship_update
after update on friendships
for each row
begin
    -- Nếu từ pending → accepted: tăng follower_count
    if old.status = 'pending' and new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
    
    -- Nếu từ accepted → pending: giảm follower_count
    if old.status = 'accepted' and new.status = 'pending' then
        update users
        set follower_count = follower_count - 1
        where user_id = new.followee_id;
    end if;
end //
delimiter ;

-- Stored Procedure follow_user: xử lý follow/unfollow an toàn
delimiter //
create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending', 'accepted')
)
begin
    -- Không cho tự follow chính mình
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'Không thể follow chính mình';
    end if;

    -- Kiểm tra xem đã tồn tại quan hệ chưa
    if exists (
        select 1 
        from friendships 
        where follower_id = p_follower_id 
          and followee_id = p_followee_id
    ) then
        -- Nếu đã tồn tại → cập nhật status
        if p_status is null then
            delete from friendships 
            where follower_id = p_follower_id 
              and followee_id = p_followee_id;
        else
            update friendships 
            set status = p_status
            where follower_id = p_follower_id 
              and followee_id = p_followee_id;
        end if;
    else
        -- Nếu chưa tồn tại → insert mới 
        if p_status is not null then
            insert into friendships (follower_id, followee_id, status)
            values (p_follower_id, p_followee_id, p_status);
        end if;
    end if;
end //
delimiter ;

-- Tạo View user_profile
create view user_profile as
select 
    u.user_id,
    u.username,
    u.email,
    u.created_at,
    u.follower_count,
    u.post_count,
    coalesce(sum(p.like_count), 0) as total_likes,
    (select group_concat(content order by created_at desc separator ' | ')
     from posts 
     where user_id = u.user_id 
     limit 3) as recent_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.email, u.created_at, u.follower_count, u.post_count;


call follow_user(1, 2, 'accepted');
call follow_user(2, 3, 'pending');
call follow_user(3, 1, 'accepted');

-- Kiểm tra follower_count sau khi follow
select user_id, username, follower_count from users;

--chấp nhận follow pending
update friendships 
set status = 'accepted' 
where follower_id = 2 and followee_id = 3;

-- Kiểm tra follower_count
select user_id, username, follower_count from users;

--  Unfollow
call follow_user(3, 1, null);

-- Kiểm tra
select user_id, username, follower_count from users;

-- Xem profile chi tiết
select 
    user_id,
    username,
    follower_count,
    post_count,
    total_likes,
    recent_posts
from user_profile
order by follower_count desc;
