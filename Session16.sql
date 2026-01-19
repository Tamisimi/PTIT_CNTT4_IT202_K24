
create database quanlybanhang;
use quanlybanhang;

create table customers (
    customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);

create table products (
    product_id int auto_increment primary key,
    product_name varchar(100) not null unique,
    price decimal(10,2) not null,
    quantity int not null check (quantity >= 0),
    category varchar(50) not null
);

create table employees (
    employee_id int auto_increment primary key,
    employee_name varchar(100) not null,
    birthday date,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);

create table orders (
    order_id int auto_increment primary key,
    customer_id int not null,
    employee_id int not null,
    order_date datetime default current_timestamp,
    total_amount decimal(10,2) default 0,
    foreign key (customer_id) references customers(customer_id),
    foreign key (employee_id) references employees(employee_id)
);

create table orderdetails (
    order_detail_id int auto_increment primary key,
    order_id int not null,
    product_id int not null,
    quantity int not null check (quantity > 0),
    unit_price decimal(10,2) not null,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

-- cau 3: 
alter table customers
add column email varchar(100) not null unique after customer_name;

alter table employees
drop column birthday;

-- cau 4: chen du lieu mau 
insert into customers (customer_name, email, phone, address) values
('nguyen van a', 'a@gmail.com', '0901234567', 'ha noi'),
('tran thi b', 'b@gmail.com', '0912345678', 'tp.hcm'),
('le van c', 'c@gmail.com', '0923456789', null),
('pham thi d', 'd@gmail.com', '0934567890', 'da nang'),
('hoang van e', 'e@gmail.com', '0945678901', 'hai phong');

insert into products (product_name, price, quantity, category) values
('iphone 14', 18990000.00, 50, 'dien thoai'),
('laptop gaming', 25990000.00, 20, 'laptop'),
('tai nghe sony', 1490000.00, 120, 'phu kien'),
('chuot logitech', 490000.00, 200, 'phu kien'),
('ban phim co', 890000.00, 80, 'phu kien');

insert into employees (employee_name, position, salary, revenue) values
('nguyen quan ly', 'quan ly', 15000000.00, 0),
('tran sales 1', 'nhan vien ban hang', 8000000.00, 0),
('le sales 2', 'nhan vien ban hang', 7500000.00, 0),
('pham ky thuat', 'ky thuat vien', 9000000.00, 0),
('hoang thu ngan', 'thu ngan', 6500000.00, 0);

insert into orders (customer_id, employee_id) values
(1,2), (2,2), (3,3), (1,2), (4,3);

insert into orderdetails (order_id, product_id, quantity, unit_price) values
(1,1,2,18990000.00),
(1,3,1,1490000.00),
(2,2,1,25990000.00),
(3,4,3,490000.00),
(4,5,2,890000.00);

-- cau 5: truy van co ban
select customer_id, customer_name, email, phone, address from customers;

update products 
set product_name = 'laptop dell xps', price = 99.99
where product_id = 1;

select 
    o.order_id,
    c.customer_name,
    e.employee_name,
    o.total_amount,
    o.order_date
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id;

-- cau 6: truy van day du
select 
    c.customer_id,
    c.customer_name,
    count(o.order_id) as tong_so_don
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;

select 
    e.employee_id,
    e.employee_name,
    coalesce(sum(o.total_amount), 0) as doanh_thu
from employees e
left join orders o on e.employee_id = o.employee_id
where year(o.order_date) = year(curdate())
group by e.employee_id, e.employee_name;

select 
    p.product_id,
    p.product_name,
    sum(od.quantity) as so_luot_dat
from products p
join orderdetails od on p.product_id = od.product_id
join orders o on od.order_id = o.order_id
where month(o.order_date) = month(curdate())
group by p.product_id, p.product_name
having so_luot_dat > 100
order by so_luot_dat desc;

-- cau 7: truy van nang cao
select customer_id, customer_name
from customers
where customer_id not in (select customer_id from orders);

select product_id, product_name, price
from products
where price > (select avg(price) from products);

select 
    c.customer_id,
    c.customer_name,
    coalesce(sum(o.total_amount), 0) as tong_chi_tieu
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by tong_chi_tieu desc;

-- cau 8: tao view
create view view_order_list as
select 
    o.order_id,
    c.customer_name,
    e.employee_name,
    o.total_amount,
    o.order_date
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id
order by o.order_date desc;

create view view_order_detail_product as
select 
    od.order_detail_id,
    p.product_name,
    od.quantity,
    od.unit_price
from orderdetails od
join products p on od.product_id = p.product_id
order by od.quantity desc;

-- cau 9: tao thu tuc
delimiter //
create procedure proc_insert_employee(
    in p_name varchar(100),
    in p_position varchar(50),
    in p_salary decimal(10,2)
)
begin
    insert into employees (employee_name, position, salary)
    values (p_name, p_position, p_salary);
    select last_insert_id() as new_employee_id;
end //
delimiter ;

delimiter //
create procedure proc_get_orderdetails(in p_order_id int)
begin
    select * from orderdetails where order_id = p_order_id;
end //
delimiter ;

-- cau 10: trigger cap nhat ton kho
delimiter //
create trigger trigger_after_insert_order_details
after insert on orderdetails
for each row
begin
    declare current_qty int;
    select quantity into current_qty from products where product_id = new.product_id;
    
    if current_qty < new.quantity then
        signal sqlstate '45000' set message_text = 'so luong san pham trong kho khong du';
    else
        update products set quantity = quantity - new.quantity 
        where product_id = new.product_id;
    end if;
end //
delimiter ;

-- cau 11: thu tuc voi transaction
delimiter //
create procedure proc_insert_order_details(
    in p_order_id int,
    in p_product_id int,
    in p_quantity int,
    in p_unit_price decimal(10,2)
)
begin
    declare exit handler for sqlexception 
    begin
        rollback;
        signal sqlstate '45000' set message_text = 'co loi xay ra, da rollback';
    end;

    start transaction;

    if not exists (select 1 from orders where order_id = p_order_id) then
        signal sqlstate '45000' set message_text = 'khong ton tai ma hoa don';
    end if;

    insert into orderdetails (order_id, product_id, quantity, unit_price)
    values (p_order_id, p_product_id, p_quantity, p_unit_price);

    update orders 
    set total_amount = total_amount + (p_quantity * p_unit_price)
    where order_id = p_order_id;

    commit;
end //
delimiter ;

