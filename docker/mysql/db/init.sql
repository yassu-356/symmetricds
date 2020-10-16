drop database if exists sample;

create database sample;
use sample;

create table item(
  item_id int primary key,
  name varchar(100)
);

create table item_selling_price(
  item_id int not null,
  store_id varchar(5) not null,
  price decimal(10,2) not null,
  cost decimal(10,2),
  primary key(item_id,store_id),
  foreign key fk_price_item_id(item_id) references item(item_id)
);

create table sale_transaction(
  tran_id int primary key,
  store_id varchar(5) not null,
  workstation varchar(3) not null,
  day varchar(10) not null,
  seq int not null
);
create table sale_return_line_item(
  tran_id int not null,
  item_id int not null,
  price decimal(10,2) not null,
  quantity int not null,
  returned_quantity int,
  primary key(tran_id,item_id),
  foreign key fk_sril_tran_id(tran_id) references sale_transaction(tran_id),
  foreign key fk_sril_item_id(item_id) references item(item_id)
);

-- Items to sell and their prices
insert into item (item_id, name) values (11000001, 'Yummy Gum');
insert into item_selling_price (item_id, store_id, price, cost) values (11000001, '001',0.20, 0.10);
insert into item_selling_price (item_id, store_id, price, cost) values (11000001, '002',0.30, 0.20);

-- Sales transactions and line items
insert into sale_transaction (tran_id, store_id, workstation, day, seq)
values (900, '001', '3', '2012-12-01', 90);
insert into sale_return_line_item (tran_id, item_id, price, quantity, returned_quantity)
values (900, 11000001, 0.20, 1, 0);
