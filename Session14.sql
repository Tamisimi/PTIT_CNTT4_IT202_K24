create database if not exists social_network;

use social_network;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null unique,
    posts_count int default 0,
    following_count int default 0,
    followers_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    likes_count int default 0,
    comments_count int default 0,
    foreign key (user_id) references users(user_id)
);

create table likes (
    like_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id),
    unique key unique_like (post_id, user_id)
);

create table followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followed_id) references users(user_id) on delete cascade
);

create table comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

create table delete_log (
    log_id int primary key auto_increment,
    post_id int not null,
    deleted_at datetime default current_timestamp,
    deleted_by int not null,
    foreign key (deleted_by) references users(user_id)
);

create table friend_requests (
    request_id int primary key auto_increment,
    from_user_id int not null,
    to_user_id int not null,
    status enum('pending', 'accepted', 'rejected') default 'pending',
    created_at datetime default current_timestamp,
    foreign key (from_user_id) references users(user_id),
    foreign key (to_user_id) references users(user_id),
    unique key unique_request (from_user_id, to_user_id)
);

create table friends (
    user_id int not null,
    friend_id int not null,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);

-- Bai 1: Dang bai viet moi
insert into users (username) values 
('nguyenvana'),
('tranthingoc'),
('lehoangnam'),
('phamthihuong'),
('hoangminhduc');

insert into posts (user_id, content) values 
(1, 'Chào buổi sáng mọi người! '),
(3, 'Cuối tuần này đi Đà Lạt chơi nha mọi người ơi! '),
(2, 'Hôm nay trời đẹp quá, đi cafe thôi nào! ');

start transaction;
insert into posts (user_id, content) 
values (4, 'Mới mua được đôi giày mới thích quá đi! 👟');
update users 
set posts_count = posts_count + 1 
where user_id = 4;
commit;

-- Bai 2: Like bai viet
start transaction;
insert into likes (post_id, user_id) 
values (2, 1);
update posts 
set likes_count = likes_count + 1 
where post_id = 2;
commit;

-- Bai 3: Theo doi nguoi dung (Stored Procedure)
delimiter //

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare user_exists int default 0;
    declare already_follows int default 0;
    
    start transaction;
    
    select count(*) into user_exists 
    from users where user_id = p_follower_id;
    if user_exists = 0 then
        signal sqlstate '45000' set message_text = 'Người theo dõi không tồn tại!';
        rollback;
        leave;
    end if;
    
    select count(*) into user_exists 
    from users where user_id = p_followed_id;
    if user_exists = 0 then
        signal sqlstate '45000' set message_text = 'Người được theo dõi không tồn tại!';
        rollback;
        leave;
    end if;
    
    if p_follower_id = p_followed_id then
        signal sqlstate '45000' set message_text = 'Không thể tự theo dõi chính mình!';
        rollback;
        leave;
    end if;
    
    select count(*) into already_follows 
    from followers 
    where follower_id = p_follower_id and followed_id = p_followed_id;
    if already_follows > 0 then
        signal sqlstate '45000' set message_text = 'Bạn đã theo dõi người dùng này rồi!';
        rollback;
        leave;
    end if;
    
    insert into followers (follower_id, followed_id) 
    values (p_follower_id, p_followed_id);
    
    update users 
    set following_count = following_count + 1 
    where user_id = p_follower_id;
    
    update users 
    set followers_count = followers_count + 1 
    where user_id = p_followed_id;
    
    commit;
end //

-- Bai 4: Dang binh luan voi SAVEPOINT
create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    declare post_exists int default 0;
    declare user_exists int default 0;
    
    start transaction;
    
    select count(*) into post_exists 
    from posts where post_id = p_post_id;
    
    if post_exists = 0 then
        signal sqlstate '45000' set message_text = 'Bai viet khong ton tai!';
        rollback;
        leave;
    end if;
    
    select count(*) into user_exists 
    from users where user_id = p_user_id;
    
    if user_exists = 0 then
        signal sqlstate '45000' set message_text = 'Nguoi dung khong ton tai!';
        rollback;
        leave;
    end if;
    
    insert into comments (post_id, user_id, content) 
    values (p_post_id, p_user_id, p_content);
    
    savepoint after_insert;
    
    update posts 
    set comments_count = comments_count + 1 
    where post_id = p_post_id;

    commit;   
end //
delimiter ;

call sp_post_comment(2, 1, 'Bài viết hay quá, mình cũng muốn đi Đà Lạt!');
select post_id, comments_count from posts where post_id = 2;
select * from comments where post_id = 2;


-- Bai 5:
delimiter //

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare user_exists int default 0;
    declare already_follows int default 0;
    
    start transaction;
    
    select count(*) into user_exists 
    from users where user_id = p_follower_id;
    if user_exists = 0 then
        signal sqlstate '45000' set message_text = 'Người theo dõi không tồn tại!';
        rollback;
        leave;
    end if;
    
    select count(*) into user_exists 
    from users where user_id = p_followed_id;
    if user_exists = 0 then
        signal sqlstate '45000' set message_text = 'Người được theo dõi không tồn tại!';
        rollback;
        leave;
    end if;
    
    if p_follower_id = p_followed_id then
        signal sqlstate '45000' set message_text = 'Không thể tự theo dõi chính mình!';
        rollback;
        leave;
    end if;
    
    select count(*) into already_follows 
    from followers 
    where follower_id = p_follower_id and followed_id = p_followed_id;
    if already_follows > 0 then
        signal sqlstate '45000' set message_text = 'Bạn đã theo dõi người dùng này rồi!';
        rollback;
        leave;
    end if;
    
    insert into followers (follower_id, followed_id) 
    values (p_follower_id, p_followed_id);
    
    update users 
    set following_count = following_count + 1 
    where user_id = p_follower_id;
    
    update users 
    set followers_count = followers_count + 1 
    where user_id = p_followed_id;
    
    commit;
end //

create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    declare post_exists int default 0;
    declare user_exists int default 0;
    
    start transaction;
    
    select count(*) into post_exists 
    from posts where post_id = p_post_id;
    
    if post_exists = 0 then
        signal sqlstate '45000' set message_text = 'Bài viết không tồn tại!';
        rollback;
        leave;
    end if;
    
    select count(*) into user_exists 
    from users where user_id = p_user_id;
    
    if user_exists = 0 then
        signal sqlstate '45000' set message_text = 'Người dùng không tồn tại!';
        rollback;
        leave;
    end if;
    
    insert into comments (post_id, user_id, content) 
    values (p_post_id, p_user_id, p_content);
    
    savepoint after_insert;
    
    update posts 
    set comments_count = comments_count + 1 
    where post_id = p_post_id;
    
    commit;
end //

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare post_owner int default 0;
    declare post_exists int default 0;
    
    start transaction;
    
    select count(*) into post_exists 
    from posts 
    where post_id = p_post_id;
    
    if post_exists = 0 then
        signal sqlstate '45000' set message_text = 'Bài viết không tồn tại!';
        rollback;
        leave;
    end if;
    
    select user_id into post_owner 
    from posts 
    where post_id = p_post_id;
    
    if post_owner != p_user_id then
        signal sqlstate '45000' set message_text = 'Chỉ chủ bài viết mới được xóa!';
        rollback;
        leave;
    end if;
    
    delete from likes 
    where post_id = p_post_id;
    
    delete from comments 
    where post_id = p_post_id;
    
    delete from posts 
    where post_id = p_post_id;
    
    update users 
    set posts_count = posts_count - 1 
    where user_id = p_user_id;
    
    insert into delete_log (post_id, deleted_by) 
    values (p_post_id, p_user_id);
    
    commit;
end //

delimiter ;

-- Bai 6:

delimiter //

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare req_from int;
    declare req_to int;
    declare req_status varchar(20);
    declare already_friends int default 0;

    set transaction isolation level repeatable read;
    start transaction;

    select from_user_id, to_user_id, status 
    into req_from, req_to, req_status
    from friend_requests 
    where request_id = p_request_id
    for update;

    if req_to != p_to_user_id then
        signal sqlstate '45000' set message_text = 'Ban khong phai nguoi nhan loi moi!';
        rollback;
        leave;
    end if;

    if req_status != 'pending' then
        signal sqlstate '45000' set message_text = 'Loi moi da duoc xu ly truoc do!';
        rollback;
        leave;
    end if;

    select count(*) into already_friends
    from friends
    where (user_id = req_from and friend_id = req_to)
       or (user_id = req_to and friend_id = req_from);

    if already_friends > 0 then
        signal sqlstate '45000' set message_text = 'Hai nguoi da la ban be!';
        rollback;
        leave;
    end if;

    insert into friends (user_id, friend_id) values (req_from, req_to);
    insert into friends (user_id, friend_id) values (req_to, req_from);

    update users set friends_count = friends_count + 1 where user_id = req_from;
    update users set friends_count = friends_count + 1 where user_id = req_to;

    update friend_requests 
    set status = 'accepted'
    where request_id = p_request_id;

    commit;
end //

delimiter ;

-- Du lieu mau de test 
insert into users (username) values 
('nguyenvana'), ('tranthingoc'), ('lehoangnam'), ('phamthihuong'), ('hoangminhduc');

-- Tao loi moi ket ban tu user 1 den user 2
insert into friend_requests (from_user_id, to_user_id) 
values (1, 2);

-- Chap nhan loi moi 
call sp_accept_friend_request(1, 2);

-- Kiem tra ket qua
select * from friends;
select user_id, username, friends_count from users where user_id in (1,2);
select * from friend_requests where request_id = 1;

-- Test loi: thu chap nhan lai 
call sp_accept_friend_request(1, 2);
