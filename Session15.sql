create database session15;
use session15;
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE posts (
  post_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);
CREATE TABLE comments (
  comment_id INT PRIMARY KEY AUTO_INCREMENT,
  post_id INT,
  user_id INT,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id)
    REFERENCES posts(post_id)
    ON DELETE CASCADE,
  FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);
CREATE TABLE likes (
  user_id INT,
  post_id INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, post_id),
  FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,
  FOREIGN KEY (post_id)
    REFERENCES posts(post_id)
    ON DELETE CASCADE
);
CREATE TABLE friends (
  user_id INT,
  friend_id INT,
  status VARCHAR(20) DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, friend_id),
  CHECK (status IN ('pending', 'accepted')),
  FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,
  FOREIGN KEY (friend_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);

INSERT INTO users (username, password, email) VALUES
('alice', 'pass123', 'alice@gmail.com'),
('bob', 'pass123', 'bob@gmail.com'),
('charlie', 'pass123', 'charlie@gmail.com'),
('david', 'pass123', 'david@gmail.com'),
('emma', 'pass123', 'emma@gmail.com'),
('frank', 'pass123', 'frank@gmail.com'),
('grace', 'pass123', 'grace@gmail.com'),
('henry', 'pass123', 'henry@gmail.com');

INSERT INTO posts (user_id, content) VALUES
(1, 'Hello world!'),
(2, 'My first post'),
(3, 'Learning MySQL'),
(4, 'Good morning everyone'),
(5, 'I love programming'),
(6, 'Database design is fun'),
(7, 'SQL is powerful'),
(8, 'Nice to meet you all');

INSERT INTO comments (post_id, user_id, content) VALUES
(1, 2, 'Nice post!'),
(1, 3, 'Welcome!'),
(2, 1, 'Good luck'),
(3, 4, 'Keep learning'),
(4, 5, 'Good morning'),
(5, 6, 'Programming is awesome'),
(6, 7, 'I agree'),
(7, 8, 'Well said');

INSERT INTO likes (user_id, post_id) VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7);

INSERT INTO friends (user_id, friend_id, status) VALUES
(1, 2, 'accepted'),
(1, 3, 'pending'),
(2, 3, 'accepted'),
(2, 4, 'pending'),
(3, 5, 'accepted'),
(4, 6, 'pending'),
(5, 7, 'accepted'),
(6, 8, 'pending');

SELECT * FROM users;
SELECT * FROM posts;
SELECT * FROM comments;
SELECT * FROM likes;
SELECT * FROM friends;

-- bai 1 
create table user_log(
   log_id int auto_increment primary key, 
   user_id int , 
   action varchar(50), 
   log_time datetime default current_timestamp
);
delimiter //
create procedure sp_register_user(in p_username varchar(50), in p_password varchar(255), in  p_email varchar(100) )
begin 
   declare o_username varchar(50) ; 
   declare o_password varchar(255);
   declare o_email varchar(100);
   start transaction;
   if exists(select 1 from users where username = p_username) then 
   signal sqlstate "45000"
   set message_text = "User name khong duoc trung";
   end if ; 
   if exists(select 1 from users where email = p_email) then 
   signal sqlstate "45000"
   set message_text = "Email khong duoc trung";
   end if ; 
   insert into users(username, password, email)
   values 
      (p_username, p_password,p_email );
   commit ;   
end //

delimiter //
create trigger tg_after_register
after insert on users 
for each row 
begin 
    insert into user_log(user_id, action)
    values
      (new.user_id, "register");
end //
delimiter ;
call sp_register_user("alice", "12345","abc@gmail.com");
call sp_register_user("tiendeptrAI", "12345","abc@gmail.com");
select * from user_log;



-- bai 2 
create table post_log (
  log_id int primary key auto_increment,
  post_id int,
  user_id int,
  action varchar(50),
  log_time datetime default current_timestamp
);
delimiter $$

create procedure sp_create_post(
  in p_user_id int,
  in p_content text
)
begin
  if p_content is null or trim(p_content) = '' then
    signal sqlstate '45000'
    set message_text = 'content cannot be empty';
  else
    insert into posts(user_id, content)
    values (p_user_id, p_content);
  end if;
end$$
delimiter ;

delimiter $$
create trigger trg_after_insert_post
after insert on posts
for each row
begin
  insert into post_log(post_id, user_id, action)
  values (new.post_id, new.user_id, 'create post');
end$$

delimiter ;
call sp_create_post(1, 'today is a good day');
call sp_create_post(2, 'mysql stored procedure practice');
call sp_create_post(3, 'learning trigger is interesting');
call sp_create_post(4, 'database transaction coming next');
call sp_create_post(5, 'coding every day');
call sp_create_post(6, 'sql makes life easier');
select * from posts;
select * from post_log;
call sp_create_post(1, '');


-- bai 3 
-- Bai 03:
alter table posts
add column like_count int default 0;

delimiter $$
create trigger trg_like
after insert on likes
for each row
begin
  update posts set like_count = like_count + 1
  where post_id = new.post_id;
  insert into comments (post_id, user_id, content)
  values ( new.post_id, new.user_id, 'user liked' );
end$$
delimiter ;

delimiter $$
create trigger trg_unlike
after delete on likes
for each row
begin
  update posts
  set like_count = like_count - 1
  where post_id = old.post_id;
  insert into comments (post_id, user_id, content)
  values ( old.post_id, old.user_id, 'user unliked' );
end$$
delimiter ;

insert into likes (user_id, post_id) values (1, 3);
select post_id, like_count from posts where post_id = 3;
delete from likes where user_id = 1 and post_id = 3;
select post_id, like_count from posts where post_id = 3;
select post_id, user_id, content from comments;




-- bai 4
delimiter $$

create procedure sp_send_friend_request(
    in p_sender_id int,
    in p_receiver_id int
)
begin
    if p_sender_id = p_receiver_id then
        signal sqlstate '45000'
        set message_text = 'khong the tu gui loi moi ket ban';
    end if;

    if exists (
        select *
        from friends
        where user_id = p_sender_id
          and friend_id = p_receiver_id
    ) then
        signal sqlstate '45000'
        set message_text = 'loi moi ket ban da ton tai';
    end if;
    
    insert into friends(user_id, friend_id, status)
    values (p_sender_id, p_receiver_id, 'pending');

    select 'gui loi moi ket ban thanh cong' as message;
end$$

delimiter ;


drop trigger if exists trg_after_insert_friend;
delimiter $$

create trigger trg_after_insert_friend
after insert on friends
for each row
begin
    set @last_friend_request = concat(
        'user ',
        new.user_id,
        ' gui loi moi ket ban toi user ',
        new.friend_id
    );
end$$

delimiter ;

call sp_send_friend_request(2, 7);

select * from friends;
select @last_friend_request;
-- bai 5 
delimiter //
create trigger trg_accept_friend
after update on friends
for each row
begin
	if old.status = 'pending' and new.status = 'accepted' then
		if not exists (
			select 1 
            from friends
            where user_id = new.friend_id
            and friend_id = new.user_id
        ) then 
			insert into friends (user_id, friend_id, status)
            values (new.friend_id, new.user_id, 'accepted');
			end if;
     end if;   
end //
delimiter ;


-- bai 6 
-- procedure gửi lời mời kết bạn
delimiter //
create procedure sendfriendrequest(in p_user_id int, in p_friend_id int)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        select 'lỗi khi gửi lời mời! đã rollback.' as message;
    end;
    start transaction;
    if exists (
        select 1 from friends
        where (user_id = p_user_id and friend_id = p_friend_id)
           or (user_id = p_friend_id and friend_id = p_user_id)
    ) then
        signal sqlstate '45000' set message_text = 'quan hệ đã tồn tại';
    end if;
    insert into friends (user_id, friend_id, status)
    values (p_user_id, p_friend_id, 'pending');

    commit;
    select 'gửi lời mời thành công!' as message;
end //
delimiter ;

-- procedure cập nhật/xóa mối quan hệ
delimiter //
create procedure managefriendship(
    in p_user_id int,
    in p_friend_id int,
    in p_action varchar(20)
)
begin
    declare current_status varchar(20);
    declare exit handler for sqlexception
    begin
        rollback;
        select 'lỗi đã rollback!' as message;
    end;
    start transaction;
    select status into current_status
    from friends
    where (user_id = p_user_id and friend_id = p_friend_id)
       or (user_id = p_friend_id and friend_id = p_user_id)
    limit 1;
    if current_status is null then
        signal sqlstate '45000' set message_text = 'không tồn tại mối quan hệ!';
    end if;
    if p_action = 'accept' then
        if current_status = 'pending' then
            update friends
            set status = 'accepted'
            where (user_id = p_user_id and friend_id = p_friend_id)
               or (user_id = p_friend_id and friend_id = p_user_id);
        else
            signal sqlstate '45000' set message_text = 'chỉ accept khi pending';
        end if;
    elseif p_action = 'delete' then
        delete from friends
        where (user_id = p_user_id and friend_id = p_friend_id)
           or (user_id = p_friend_id and friend_id = p_user_id);
    else
        signal sqlstate '45000' set message_text = 'chỉ dùng accept hoặc delete';
    end if;
    commit;
    select concat('thao tác ', p_action, ' thành công!') as message;
end //
delimiter ;
-- demo
call sendfriendrequest(1, 4);
call managefriendship(4, 1, 'accept');
call managefriendship(1, 4, 'delete');
-- test lỗi
call managefriendship(1, 999, 'accept');


-- bai 7 
-- xoa comment va like truoc khi xoa post
delimiter $$
create trigger tr_before_delete_post
before delete on posts
for each row
begin
    delete from comments where post_id = old.post_id;
    delete from likes where post_id = old.post_id;
end$$
delimiter ;
-- sp xoa bai viet (chi chu bai moi duoc xoa)
delimiter $$
create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_count int default 0;
    start transaction;
    -- kiem tra bai viet co ton tai va dung chu bai khong
    select count(*) into v_count
    from posts
    where post_id = p_post_id
      and user_id = p_user_id;
    if v_count = 1 then
        -- xoa bai viet (trigger se tu dong xoa like, comment)
        delete from posts
        where post_id = p_post_id;
        commit;
        select 'xoa bai viet thanh cong' as message;
    else
        rollback;
        select 'khong co quyen xoa hoac bai viet khong ton tai' as message;
    end if;
end$$
delimiter ;
call sp_delete_post(1, 1);
call sp_delete_post(1, 2);


-- bai 8 

use session15;

delimiter $$

create procedure sp_delete_user (
    in p_user_id int
)
begin
    start transaction;

    delete from friends
    where user_id = p_user_id
       or friend_id = p_user_id;

    delete from likes
    where user_id = p_user_id;

    delete from comments
    where user_id = p_user_id;

    delete from posts
    where user_id = p_user_id;

    delete from users
    where user_id = p_user_id;

    commit;
end$$

delimiter ;

call sp_delete_user(1);

select * from users;
select * from posts;
select * from comments;
select * from likes;
select * from friends;
