create database ecommerce_db;
use ecommerce_db;

-- ==BÀI 1:==

create table customers (
    customer_id int primary key,
    full_name varchar(255) not null,
    city varchar(255)
);

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    status enum('pending', 'completed', 'cancelled') not null,
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(customer_id)
);

insert into customers (customer_id, full_name, city) values
(1, 'nguyễn văn a', 'hà nội'),
(2, 'trần thị b', 'tp hồ chí minh'),
(3, 'lê văn c', 'đà nẵng'),
(4, 'phạm thị d', 'hà nội'),
(5, 'hoàng văn e', 'cần thơ'),
(6, 'vũ thị f', 'hải phòng');

insert into orders (order_id, customer_id, order_date, status) values
(101, 1, '2025-01-01', 'completed'),
(102, 1, '2025-01-15', 'pending'),
(103, 2, '2025-02-01', 'completed'),
(104, 3, '2025-02-10', 'cancelled'),
(105, 1, '2025-03-01', 'completed'),
(106, 4, '2025-03-15', 'pending'),
(107, 5, '2025-04-01', 'completed');


-- hiển thị danh sách đơn hàng kèm tên khách hàng
select o.order_id, o.order_date, o.status, c.full_name, c.city
from orders o join customers c on o.customer_id = c.customer_id order by o.order_id;

-- hiển thị khách hàng đã đặt bao nhiêu đơn hàng
select c.customer_id, c.full_name, c.city, count(o.order_id) as so_don_hang
from customers c left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name, c.city order by c.customer_id;

-- hiển thị các khách hàng có ít nhất 1 đơn hàng
select  c.customer_id, c.full_name, c.city, count(o.order_id) as so_don_hang
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name, c.city order by so_don_hang desc, c.customer_id;

-- ==BÀI 2:==

delete from orders;

insert into orders (order_id, customer_id, order_date, status, total_amount) values
(101, 1, '2025-01-01', 'completed', 1500000.00),
(102, 1, '2025-01-15', 'pending', 850000.00),
(103, 2, '2025-02-01', 'completed', 2200000.00),
(104, 3, '2025-02-10', 'cancelled', 1200000.00),
(105, 1, '2025-03-01', 'completed', 1950000.00),
(106, 4, '2025-03-15', 'pending', 650000.00),
(107, 5, '2025-04-01', 'completed', 3100000.00);
(111, 1, '2025-05-20', 'completed', 4500000.00),
(112, 2, '2025-05-25', 'completed', 13000000.00),
(113, 5, '2025-06-01', 'completed', 6500000.00);


-- 1. tổng tiền mỗi khách hàng chi tiêu
select c.customer_id, c.full_name, c.city, coalesce(sum(o.total_amount), 0.00) as tong_tien_chi_tieu
from customers c left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name, c.city order by tong_tien_chi_tieu desc;

-- đơn hàng cao nhất của từng khách
select  c.customer_id, c.full_name, c.city, max(o.total_amount) as don_hang_cao_nhat
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name, c.city order by don_hang_cao_nhat desc;

-- khách hàng đã mua theo tổng tiền giảm dần 
select  c.customer_id, c.full_name, c.city, sum(o.total_amount) as tong_tien_chi_tieu
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name, c.city order by tong_tien_chi_tieu desc;

--  ==BÀI 3:==

-- tính tổng doanh thu theo từng ngày
select order_date, sum(total_amount) as tong_doanh_thu
from orders where status = 'completed'
group by order_date order by order_date;

-- tính số lượng đơn hàng theo từng ngày
select  order_date, count(order_id) as so_luong_don_hang
from orders where status = 'completed'
group by order_date order by order_date;

-- hiển thị các ngày có doanh thu > 10.000.000
select  order_date, count(order_id) as so_luong_don_hang, sum(total_amount) as tong_doanh_thu
from orders where status = 'completed'
group by order_date having sum(total_amount) > 10000000 order by tong_doanh_thu desc;


-- ==Bài 4:==

create table products (
    product_id int primary key,
    product_name varchar(255) not null,
    price decimal(10,2) not null
);

create table order_items (
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    primary key (order_id, product_id), 
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into products (product_id, product_name, price) values
(1, 'iphone 15 pro', 28000000.00),
(2, 'samsung galaxy s24', 22000000.00),
(3, 'macbook air m2', 32000000.00),
(4, 'tai nghe airpods pro', 6500000.00),
(5, 'ốp lưng iphone', 450000.00),
(6, 'sạc nhanh 65w', 1200000.00);

insert into order_items (order_id, product_id, quantity) values
(101, 1, 1),     
(101, 4, 2),
(102, 5, 3),    
(102, 6, 1),    
(103, 2, 1),     
(103, 4, 1),     
(105, 3, 1),     
(105, 6, 2),    
(107, 1, 1),   
(107, 2, 1),    
(107, 5, 5);
(111, 5, 10),  
(111, 4, 3),   
(112, 1, 1),   
(112, 5, 8), 
(113, 5, 12);


-- hiển thị sản phẩm đã bán được bao nhiêu sản phẩm
select p.product_id, p.product_name, p.price, coalesce(sum(oi.quantity), 0) as tong_so_luong_ban
from products p
left join order_items oi on p.product_id = oi.product_id
left join orders o on oi.order_id = o.order_id and o.status = 'completed'
group by p.product_id, p.product_name, p.price order by tong_so_luong_ban desc;

-- tính doanh thu của từng sản phẩm
select p.product_id, p.product_name, p.price, coalesce(sum(oi.quantity), 0) as tong_so_luong_ban, coalesce(sum(oi.quantity * p.price), 0.00) as doanh_thu
from products p
left join order_items oi on p.product_id = oi.product_id
left join orders o on oi.order_id = o.order_id and o.status = 'completed'
group by p.product_id, p.product_name, p.price order by doanh_thu desc;

-- chỉ hiển thị các sản phẩm có doanh thu > 5.000.000
select  p.product_id, p.product_name, p.price, sum(oi.quantity) as tong_so_luong_ban, sum(oi.quantity * p.price) as doanh_thu
from products p
join order_items oi on p.product_id = oi.product_id
join orders o on oi.order_id = o.order_id and o.status = 'completed'
group by p.product_id, p.product_name, p.price having sum(oi.quantity * p.price) > 5000000 order by doanh_thu desc;


-- ==Bài 5:==
select c.customer_id, c.full_name, c.city, count(o.order_id) as tong_so_don_hang, sum(o.total_amount) as tong_tien_chi_tieu, round(avg(o.total_amount), 2) as gia_tri_don_hang_trung_binh
from customers c join orders o on c.customer_id = o.customer_id where o.status = 'completed' 
group by c.customer_id, c.full_name, c.city having count(o.order_id) >= 3 and sum(o.total_amount) > 10000000 order by tong_tien_chi_tieu desc;

-- == BÀI 6:==
select p.product_name as ten_san_pham, sum(oi.quantity) as tong_so_luong_ban,nsum(oi.quantity * p.price) as tong_doanh_thu, round(avg(p.price), 2) as gia_ban_trung_binh
from products p join order_items oi on p.product_id = oi.product_id join orders o on oi.order_id = o.order_id
where o.status = 'completed'  group by p.product_id, p.product_name having sum(oi.quantity) >= 10 order by tong_doanh_thu desc limit 5;

