create database  ecommerce_subquery;
use ecommerce_subquery;

-- === BÀI 1: ===

create table customers (
    id int primary key,
    name varchar(255) not null,
    email varchar(255) unique
);

create table orders (
    id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(id)
);

insert into customers (id, name, email) values
(1, 'nguyễn văn an', 'an@gmail.com'),
(2, 'trần thị bình', 'binh@yahoo.com'),
(3, 'lê văn cường', 'cuong@hotmail.com'),
(4, 'phạm thị dung', 'dung@gmail.com'),
(5, 'hoàng văn em', 'em@gmail.com'),
(6, 'vũ thị phương', 'phuong@outlook.com'),
(7, 'đỗ văn giỏi', 'gioi@gmail.com'),
(8, 'bùi thị hạnh', 'hanh@gmail.com');

insert into orders (id, customer_id, order_date, total_amount) values
(101, 1, '2025-01-10', 2500000.00),
(102, 2, '2025-01-12', 1800000.00),
(103, 1, '2025-01-20', 3200000.00),
(104, 3, '2025-02-05', 4500000.00),
(105, 4, '2025-02-15', 1200000.00),
(106, 1, '2025-02-28', 2800000.00),
(107, 5, '2025-03-10', 3900000.00),
(108, 2, '2025-03-20', 2100000.00),
(109, 7, '2025-04-01', 1500000.00),
(110, 1, '2025-04-15', 5000000.00);

select id, name, email from customers where id in (select distinct customer_id from orders where customer_id is not null) order by id;

-- === BÀI 2: ===
create table products (
    id int primary key,
    name varchar(255) not null,
    price decimal(10,2) not null
);

create table order_items (
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    primary key (order_id, product_id),
    foreign key (product_id) references products(id)
);

insert into products (id, name, price) values
(1, 'iphone 15 pro max', 34990000.00),
(2, 'samsung galaxy s24 ultra', 29990000.00),
(3, 'macbook pro m3', 49990000.00),
(4, 'airpods pro 2', 6990000.00),
(5, 'ốp lưng silicone', 490000.00),
(6, 'sạc nhanh 65w', 1290000.00),
(7, 'tai nghe sony wh-1000xm5', 8990000.00),
(8, 'chuột logitech mx master 3', 2490000.00);

insert into order_items (order_id, product_id, quantity) values
(1001, 1, 2),
(1001, 4, 1),
(1002, 2, 1),
(1002, 5, 3),
(1003, 3, 1),
(1003, 6, 2),
(1004, 1, 1),
(1004, 7, 1),
(1005, 4, 3),
(1005, 5, 5),
(1006, 2, 1),
(1006, 8, 1);

select id, name, price from products where id in (select distinct product_id from order_items where product_id is not null)order by id;

-- === BÀI 3: ===
select id, customer_id, order_date, total_amount
from orders where total_amount > (select avg(total_amount) from orders) 
order by total_amount desc;

-- === BÀI 4: ===
select name as ten_khach_hang, email, (select count(*)from orders o where o.customer_id = c.id) as so_luong_don_hang
from customers c order by so_luong_don_hang desc, name;

-- === BÀI 5: ===
select name as ten_khach_hang, email,(select sum(total_amount) from orders o where o.customer_id = c.id) as tong_tien_chi_tieu
from customers c where (select sum(total_amount)from orders o where o.customer_id = c.id) = (select max(tong_tien) from (select sum(total_amount) as tong_tien from orders group by customer_id) as sub1)
order by tong_tien_chi_tieu desc;

-- === BÀI 6: ===
select customer_id, sum(total_amount) as tong_tien_chi_tieu
from orders group by customer_id having sum(total_amount) > (select avg(tong_tien_per_customer)from (select sum(total_amount) as tong_tien_per_customerfrom orders group by customer_id) as sub)
order by tong_tien_chi_tieu desc;



