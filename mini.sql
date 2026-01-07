create database miniprj;
use miniprj;

drop table order_items;

create table customers(
  customer_id int primary key auto_increment,
  customer_name varchar(100) Not null, 
  email varchar(100) not null unique,
  phone varchar(10) not null unique
);
create table categories(
  category_id int primary key auto_increment,
  category_name varchar(255) not null unique
);
create table products(
  product_id int primary key auto_increment,
  product_name varchar(255) not null unique,
  price decimal(10,2) not null check(price > 0),
  category_id int not null ,
  foreign key(category_id) references categories(category_id)
);
create table orders(
  order_id int primary key auto_increment,
  customer_id int not null,
  order_date datetime DEFAULT now(),
  status enum('Pending','Completed','Cancel') default 'Pending',
  foreign key( customer_id) references customers(customer_id)
);

create table  order_items(
  order_item_id int primary key auto_increment,
  order_id int not null, 
  product_id int not null,
  quantity int not null check(quantity > 0),
  foreign key(order_id) references orders( order_id),
  foreign key(product_id) references products(product_id)
);


INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyễn Văn An',   'an.nguyen@example.com',   '0900000001'),
('Trần Thị Bình',   'binh.tran@example.com',   '0900000002'),
('Lê Quốc Cường',   'cuong.le@example.com',    '0900000003'),
('Phạm Minh Duy',   'duy.pham@example.com',    '0900000004'),
('Võ Thị Hạnh',     'hanh.vo@example.com',     '0900000005'),
('Đặng Gia Khang',  'khang.dang@example.com',  '0900000006'),
('Hoàng Mai Lan',   'lan.hoang@example.com',   '0900000007');


INSERT INTO categories (category_name) VALUES
('Điện thoại'),
('Laptop'),
('Phụ kiện'),
('Tai nghe'),
('Đồng hồ thông minh'),
('Màn hình'),
('Thiết bị mạng');

INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 14 128GB',          18990000.00, 1),
('Samsung Galaxy S23',       16990000.00, 1),
('MacBook Air M2 13"',       25990000.00, 2),
('Chuột Logitech M331',        399000.00, 3),
('Tai nghe Sony WH-1000XM5',  6990000.00, 4),
('Apple Watch SE 40mm',       5990000.00, 5),
('Router TP-Link Archer C6',   690000.00, 7);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-01-01 09:10:00', 'Pending'),
(2, '2026-01-02 14:25:00', 'Completed'),
(3, '2026-01-03 10:05:00', 'Completed'),
(4, '2026-01-03 16:40:00', 'Cancel'),
(5, '2026-01-04 11:15:00', 'Pending'),
(6, '2026-01-05 19:30:00', 'Completed'),
(7, '2026-01-06 08:50:00', 'Pending');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(2, 4, 2),
(1, 3, 1),
(4, 2, 1),
(5, 7, 1),
(6, 5, 1),
(7, 6, 1);

-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN
-- Lấy danh sách tất cả danh mục sản phẩm trong hệ thống.
select * from categories;
-- Lấy danh sách đơn hàng có trạng thái là COMPLETED
select * from orders
where status = 'Completed';
-- Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
select * from products 
order by price desc;
-- Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
select * from products 
order by price desc
limit 5 offset 2;

-- PHẦN B – TRUY VẤN NÂNG CAO
-- Lấy danh sách sản phẩm kèm tên danh mục
select p.product_id,p.product_name,p.price  ,c.category_name
from products p
left join categories c on p.category_id = c.category_id;
-- Lấy danh sách đơn hàng gồm:order_id order_date customer_name status
select o.order_id, o.order_date, c.customer_name, o.status
from orders o
left join customers c on o.customer_id = c.customer_id;
-- Tính tổng số lượng sản phẩm trong từng đơn hàng
select oi.order_item_id,p.product_name ,sum(oi.quantity) as soLuong
from order_items oi 
left join products p on p.product_id = oi.product_id
group by  oi.order_item_id,p.product_name;
-- Thống kê số đơn hàng của mỗi khách hàng


-- PHẦN C – TRUY VẤN LỒNG (SUBQUERY)
-- Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
select distinct cus.customer_name
from customers cus join orders o on cus.customer_id = o.customer_id join order_items oi on oi.order_id = o.order_id join products p on oi.product_id = p.product_id
where p.category_id = (select category_id 
from (
        select c.category_id, avg(p.price) as avg_price
        from categories c join products p on c.category_id = p.category_id
        group by c.category_id order by avg_price desc limit 1
    ) as sub
);
 
