DROP DATABASE IF EXISTS social_network_mini;

CREATE DATABASE social_network_mini
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE social_network_mini;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,             -- Mã người dùng (ID), tự động tăng
  username VARCHAR(50) UNIQUE NOT NULL,                -- Tên người dùng, duy nhất và không được rỗng
  full_name VARCHAR(100) NOT NULL,                     -- Họ tên đầy đủ
  gender ENUM('Nam', 'Nữ') NOT NULL DEFAULT 'Nam',    -- Giới tính, mặc định là 'Nam'
  email VARCHAR(100) UNIQUE NOT NULL,                  -- Email, duy nhất và không được rỗng
  password VARCHAR(100) NOT NULL,                      -- Mật khẩu, không được rỗng
  birthdate DATE,                                      -- Ngày sinh
  hometown VARCHAR(100),                               -- Quê quán
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP       -- Thời gian tạo tài khoản, mặc định là thời gian hiện tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE posts (
  post_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT posts_fk_users
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT comments_fk_posts
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
    ON DELETE CASCADE,
  CONSTRAINT comments_fk_users
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE likes (
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (post_id, user_id),
  CONSTRAINT likes_fk_posts
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
    ON DELETE CASCADE,
  CONSTRAINT likes_fk_users
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE friends (
  user_id INT NOT NULL,
  friend_id INT NOT NULL,
  status ENUM('pending','accepted','blocked') DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, friend_id),
  CONSTRAINT friends_fk_user1 FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT friends_fk_user2 FOREIGN KEY (friend_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT messages_fk_sender FOREIGN KEY (sender_id) REFERENCES users(user_id),
  CONSTRAINT messages_fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type VARCHAR(50),
  content VARCHAR(255),
  is_read BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT notifications_fk_users
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX posts_created_at_ix ON posts (created_at DESC);
CREATE INDEX messages_created_at_ix ON messages (created_at DESC);

-- ========= DATA =========

INSERT INTO users(username, full_name, gender, email, password, birthdate, hometown) VALUES
('an', 'Nguyễn Văn An', 'Nam', 'an@gmail.com', '123', '1990-01-01', 'Hà Nội'),
('binh', 'Trần Thị Bình', 'Nữ', 'binh@gmail.com', '123', '1992-02-15', 'TP.HCM'),
('chi', 'Lê Minh Chi', 'Nữ', 'chi@gmail.com', '123', '1991-03-10', 'Đà Nẵng'),
('duy', 'Phạm Quốc Duy', 'Nam', 'duy@gmail.com', '123', '1990-05-20', 'Hải Phòng'),
('ha', 'Vũ Thu Hà', 'Nữ', 'ha@gmail.com', '123', '1994-07-25', 'Hà Nội'),
('hieu', 'Đặng Hữu Hiếu', 'Nam', 'hieu@gmail.com', '123', '1993-11-30', 'TP.HCM'),
('hoa', 'Ngô Mai Hoa', 'Nữ', 'hoa@gmail.com', '123', '1995-04-18', 'Đà Nẵng'),
('khanh', 'Bùi Khánh Linh', 'Nữ', 'khanh@gmail.com', '123', '1992-09-12', 'TP.HCM'),
('lam', 'Hoàng Đức Lâm', 'Nam', 'lam@gmail.com', '123', '1991-10-05', 'Hà Nội'),
('linh', 'Phan Mỹ Linh', 'Nữ', 'linh@gmail.com', '123', '1994-06-22', 'Đà Nẵng'),
('minh', 'Nguyễn Minh', 'Nam', 'minh@gmail.com', '123', '1990-12-01', 'Hà Nội'),
('nam', 'Trần Quốc Nam', 'Nam', 'nam@gmail.com', '123', '1992-02-05', 'TP.HCM'),
('nga', 'Lý Thúy Nga', 'Nữ', 'nga@gmail.com', '123', '1993-08-16', 'Hà Nội'),
('nhan', 'Đỗ Hoàng Nhân', 'Nam', 'nhan@gmail.com', '123', '1991-04-20', 'TP.HCM'),
('phuong', 'Tạ Kim Phương', 'Nữ', 'phuong@gmail.com', '123', '1990-05-14', 'Đà Nẵng'),
('quang', 'Lê Quang', 'Nam', 'quang@gmail.com', '123', '1992-09-25', 'Hà Nội'),
('son', 'Nguyễn Thành Sơn', 'Nam', 'son@gmail.com', '123', '1994-03-19', 'TP.HCM'),
('thao', 'Trần Thảo', 'Nữ', 'thao@gmail.com', '123', '1993-11-07', 'Đà Nẵng'),
('trang', 'Phạm Thu Trang', 'Nữ', 'trang@gmail.com', '123', '1995-06-02', 'Hà Nội'),
('tuan', 'Đinh Minh Tuấn', 'Nam', 'tuan@gmail.com', '123', '1990-07-30', 'TP.HCM');



INSERT INTO posts(user_id, content) VALUES
(1,'Chào mọi người! Hôm nay mình bắt đầu học MySQL.'),
(2,'Ai có tài liệu SQL cơ bản cho người mới không?'),
(3,'Mình đang luyện JOIN, hơi rối nhưng vui.'),
(4,'Thiết kế ERD xong thấy dữ liệu rõ ràng hơn hẳn.'),
(5,'Học chuẩn hoá (normalization) giúp tránh trùng dữ liệu.'),
(6,'Tối ưu truy vấn: nhớ tạo index đúng chỗ.'),
(7,'Mình đang làm mini mạng xã hội bằng MySQL.'),
(8,'Bạn nào biết khác nhau giữa InnoDB và MyISAM không?'),
(9,'Uống cà phê rồi mới code tiếp thôi ☕'),
(10,'Hôm nay học GROUP BY và HAVING.'),
(11,'Subquery khó nhưng dùng quen sẽ “đã”.'),
(12,'Mình vừa tạo VIEW để xem thống kê bài viết.'),
(13,'Trigger dùng để tự tạo thông báo khi có comment.'),
(14,'Transaction quan trọng để tránh lỗi dữ liệu giữa chừng.'),
(15,'ACID là nền tảng của hệ quản trị CSDL.'),
(16,'Mình đang luyện câu truy vấn top bài nhiều like nhất.'),
(17,'Có ai muốn cùng luyện SQL mỗi ngày không?'),
(18,'Tạo bảng có khoá ngoại giúp dữ liệu “sạch” hơn.'),
(19,'Đang tìm cách sinh dữ liệu giả để test hiệu năng.'),
(20,'Backup database thường xuyên nhé mọi người!'),
(1,'Bài 2: hôm nay mình luyện insert dữ liệu tiếng Việt.'),
(2,'Lưu tiếng Việt nhớ dùng utf8mb4.'),
(3,'Đừng quên kiểm tra collation nữa.'),
(4,'Query phức tạp thì chia nhỏ ra debug dễ hơn.'),
(5,'Viết query xong nhớ EXPLAIN để xem plan.'),
(6,'Index nhiều quá cũng không tốt, phải cân bằng.'),
(7,'Mình thêm chức năng kết bạn: pending/accepted.'),
(8,'Nhắn tin (messages) cũng là quan hệ 2 user.'),
(9,'Notification giúp mô phỏng giống Facebook.'),
(10,'Cuối tuần mình tổng hợp 50 bài tập SQL.');

INSERT INTO comments(post_id, user_id, content) VALUES
(1,2,'Ủng hộ bạn! Cố lên nhé.'),
(1,3,'Hay đó, mình cũng đang học.'),
(2,4,'Mình có tài liệu, bạn cần phần nào?'),
(2,5,'Bạn tìm “SQL basics + MySQL” là ra nhiều lắm.'),
(3,6,'JOIN đầu khó, sau quen sẽ dễ.'),
(3,7,'Bạn thử vẽ bảng ra giấy cho dễ hình dung.'),
(4,8,'ERD đúng là cứu cánh.'),
(5,9,'Chuẩn hoá giúp giảm lỗi cập nhật dữ liệu.'),
(6,10,'Index đặt đúng cột hay lọc/ join là ổn.'),
(7,11,'Mini mạng xã hội nghe thú vị đấy!'),
(8,12,'InnoDB hỗ trợ transaction và FK tốt hơn.'),
(9,13,'Cà phê là chân ái ☕'),
(10,14,'GROUP BY nhớ cẩn thận HAVING nhé.'),
(11,15,'Subquery dùng vừa đủ thôi kẻo chậm.'),
(12,16,'VIEW tiện để tái sử dụng truy vấn.'),
(13,17,'Trigger nhớ tránh loop vô hạn.'),
(14,18,'Transaction giúp rollback khi lỗi.'),
(15,19,'ACID rất quan trọng cho dữ liệu tiền bạc.'),
(16,20,'Top bài nhiều like: GROUP BY + ORDER BY.'),
(20,2,'Backup xong nhớ test restore nữa.'),
(21,3,'Tiếng Việt ok khi dùng utf8mb4.'),
(22,4,'Chuẩn rồi, mình từng bị lỗi mất dấu.'),
(23,5,'Collation ảnh hưởng sắp xếp và so sánh.'),
(24,6,'Chia nhỏ query là cách debug tốt.'),
(25,7,'EXPLAIN giúp hiểu vì sao query chậm.'),
(26,8,'Index dư thừa sẽ làm insert/update chậm.'),
(27,9,'Pending/accepted giống Facebook đó.'),
(28,10,'Messages thì nên index theo created_at.'),
(29,11,'Notification nhìn “pro” hẳn.'),
(30,12,'50 bài tập SQL nghe hấp dẫn!'),
(2,13,'Bạn thử dùng sách Murach cũng ổn.'),
(3,14,'JOIN nhiều bảng thì đặt alias cho gọn.'),
(4,15,'Ràng buộc FK giúp tránh dữ liệu mồ côi.'),
(5,16,'Bạn nhớ thêm UNIQUE cho like (post_id,user_id).'),
(6,17,'Đúng rồi, mình cũng làm vậy.'),
(7,18,'Khi cần hiệu năng, cân nhắc denormalize một chút.'),
(8,19,'MySQL 8 có nhiều cải tiến optimizer.'),
(9,20,'Chúc bạn học tốt!');

INSERT INTO likes(post_id, user_id) VALUES
(1,2),(1,3),(1,4),
(2,1),(2,5),(2,6),
(3,7),(3,8),
(4,9),(4,10),
(5,11),(5,12),
(6,13),(6,14),
(7,15),(7,16),
(8,17),(8,18),
(9,19),(9,20),
(10,2),(11,3),(12,4),(13,5),(14,6);

INSERT INTO friends(user_id, friend_id, status) VALUES
(1,2,'accepted'),
(1,3,'accepted'),
(2,4,'accepted'),
(3,5,'pending'),
(4,6,'accepted'),
(5,7,'blocked'),
(6,8,'accepted'),
(7,9,'accepted'),
(8,10,'accepted'),
(9,11,'pending');

INSERT INTO messages(sender_id, receiver_id, content) VALUES
(1,2,'Chào Bình, hôm nay bạn học tới đâu rồi?'),
(2,1,'Mình đang luyện JOIN, hơi chóng mặt 😅'),
(3,4,'Duy ơi, share mình tài liệu MySQL 8 nhé.'),
(4,3,'Ok Chi, để mình gửi link sau.'),
(5,6,'Hiếu ơi, tối nay học transaction không?'),
(6,5,'Ok Hà, 8h nhé!');

INSERT INTO notifications(user_id, type, content) VALUES
(1,'like','Bình đã thích bài viết của bạn.'),
(1,'comment','Chi đã bình luận bài viết của bạn.'),
(2,'friend','An đã gửi lời mời kết bạn.'),
(3,'message','Bạn có tin nhắn mới từ Duy.'),
(4,'like','Hà đã thích bài viết của bạn.'),
(5,'comment','Hiếu đã bình luận bài viết của bạn.'),
(6,'friend','Hoa đã chấp nhận lời mời kết bạn.');

INSERT INTO posts(user_id, content) VALUES
(11,'Hôm nay mình tìm hiểu về Stored Procedure trong MySQL.'),
(12,'Phân quyền user trong MySQL cũng quan trọng không kém.'),
(13,'Ai đang dùng MySQL Workbench giống mình không?'),
(14,'Mình thử import database lớn thấy hơi chậm.'),
(15,'Backup bằng mysqldump khá tiện.'),
(16,'Replication giúp tăng khả năng chịu tải.'),
(17,'MySQL và PostgreSQL khác nhau khá nhiều đấy.'),
(18,'Mình đang học tối ưu query cho bảng lớn.'),
(19,'Partition table có ai dùng chưa?'),
(20,'Học database cần kiên nhẫn thật sự.');

INSERT INTO comments(post_id, user_id, content) VALUES
(31,12,'Stored Procedure dùng tốt cho logic phức tạp.'),
(31,13,'Nhưng lạm dụng thì khó bảo trì lắm.'),
(32,14,'Phân quyền đúng giúp tăng bảo mật.'),
(33,15,'Workbench tiện cho người mới.'),
(34,16,'Import file lớn nhớ tắt index trước.'),
(35,17,'mysqldump kết hợp cron là ổn áp.'),
(36,18,'Replication dùng cho hệ thống lớn.'),
(37,19,'PostgreSQL mạnh về chuẩn SQL.'),
(38,20,'Query bảng lớn cần index hợp lý.'),
(39,1,'Partition phù hợp cho dữ liệu theo thời gian.');

INSERT INTO likes(post_id, user_id) VALUES
(31,1),(31,2),(31,3),
(32,4),(32,5),
(33,6),(33,7),(33,8),
(34,9),(34,10),
(35,11),(35,12),
(36,13),(36,14),
(37,15),(37,16),
(38,17),(38,18),
(39,19),(39,20),
(40,1),(40,2),(40,3);
INSERT INTO friends(user_id, friend_id, status) VALUES
(10,12,'accepted'),
(11,13,'accepted'),
(12,14,'pending'),
(13,15,'accepted'),
(14,16,'accepted'),
(15,17,'blocked'),
(16,18,'accepted'),
(17,19,'accepted'),
(18,20,'pending');

INSERT INTO notifications(user_id, type, content) VALUES
(7,'comment','Bạn có bình luận mới.'),
(8,'like','Bài viết của bạn có lượt thích mới.'),
(9,'message','Bạn có tin nhắn mới.'),
(10,'friend','Bạn có lời mời kết bạn.'),
(11,'like','Một người đã thích bài viết của bạn.'),
(12,'comment','Có người vừa bình luận bài viết của bạn.');
INSERT INTO posts (user_id, content) VALUES
(3,'Hôm nay mình ngồi debug SQL gần 3 tiếng 😵'),
(7,'JOIN nhiều bảng quá nhìn hoa cả mắt.'),
(7,'Làm project CSDL mới thấy thiết kế ban đầu quan trọng thế nào.'),
(12,'Mình vừa thử dùng EXPLAIN, thấy query chạy khác hẳn.'),
(1,'Tối nay mình luyện thêm GROUP BY + HAVING.'),
(1,'Có ai từng quên index rồi query chậm kinh khủng chưa?'),
(15,'Backup dữ liệu mà quên test restore là toang 😅'),
(9,'Mình đang test feed bài viết giống Facebook.'),
(9,'Post này chỉ để test notification.'),
(18,'Partition table có vẻ hợp với log hệ thống.'),
(4,'FK giúp dữ liệu sạch hơn nhưng insert hơi chậm.'),
(6,'Index nhiều quá cũng không hẳn là tốt.'),
(6,'Mình vừa xoá bớt index thấy insert nhanh hơn.'),
(20,'Học database cần kiên nhẫn thật sự.');
INSERT INTO comments (post_id, user_id, content) VALUES
(41,5,'Nghe quen ghê, mình cũng từng vậy.'),
(41,8,'Debug SQL mệt nhất là logic sai.'),
(41,10,'Cố lên bạn ơi!'),

(42,3,'JOIN nhiều bảng nhớ đặt alias cho gọn.'),
(42,11,'Thiếu index là chậm liền.'),

(43,2,'Thiết kế sai từ đầu là sửa rất mệt.'),
(43,6,'Chuẩn luôn, mình từng làm lại cả schema.'),

(44,4,'EXPLAIN nhìn execution plan khá rõ.'),
(44,7,'MySQL 8 tối ưu tốt hơn bản cũ nhiều.'),
(44,9,'Xem rows estimate là biết có ổn không.'),

(46,12,'GROUP BY + HAVING dễ nhầm lắm.'),

(47,14,'Index quên tạo là query lag liền.'),

(48,16,'Feed mà có notification nhìn chuyên nghiệp hơn.'),
(48,17,'Làm xong phần này là demo được rồi.'),

(49,1,'Post test nhưng nhìn giống thật ghê.'),

(50,19,'Partition dùng cho dữ liệu theo thời gian là hợp lý.'),

(52,3,'FK tăng an toàn dữ liệu, chậm chút cũng đáng.'),

(53,5,'Index dư thừa làm insert/update chậm thật.'),

(54,7,'Database đúng là càng học càng sâu.');

INSERT INTO likes (post_id, user_id) VALUES
(41,2),(41,4),(41,7),(41,9),
(42,1),
(43,5),(43,8),
(44,6),(44,10),(44,11),(44,12),
(46,3),
(47,15),(47,16),
(48,18),(48,19),(48,20),
(49,2),
(50,4),(50,6),
(52,7),
(53,8),(53,9),(53,10);
INSERT INTO messages (sender_id, receiver_id, content) VALUES
(3,7,'Post của bạn nhìn giống dữ liệu thật ghê.'),
(7,3,'Ừ, mình cố tình thêm không đều đó.'),
(1,6,'Index nhiều quá có nên xoá bớt không?'),
(6,1,'Xem EXPLAIN rồi quyết định.'),
(12,9,'Feed chạy ổn chưa?'),
(9,12,'Ổn rồi, chuẩn bị demo.');
INSERT INTO posts (user_id, content) VALUES
(1,'Spam nhẹ bài thứ 3 trong ngày 😅'),
(1,'Lại là mình, test feed xem sao.'),
(1,'Ai bảo làm mạng xã hội là dễ đâu.'),

(5,'Hôm nay mình chỉ ngồi đọc tài liệu DB.'),
(8,'Index composite dùng sai thứ tự là coi như bỏ.'),

(11,'Stored Procedure đôi khi khó debug thật.'),
(11,'Nhưng dùng quen thì khá tiện.'),

(14,'Import database lớn nên chia nhỏ file.'),

(17,'PostgreSQL và MySQL mỗi thằng mạnh một kiểu.'),

(19,'Log table mà không partition là rất mệt.'),

(20,'Cuối kỳ ai cũng vật vã với đồ án 😭');
INSERT INTO comments (post_id, user_id, content) VALUES
-- Post 55 (spam của user 1) rất nhiều comment
(55,2,'Bạn đăng nhiều ghê 😂'),
(55,3,'Feed toàn thấy bài của bạn.'),
(55,4,'Spam nhẹ nhưng nội dung ổn.'),
(55,6,'Test dữ liệu mà nhìn giống thật ghê.'),

(56,7,'Bài này cũng thấy lúc nãy rồi.'),
(56,8,'Feed hoạt động ổn là được.'),

-- Post 57 gần như không ai quan tâm
(57,9,'Lướt ngang qua 😅'),

-- Post 59 có tranh luận
(59,10,'Composite index rất hay bị hiểu sai.'),
(59,11,'Đúng rồi, thứ tự cột rất quan trọng.'),
(59,12,'Sai thứ tự là optimizer không dùng.'),

-- Post 60 ít comment
(60,13,'Procedure khó debug thật.'),

-- Post 61 nhiều ý kiến
(61,14,'Import file lớn hay bị timeout.'),
(61,15,'Nên tắt FK + index trước.'),
(61,16,'Import xong bật lại là ổn.'),

-- Post 63
(63,17,'So sánh DBMS đọc rất mở mang.'),

-- Post 65
(65,18,'Log mà không partition là query rất chậm.');

INSERT INTO likes (post_id, user_id) VALUES
-- Post cực hot
(55,2),(55,3),(55,4),(55,5),(55,6),(55,7),(55,8),

-- Post trung bình
(56,1),(56,9),(56,10),

-- Post gần như chìm
(57,11),

-- Post có tranh luận
(59,12),(59,13),(59,14),(59,15),

-- Một vài like lẻ
(61,16),
(63,17),
(65,18),(65,19);

INSERT INTO messages (sender_id, receiver_id, content) VALUES
(2,1,'Feed toàn thấy bài của bạn luôn 😆'),
(1,2,'Spam để test dữ liệu thôi mà.'),
(11,14,'Import DB lớn có hay lỗi không?'),
(14,11,'Có, phải chia nhỏ file ra.'),
(19,20,'Cuối kỳ đồ án căng thật.'),
(20,19,'Ráng xong là nhẹ người liền.');
INSERT INTO posts (user_id, content) VALUES
-- User 2 bắt đầu spam
(2,'Hôm nay mình test truy vấn feed người dùng.'),
(2,'Feed mà load chậm là user thoát liền.'),

-- User 4 chỉ đăng 1 bài nhưng rất chất
(4,'Thiết kế CSDL tốt giúp code backend nhàn hơn.'),

-- User 10 đăng bài nhưng không ai quan tâm
(10,'Post này đăng thử xem có ai đọc không.'),

-- User 13 đăng bài gây tranh luận
(13,'Có nên dùng denormalization để tăng hiệu năng?'),

-- User 16 chia sẻ kinh nghiệm
(16,'Index nên tạo sau khi đã có dữ liệu mẫu.'),

-- User 18 post rất chuyên sâu
(18,'Partition theo RANGE vs HASH, mọi người hay dùng cái nào?');
INSERT INTO comments (post_id, user_id, content) VALUES
-- Post 66 (user 2) khá sôi động
(66,1,'Feed là phần quan trọng nhất luôn.'),
(66,3,'Load chậm là người dùng bỏ ngay.'),
(66,5,'Cần index theo created_at.'),

-- Post 67 (user 2) ít người để ý
(67,6,'Chuẩn, UX kém là mất user.'),

-- Post 68 (user 4) được ủng hộ
(68,2,'Thiết kế tốt là nhàn cả team.'),
(68,7,'Làm đúng từ đầu đỡ refactor.'),

-- Post 69 (user 10) gần như bị bỏ quên
(69,8,'Lướt ngang qua thôi 😅'),

-- Post 70 (user 13) tranh luận mạnh
(70,9,'Denormalize tăng hiệu năng nhưng dễ lỗi.'),
(70,11,'Chỉ nên dùng khi bottleneck rõ ràng.'),
(70,12,'Trade-off giữa performance và maintain.'),

-- Post 71 (user 16)
(71,14,'Index sớm quá đôi khi phản tác dụng.'),

-- Post 72 (user 18) khá chuyên sâu
(72,15,'RANGE hợp dữ liệu theo thời gian.'),
(72,17,'HASH phân tán đều nhưng khó query.');
INSERT INTO likes (post_id, user_id) VALUES
-- Post 66 khá hot
(66,2),(66,4),(66,6),(66,7),(66,8),

-- Post 67 chỉ vài like
(67,1),(67,3),

-- Post 68 được đánh giá cao
(68,5),(68,9),(68,10),(68,11),

-- Post 69 gần như không ai like
(69,12),

-- Post 70 tranh luận nên nhiều like
(70,13),(70,14),(70,15),(70,16),(70,17),

-- Post 71 ít like
(71,18),

-- Post 72 dân chuyên mới quan tâm
(72,19),(72,20);
INSERT INTO comments (post_id, user_id, content) VALUES
(55,9,'Mình toàn vào đọc chứ ít đăng bài.'),
(59,9,'Comment vậy thôi chứ mình không hay post.'),
(66,9,'Feed nhìn khá ổn rồi.'),
(70,9,'Topic này tranh luận hoài không hết.');
INSERT INTO posts (user_id, content) VALUES
-- User 3 lâu rồi mới đăng
(3,'Lâu rồi mới đăng bài, mọi người học SQL tới đâu rồi?'),

-- User 6 chia sẻ kinh nghiệm
(6,'Index chỉ hiệu quả khi WHERE/JOIN đúng cột.'),

-- User 8 đăng bài gây hiểu nhầm
(8,'Mình nghĩ dùng index càng nhiều càng tốt 🤔'),

-- User 12 đăng bài rất chuyên môn
(12,'So sánh B-Tree index và Hash index trong MySQL.'),

-- User 15 đăng bài nhưng ít ai chú ý
(15,'Post này chỉ để test dữ liệu thôi.'),

-- User 18 spam kiến thức
(18,'Partition theo RANGE rất hợp cho bảng log.'),
(18,'Partition mà không có where theo key thì cũng vô nghĩa.'),

-- User 20 than thở cuối kỳ
(20,'Deadline đồ án CSDL dí quá rồi 😭');

INSERT INTO comments (post_id, user_id, content) VALUES
-- Post của user 3 (vừa phải)
(73,1,'Mình vẫn đang vật vã với JOIN 😅'),
(73,5,'Mình bắt đầu hiểu index hơn rồi.'),

-- Post của user 6 (được đồng tình)
(74,2,'Chuẩn, index sai là vô dụng.'),
(74,4,'EXPLAIN là công cụ không thể thiếu.'),

-- Post của user 8 (bị phản biện mạnh)
(75,6,'Index nhiều quá làm insert chậm đó.'),
(75,9,'Không phải cột nào cũng nên index.'),
(75,11,'Cần đo bằng thực tế, không đoán.'),

-- Post của user 12 (chuyên sâu)
(76,3,'B-Tree dùng cho range query rất tốt.'),
(76,7,'Hash index thì equality nhanh hơn.'),

-- Post của user 15 (gần như bị lãng quên)
(77,10,'Lướt thấy nên comment cho đỡ trống.'),

-- Post của user 18 spam kiến thức
(78,12,'Log theo thời gian dùng RANGE là hợp lý.'),
(79,13,'Không có WHERE thì partition không giúp gì mấy.'),

-- Post của user 20 than thở
(80,14,'Ai cuối kỳ cũng vậy thôi 😭'),
(80,16,'Ráng qua là nhẹ người liền.');

INSERT INTO likes (post_id, user_id) VALUES
-- Post 73 trung bình
(73,2),(73,3),

-- Post 74 khá hot
(74,5),(74,6),(74,7),(74,8),

-- Post 75 tranh luận nên nhiều like
(75,9),(75,10),(75,11),(75,12),(75,13),

-- Post 76 dân kỹ thuật quan tâm
(76,14),(76,15),(76,16),

-- Post 77 rất ít like
(77,17),

-- Post 78 khá ổn
(78,18),(78,19),(78,20),

-- Post 79 ít người để ý
(79,1),

-- Post 80 cảm xúc nên nhiều người like
(80,2),(80,3),(80,4),(80,5);


INSERT INTO comments (post_id, user_id, content) VALUES
(75,17,'Mình chỉ vào đọc tranh luận thôi.'),
(76,17,'Bài này đọc hơi nặng nhưng hay.'),
(80,17,'Cuối kỳ ai cũng khổ như nhau 😅');
INSERT INTO posts (user_id, content) VALUES
-- User 5 lâu rồi mới đăng
(5,'Lâu quá không đụng SQL, hôm nay mở lại thấy quên nhiều thứ ghê.'),

-- User 7 chia sẻ kinh nghiệm thực tế
(7,'Làm project thật mới thấy dữ liệu test quan trọng cỡ nào.'),

-- User 9 đăng bài cảm xúc
(9,'Code chạy đúng nhưng vẫn thấy lo lo 🤯'),

-- User 13 tiếp tục gây tranh luận
(13,'Theo mọi người có nên đánh index cho cột boolean không?'),

-- User 16 đăng bài nhưng ít người chú ý
(16,'Mình vừa đọc xong tài liệu về query cache.'),

-- User 18 tiếp tục spam kiến thức
(18,'Index không dùng thì optimizer cũng bỏ qua thôi.'),
(18,'Đừng tin cảm giác, hãy tin EXPLAIN.'),

-- User 20 cuối kỳ than tiếp
(20,'Mới sửa xong bug lại phát sinh bug khác 😭');

INSERT INTO comments (post_id, user_id, content) VALUES
-- Post 81 (user 5)
(81,1,'Không đụng là quên liền 😅'),
(81,3,'Mình cũng vậy, phải luyện lại từ đầu.'),

-- Post 82 (user 7)
(82,4,'Data test tốt là debug nhàn hẳn.'),
(82,6,'Nhiều bug chỉ lộ ra khi data lớn.'),

-- Post 83 (user 9)
(83,2,'Cảm giác này ai code cũng từng trải qua.'),
(83,5,'Miễn chạy đúng là ổn rồi.'),

-- Post 84 (user 13) tranh luận
(84,7,'Boolean thường ít giá trị, index không hiệu quả.'),
(84,10,'Index cho boolean hiếm khi có lợi.'),
(84,12,'Trừ khi kết hợp composite index.'),

-- Post 85 (user 16) bị ngó lơ
(85,8,'Mình chưa dùng query cache bao giờ.'),

-- Post 86 (user 18)
(86,11,'EXPLAIN là chân ái.'),

-- Post 87 (user 18)
(87,14,'Tin số liệu hơn tin cảm giác.'),

-- Post 88 (user 20)
(88,15,'Bug nối tiếp bug là chuyện thường 😭'),
(88,17,'Cuối kỳ ai cũng như nhau thôi.');

INSERT INTO likes (post_id, user_id) VALUES
-- Post 81 vừa vừa
(81,2),(81,4),

-- Post 82 khá hot
(82,5),(82,6),(82,7),(82,8),

-- Post 83 trung bình
(83,1),(83,9),

-- Post 84 tranh luận nên nhiều like
(84,10),(84,11),(84,12),(84,13),(84,14),

-- Post 85 gần như chìm
(85,15),

-- Post 86 ít like
(86,16),

-- Post 87 dân kỹ thuật thích
(87,17),(87,18),(87,19),

-- Post 88 cảm xúc nên nhiều like
(88,2),(88,3),(88,4),(88,5),(88,6);

INSERT INTO comments (post_id, user_id, content) VALUES
(84,18,'Mình vào đọc tranh luận là chính.'),
(87,18,'Bài này đọc là thấy đúng liền.'),
(88,18,'Cuối kỳ áp lực thật sự.');

INSERT INTO posts (user_id, content) VALUES
-- User 1 quay lại spam nhẹ
(1,'Test tiếp dữ liệu cho phần thống kê user hoạt động.'),

-- User 4 chia sẻ kinh nghiệm hiếm hoi
(4,'Làm CSDL nhớ nghĩ tới dữ liệu 1–2 năm sau.'),

-- User 6 hỏi ngu có chủ đích 😅
(6,'Mọi người ơi, có phải index càng nhiều càng tốt không?'),

-- User 8 đăng bài gây hiểu lầm tiếp
(8,'Mình thấy boolean cũng nên index cho chắc 🤔'),

-- User 11 tâm sự
(11,'Có ai cảm thấy học DB khó hơn học code không?'),

-- User 14 chia sẻ lỗi thực tế
(14,'Mình từng quên WHERE trong câu UPDATE 😱'),

-- User 17 lâu lâu mới xuất hiện
(17,'Mình toàn vào đọc chứ ít khi comment.'),

-- User 19 đăng bài kỹ thuật nhưng chìm
(19,'Clustered index và non-clustered index khác nhau thế nào?'),

-- User 20 than thở tiếp
(20,'Deadline càng gần bug càng nhiều 😭');

INSERT INTO comments (post_id, user_id, content) VALUES
-- Post 89 (user 1)
(89,2,'Thống kê user là phần thầy hay hỏi đó.'),
(89,3,'GROUP BY + HAVING là đủ demo rồi.'),

-- Post 90 (user 4)
(90,5,'Nghĩ xa từ đầu đỡ vỡ hệ thống.'),

-- Post 91 (user 6) bị phản biện
(91,7,'Không đâu, index nhiều quá còn hại.'),
(91,8,'Insert/update sẽ chậm hơn.'),

-- Post 92 (user 8) tranh cãi
(92,9,'Boolean thường selectivity thấp.'),
(92,10,'Index boolean hiếm khi có lợi.'),

-- Post 93 (user 11) được đồng cảm
(93,12,'DB khó vì nhiều thứ phải đo đạc.'),
(93,13,'Code sai còn sửa nhanh hơn.'),

-- Post 94 (user 14) rất hot
(94,1,'Ai cũng từng quên WHERE 😅'),
(94,2,'UPDATE không WHERE là ác mộng.'),
(94,3,'Nên dùng transaction cho an toàn.'),

-- Post 95 (user 17) ít người để ý
(95,6,'Mình cũng hay vào đọc thôi.'),

-- Post 96 (user 19) chìm
(96,7,'Topic này hơi nặng.'),

-- Post 97 (user 20)
(97,8,'Cuối kỳ ai cũng vậy 😭'),
(97,9,'Ráng lên là qua thôi.');

INSERT INTO likes (post_id, user_id) VALUES
-- Post 89 trung bình
(89,4),(89,5),

-- Post 90 ít like
(90,6),

-- Post 91 tranh luận
(91,7),(91,8),(91,9),

-- Post 92 tranh luận nhẹ
(92,10),(92,11),

-- Post 93 được đồng cảm
(93,12),(93,13),(93,14),

-- Post 94 cực hot (quên WHERE)
(94,1),(94,2),(94,3),(94,4),(94,5),(94,6),(94,7),

-- Post 95 gần như chìm
(95,8),

-- Post 96 rất chìm
(96,9),

-- Post 97 cảm xúc
(97,10),(97,11),(97,12),(97,13);

-- User 18 chỉ like
INSERT INTO likes (post_id, user_id) VALUES
(94,18),
(97,18),
(93,18);
INSERT INTO posts (user_id, content) VALUES
-- User 2 quay lại hỏi bài
(2,'Mọi người thường debug query chậm theo thứ tự nào?'),

-- User 3 chia sẻ sai lầm
(3,'Ngày xưa mình từng SELECT * và trả giá 😅'),

-- User 5 đăng bài nhưng bị chìm
(5,'Mình đang đọc lại tài liệu normalization.'),

-- User 7 đăng bài rất thực tế
(7,'Test dữ liệu nhỏ chạy nhanh, lên dữ liệu lớn là khác liền.'),

-- User 10 hỏi kiến thức cơ bản
(10,'INNER JOIN và LEFT JOIN khác nhau dễ nhớ không?'),

-- User 12 chia sẻ kinh nghiệm
(12,'Nên viết query rõ ràng trước rồi mới tối ưu.'),

-- User 15 đăng bài cho có
(15,'Post này để test thống kê thôi.'),

-- User 18 tiếp tục spam kiến thức
(18,'Index không dùng trong WHERE thì vô nghĩa.'),

-- User 20 than tiếp
(20,'Càng gần deadline càng dễ commit lỗi 😭');

INSERT INTO comments (post_id, user_id, content) VALUES
-- Post 98 (user 2) khá sôi động
(98,1,'Xem EXPLAIN trước tiên.'),
(98,4,'Kiểm tra index là bước bắt buộc.'),
(98,6,'Đừng quên đo bằng thời gian thực.'),

-- Post 99 (user 3) được đồng cảm
(99,2,'SELECT * lúc đầu ai cũng từng 😅'),
(99,7,'Sau này toàn chọn cột cần thiết.'),

-- Post 100 (user 5) gần như chìm
(100,8,'Normalization đọc hơi khô.'),

-- Post 101 (user 7) rất thực tế
(101,3,'Data lớn mới lộ bug.'),
(101,9,'Test nhỏ chỉ mang tính tham khảo.'),

-- Post 102 (user 10) cơ bản
(102,11,'INNER chỉ lấy khớp hai bên.'),
(102,12,'LEFT lấy hết bảng trái.'),

-- Post 103 (user 12) được ủng hộ
(103,13,'Làm rõ logic trước rất quan trọng.'),

-- Post 104 (user 15) chìm
(104,14,'Comment cho đỡ trống.'),

-- Post 105 (user 18) kỹ thuật
(105,15,'WHERE không dùng index là query quét bảng.'),

-- Post 106 (user 20)
(106,16,'Cuối kỳ dễ loạn thật 😭'),
(106,17,'Cố lên là qua thôi.');


INSERT INTO likes (post_id, user_id) VALUES
-- Post 98 khá hot
(98,2),(98,3),(98,4),(98,5),(98,6),

-- Post 99 vừa
(99,1),(99,7),

-- Post 100 rất chìm
(100,9),

-- Post 101 được quan tâm
(101,10),(101,11),(101,12),(101,13),

-- Post 102 cơ bản
(102,14),(102,15),

-- Post 103 ổn
(103,16),(103,17),(103,18),

-- Post 104 gần như không ai quan tâm
(104,19),

-- Post 105 dân kỹ thuật thích
(105,20),(105,1),(105,2),

-- Post 106 cảm xúc
(106,3),(106,4),(106,5),(106,6);
-- User 19 gần như không post, không comment
INSERT INTO likes (post_id, user_id) VALUES
(98,19),
(101,19),
(106,19);
INSERT INTO posts (user_id, content) VALUES
-- User 1 lại xuất hiện
(1,'Test thêm dữ liệu cho biểu đồ thống kê like/comment.'),

-- User 3 đăng bài chuyên môn
(3,'Tối ưu query không phải lúc nào cũng là thêm index.'),

-- User 6 đăng bài hỏi kinh nghiệm
(6,'Mọi người thường đặt index trước hay sau khi có dữ liệu?'),

-- User 8 tiếp tục gây tranh cãi
(8,'Theo mình thấy optimizer đôi khi chọn plan không tốt.'),

-- User 11 đăng bài cảm xúc
(11,'Học DB nhiều lúc thấy nản thật 😥'),

-- User 13 đăng bài kỹ thuật
(13,'Composite index nên sắp xếp cột theo selectivity.'),

-- User 16 đăng bài nhưng rất chìm
(16,'Mình đang đọc về isolation level.'),

-- User 18 tiếp tục spam kiến thức
(18,'Index chỉ giúp khi query dùng đúng cột.'),

-- User 20 kết bài đồ án
(20,'Hy vọng đồ án này qua môn là mừng rồi 😭');

INSERT INTO likes (post_id, user_id) VALUES
-- Post 107 vừa
(107,3),(107,6),

-- Post 108 khá hot
(108,8),(108,9),(108,10),(108,11),

-- Post 109 trung bình
(109,12),(109,13),

-- Post 110 tranh luận nên nhiều like
(110,14),(110,15),(110,16),(110,17),(110,18),

-- Post 111 cảm xúc
(111,1),(111,2),(111,3),(111,4),

-- Post 112 dân kỹ thuật
(112,5),(112,6),(112,7),

-- Post 113 rất chìm
(113,8),

-- Post 114 spam kiến thức
(114,9),(114,10),(114,11),(114,12),

-- Post 115 cảm xúc cuối kỳ
(115,13),(115,14),(115,15),(115,16),(115,17);

-- User 10 gần như chỉ like
INSERT INTO likes (post_id, user_id) VALUES
(107,10),
(110,10),
(115,10);
INSERT INTO posts (user_id, content) VALUES
-- User 4 đăng bài rất trúng tâm lý
(4,'Có ai từng bị thầy hỏi truy vấn mà não trống rỗng chưa? 😭'),

-- User 7 đăng bài kỹ thuật nhưng khó
(7,'So sánh execution plan giữa MySQL và PostgreSQL.'),

-- User 9 đăng bài rất bình thường
(9,'Mình đang ôn lại các dạng JOIN.'),

-- User 12 đăng bài chia sẻ mẹo
(12,'Luôn viết SELECT trước rồi mới nghĩ tới index.'),

-- User 15 lại post cho đủ KPI
(15,'Post thêm để test thống kê.'),

-- User 18 spam kiến thức tiếp
(18,'Index không dùng trong JOIN thì cũng vô ích.'),

-- User 20 xả stress
(20,'Qua đồ án này chắc bạc tóc 😭');

INSERT INTO comments (post_id, user_id, content) VALUES
-- Post 116 (user 4) SIÊU HOT
(116,1,'Gặp rồi 😭'),
(116,2,'Bị hỏi cái đứng hình luôn.'),
(116,3,'Nhìn query quen mà không nói được.'),
(116,5,'Ám ảnh thật sự.'),
(116,6,'Nhất là lúc bảo giải thích JOIN 😵'),
(116,7,'Ai cũng từng trải qua.'),

-- Post 117 (user 7) khá khó
(117,8,'Hai engine khác triết lý xử lý.'),

-- Post 118 (user 9)
(118,10,'JOIN làm bài thi hay ra lắm.'),

-- Post 119 (user 12) được đồng tình
(119,11,'Cách này học dễ hơn.'),

-- Post 120 (user 15) chìm
(120,13,'Comment cho có.'),

-- Post 121 (user 18)
(121,14,'Chuẩn kiến thức.'),

-- Post 122 (user 20)
(122,15,'Cuối kỳ ai cũng vậy 😭'),
(122,16,'Ráng chút nữa là xong.');

INSERT INTO likes (post_id, user_id) VALUES
-- Post 116 SIÊU HOT
(116,1),(116,2),(116,3),(116,4),(116,5),(116,6),
(116,7),(116,8),(116,9),(116,10),(116,11),(116,12),

-- Post 117 chuyên môn
(117,13),(117,14),

-- Post 118 bình thường
(118,15),(118,16),

-- Post 119 mẹo học
(119,17),(119,18),(119,19),

-- Post 120 rất chìm
(120,20),

-- Post 121 spam kiến thức
(121,1),(121,2),(121,3),

-- Post 122 cảm xúc
(122,4),(122,5),(122,6),(122,7);
-- User 17 chỉ xuất hiện khi bài hot
INSERT INTO likes (post_id, user_id) VALUES
(116,17),
(116,18);

INSERT INTO comments (post_id, user_id, content) VALUES
(116,17,'Bài này đúng nỗi ám ảnh.');

INSERT INTO users(username, full_name, gender, email, password, birthdate, hometown) VALUES
('dung', 'Hoàng Tuấn Dũng', 'Nam', 'dung@gmail.com', '123', '1993-05-10', 'Hải Phòng'),
('yen', 'Phạm Hải Yến', 'Nữ', 'yen@gmail.com', '123', '1995-08-22', 'Hà Nội'),
('thanh', 'Lê Văn Thành', 'Nam', 'thanh@gmail.com', '123', '1991-12-15', 'Cần Thơ'),
('mai', 'Nguyễn Tuyết Mai', 'Nữ', 'mai@gmail.com', '123', '1994-02-28', 'TP.HCM'),
('vinh', 'Trần Quang Vinh', 'Nam', 'vinh@gmail.com', '123', '1992-09-05', 'Đà Nẵng');

select * from users;
-- 2
create or replace view view_users_firstname
as
select user_id, username, full_name, email, created_at from users
where full_name like '%Nguyễn%';

-- 3
select * from view_users_firstname;

-- 4 
INSERT INTO users (username,full_name, email, password)
VALUES ('a','Nguyễn Văn A', 'a@gmail.com', '123456');

-- 5
delete from users where user_id = 27;
