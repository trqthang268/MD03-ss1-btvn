# create schema new_schema1;
use new_schema1;
create table Customer
(
    customerId   int primary key auto_increment not null,
    customerName varchar(100) not null,
    customerAge  int not null
);

create table Oder
(
    orderId int primary key auto_increment unique not null,
    customerId int,
    foreign key (customerId) references Customer(customerId),
    orderDate date not null,
    orderTotalPrice decimal(10,2)
);

create table Product(
    productId int primary key auto_increment unique not null,
    productName varchar(100) unique not null,
    productPrice decimal(10,2)
);

create table OrderDetail(
    orderId int,
    foreign key (orderId) references Oder(orderId),
    productId int,
    foreign key (productId) references Product(productId),
    odQTY int not null check (odQTY >0)
);

insert into Customer(customerName, customerAge) values('Nguyễn Văn A',18),
('Nguyễn Văn B',16),('Nguyễn Văn C',21),('Nguyễn Văn D',20),('Nguyễn Văn E',21);
select * from Customer;

insert into Oder values(1,1,'2023-02-21',11.22);
insert into Oder (orderId, customerId, orderDate, orderTotalPrice) values(2,1,'2012-01-30',10.11),
(3,2,'2022-01-12',12.11),(4,3,'2023-11-11',12.19);
select * from Oder;

insert into Product(productName,productPrice) values('quan',10),('ao',11),('trang suc',9);
select * from Product;

insert into OrderDetail(orderId,productId,odQTY) values(1,1,4),(1,3,4),(2,3,4);
select * from OrderDetail;