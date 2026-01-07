
create database ban_hang_truc_tuyen;
use ban_hang_truc_tuyen;

create table customers (
    customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(10) not null unique
);

create table categories (
    category_id int auto_increment primary key,
    category_name varchar(255) not null unique
);

create table products (
    product_id int auto_increment primary key,
    product_name varchar(255) not null unique,
    price decimal(10,2) not null check (price > 0),
    category_id int not null,
    foreign key (category_id) references categories(category_id)
);

create table orders (
    order_id int auto_increment primary key,
    customer_id int not null,
    order_date datetime default current_timestamp,
    status enum('Pending', 'Completed', 'Cancel') default 'Pending',
    foreign key (customer_id) references customers(customer_id)
);

create table order_items (
    order_item_id int auto_increment primary key,
    order_id int not null,
    product_id int not null,
    quantity int not null check (quantity > 0),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into customers (customer_name, email, phone) values
('Nguyễn Văn A', 'a@example.com', '0901234561'),
('Trần Thị B', 'b@example.com', '0901234562'),
('Lê Văn C', 'c@example.com', '0901234563'),
('Phạm Thị D', 'd@example.com', '0901234564'),
('Hoàng Văn E', 'e@example.com', '0901234565');

insert into categories (category_name) values
('Điện thoại'),
('Laptop'),
('Phụ kiện');

insert into products (product_name, price, category_id) values
('iPhone 15', 25000000.00, 1),
('Samsung Galaxy S24', 22000000.00, 1),
('MacBook Pro', 50000000.00, 2),
('Dell XPS', 45000000.00, 2),
('Tai nghe Bluetooth', 1500000.00, 3),
('Ốp lưng iPhone', 200000.00, 3),
('Sạc nhanh 65W', 800000.00, 3);

insert into orders (customer_id, order_date, status) values
(1, '2025-01-01 10:00:00', 'Completed'),
(1, '2025-02-01 11:00:00', 'Pending'),
(2, '2025-01-15 12:00:00', 'Completed'),
(3, '2025-03-01 13:00:00', 'Cancel'),
(4, '2025-01-20 14:00:00', 'Completed'),
(1, '2025-04-01 15:00:00', 'Completed'),
(2, '2025-04-10 16:00:00', 'Completed'),
(5, '2025-05-01 17:00:00', 'Pending');

insert into order_items (order_id, product_id, quantity) values
(1, 1, 1), (1, 5, 2),
(2, 2, 1),
(3, 3, 1), (3, 6, 3),
(4, 4, 1),
(5, 1, 2), (5, 2, 1),
(6, 5, 5), (6, 3, 1),
(7, 7, 2),
(8, 6, 1);

select * from categories;

select * from orders where status = 'Completed';

select * from products order by price desc;

select * from products order by price desc limit 5 offset 2;

select p.product_id, p.product_name, p.price, c.category_name
from products p
join categories c on p.category_id = c.category_id;

select o.order_id, o.order_date, c.customer_name, o.status
from orders o
join customers c on o.customer_id = c.customer_id;

select o.order_id, o.order_date, sum(oi.quantity) as tong_so_luong
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_id, o.order_date
order by o.order_id;

select c.customer_id, c.customer_name, count(o.order_id) as so_don_hang
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by so_don_hang desc;

select c.customer_id, c.customer_name, count(o.order_id) as so_don_hang
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(o.order_id) >= 2;

select 
    c.category_name,
    avg(p.price) as gia_trung_binh,
    min(p.price) as gia_thap_nhat,
    max(p.price) as gia_cao_nhat,
    count(p.product_id) as so_san_pham
from categories c
join products p on c.category_id = p.category_id
group by c.category_id, c.category_name
order by gia_trung_binh desc;

select product_name, price
from products
where price > (select avg(price) from products);

select customer_name, email
from customers
where customer_id in (select distinct customer_id from orders);

select o.order_id, o.order_date, sum(oi.quantity) as tong_so_luong
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_id, o.order_date
having sum(oi.quantity) = (
    select sum(quantity)
    from order_items
    group by order_id
    order by sum(quantity) desc
    limit 1
);

select distinct c.customer_name
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
join categories cat on p.category_id = cat.category_id
where cat.category_id = (
    select category_id
    from (
        select cat.category_id
        from categories cat
        join products p on cat.category_id = p.category_id
        group by cat.category_id
        order by avg(p.price) desc
        limit 1
    ) as temp
);

select 
    customer_name,
    tong_so_luong_mua
from (
    select 
        c.customer_id,
        c.customer_name,
        sum(oi.quantity) as tong_so_luong_mua
    from customers c
    join orders o on c.customer_id = o.customer_id
    join order_items oi on o.order_id = oi.order_id
    group by c.customer_id, c.customer_name
) as khach_hang_mua
order by tong_so_luong_mua desc;

select product_name, price
from products
where price = (select max(price) from products);
