use social_network_pro;

-- Bài 1: get_user_posts
delimiter //
create procedure get_user_posts(in p_user_id int)
begin
    select 
        post_id,
        content,
        created_at
    from 
        posts
    where 
        user_id = p_user_id
    order by 
        created_at desc;
end //
delimiter ;

call get_user_posts(1);

drop procedure if exists get_user_posts;


-- Bài 2: CalculatePostLikes
delimiter //
create procedure CalculatePostLikes(
    in p_post_id int,
    out total_likes int
)
begin
    select count(*) into total_likes
    from likes
    where post_id = p_post_id;
end //
delimiter ;

set @total = 0;
call CalculatePostLikes(1, @total);
select @total as total_likes;

drop procedure if exists CalculatePostLikes;


-- Bài 3: CalculateBonusPoints
delimiter //
create procedure CalculateBonusPoints(
    in p_user_id int,
    inout p_bonus_points int
)
begin
    declare post_count int;

    select count(*) into post_count
    from posts
    where user_id = p_user_id;

    if post_count >= 20 then
        set p_bonus_points = p_bonus_points + 100;
    elseif post_count >= 10 then
        set p_bonus_points = p_bonus_points + 50;
    end if;
end //
delimiter ;

set @bonus = 100;
call CalculateBonusPoints(1, @bonus);
select @bonus as final_bonus_points;

drop procedure if exists CalculateBonusPoints;


-- Bài 4: CreatePostWithValidation
delimiter //
create procedure CreatePostWithValidation(
    in p_user_id int,
    in p_content text,
    out result_message varchar(255)
)
begin
    if char_length(p_content) < 5 then
        set result_message = 'Nội dung quá ngắn';
    else
        insert into posts (user_id, content, created_at)
        values (p_user_id, p_content, now());
        
        set result_message = 'Thêm bài viết thành công';
    end if;
end //
delimiter ;

set @msg1 = '';
call CreatePostWithValidation(1, 'abc', @msg1);
select @msg1 as result;

set @msg2 = '';
call CreatePostWithValidation(1, 'Đây là nội dung bài viết hợp lệ', @msg2);
select @msg2 as result;

drop procedure if exists CreatePostWithValidation;


-- Bài 5: CalculateUserActivityScore
delimiter //
create procedure CalculateUserActivityScore(
    in p_user_id int,
    out activity_score int,
    out activity_level varchar(50)
)
begin
    declare post_count int;
    declare comment_count int;
    declare received_like_count int;

    select count(*) into post_count
    from posts
    where user_id = p_user_id;

    select count(*) into comment_count
    from comments
    where user_id = p_user_id;

    select count(*) into received_like_count
    from likes l
    join posts p on l.post_id = p.post_id
    where p.user_id = p_user_id;

    set activity_score = (post_count * 10) + (comment_count * 5) + (received_like_count * 3);

    set activity_level = case
        when activity_score > 500 then 'Rất tích cực'
        when activity_score between 200 and 500 then 'Tích cực'
        else 'Bình thường'
    end;
end //
delimiter ;

set @score = 0;
set @level = '';
call CalculateUserActivityScore(1, @score, @level);

select 
    @score as activity_score,
    @level as activity_level;

drop procedure if exists CalculateUserActivityScore;


-- Bài 6: NotifyFriendsOnNewPost
delimiter //
create procedure NotifyFriendsOnNewPost(
    in p_user_id int,
    in p_content text
)
begin
    declare new_post_id int;
    declare user_full_name varchar(100);
    declare friend_id int;
    declare done int default false;

    declare cur cursor for
        select distinct case 
            when user_id = p_user_id then friend_id
            else user_id
        end as friend
        from friends
        where status = 'accepted'
        and (user_id = p_user_id or friend_id = p_user_id)
        and case 
            when user_id = p_user_id then friend_id
            else user_id
        end != p_user_id;

    declare continue handler for not found set done = true;

    select full_name into user_full_name
    from users
    where user_id = p_user_id;

    insert into posts (user_id, content, created_at)
    values (p_user_id, p_content, now());

    set new_post_id = last_insert_id();

    open cur;

    read_loop: loop
        fetch cur into friend_id;
        if done then
            leave read_loop;
        end if;

        insert into notifications (user_id, type, content, created_at)
        values (
            friend_id,
            'new_post',
            concat(user_full_name, ' đã đăng một bài viết mới'),
            now()
        );
    end loop;

    close cur;

    select 
        new_post_id as post_id,
        'Thêm bài viết và gửi thông báo thành công' as message;
end //
delimiter ;

call NotifyFriendsOnNewPost(1, 'Bài viết mới để test thông báo bạn bè!');

select 
    n.user_id,
    n.type,
    n.content,
    n.created_at
from 
    notifications n
where 
    n.type = 'new_post'
order by 
    n.created_at desc
limit 5;

drop procedure if exists NotifyFriendsOnNewPost;
