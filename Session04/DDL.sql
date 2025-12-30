create database if not exists online_learning;
use online_learning;

create table student (
    student_id varchar(20) primary key,
    full_name varchar(100) not null,
    birth_date date,
    email varchar(100) unique not null
);

create table course (
    course_id varchar(20) primary key,
    course_name varchar(150) not null,
    description text,
    sessions int check (sessions > 0)
);

create table instructor (
    instructor_id varchar(20) primary key,
    full_name varchar(100) not null,
    email varchar(100) unique not null
);

create table enrollment (
    student_id varchar(20),
    course_id varchar(20),
    enroll_date date default (current_date),
    primary key (student_id, course_id),
    foreign key (student_id) references student(student_id),
    foreign key (course_id) references course(course_id)
);

create table result (
    student_id varchar(20),
    course_id varchar(20),
    mid_term_score decimal(4,2) check (mid_term_score between 0 and 10),
    final_score decimal(4,2) check (final_score between 0 and 10),
    primary key (student_id, course_id),
    foreign key (student_id) references student(student_id),
    foreign key (course_id) references course(course_id)
);

insert into student (student_id, full_name, birth_date, email) values
('sv001', 'nguyễn văn an', '2003-05-15', 'an.nv@gmail.com'),
('sv002', 'trần thị bình', '2004-02-20', 'binh.tt@gmail.com'),
('sv003', 'lê văn cường', '2003-11-10', 'cuong.lv@gmail.com'),
('sv004', 'phạm thị dung', '2004-08-25', 'dung.pt@gmail.com'),
('sv005', 'hoàng văn minh', '2003-07-30', 'minh.hv@gmail.com');

insert into course (course_id, course_name, description, sessions) values
('c001', 'lập trình java cơ bản', 'khóa học java cho người mới bắt đầu', 30),
('c002', 'cơ sở dữ liệu', 'học sql và thiết kế csdl', 40),
('c003', 'lập trình web', 'html, css, javascript và php', 45),
('c004', 'cấu trúc dữ liệu và giải thuật', 'học các thuật toán cơ bản', 35),
('c005', 'lập trình python', 'python từ cơ bản đến nâng cao', 38);

insert into instructor (instructor_id, full_name, email) values
('gv001', 'nguyễn thị lan', 'lan.nt@gmail.com'),
('gv002', 'trần văn hùng', 'hung.tv@gmail.com'),
('gv003', 'phạm minh tuấn', 'tuan.pm@gmail.com'),
('gv004', 'lê thị hồng', 'hong.lt@gmail.com'),
('gv005', 'vũ văn nam', 'nam.vv@gmail.com');

insert into enrollment (student_id, course_id, enroll_date) values
('sv001', 'c001', '2025-01-10'),
('sv001', 'c002', '2025-01-10'),
('sv002', 'c002', '2025-01-12'),
('sv002', 'c003', '2025-01-12'),
('sv003', 'c001', '2025-01-15'),
('sv003', 'c004', '2025-01-15'),
('sv004', 'c003', '2025-01-18'),
('sv004', 'c005', '2025-01-18'),
('sv005', 'c002', '2025-01-20'),
('sv005', 'c004', '2025-01-20');

insert into result (student_id, course_id, mid_term_score, final_score) values
('sv001', 'c001', 8.5, 9.0),
('sv001', 'c002', 7.0, 8.5),
('sv002', 'c002', 9.0, 9.5),
('sv002', 'c003', 8.0, null),
('sv003', 'c001', 6.5, 7.0),
('sv004', 'c003', 8.5, 9.0),
('sv005', 'c002', 7.5, null);


update student set email = 'an.nguyenv.new@gmail.com' where student_id = 'sv001';

update course set description = 'khóa học lập trình web fullstack với react và node.js' where course_id = 'c003';

update result set final_score = 8.0 where student_id = 'sv003' and course_id = 'c001';

delete from result where student_id = 'sv005' and course_id = 'c004';

delete from enrollment where student_id = 'sv005' and course_id = 'c004';


select * from student;

select * from instructor;

select * from course;

select * from enrollment;

select * from result;