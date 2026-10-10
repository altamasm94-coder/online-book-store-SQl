drop table if exists books ; 

create table if not exists books(
	Book_ID	serial	primary key ,
	Title	varchar(100)	,
	Author	varchar(100)	,
	Genre	varchar(100)	,
	Published_Year	int ,
	Price	numeric(10,2)	,
	Stock	int 	

);

drop table if exists customers ;
create table if not exists customers (				
	Customer_ID	serial 	primary key ,		
	Name	varchar(100)	,		
	Email	varchar(100)	,		
	Phone	varchar(50)	,		
	City	varchar(100)	,		
	Country	varchar(150)			
);

drop table if exists orders ;
create table if not exists orders ( 
	
	Order_ID serial primary key ,
	Customer_ID int references customers (customer_ID) ,
	Book_ID int references books (book_ID) , 
	Order_Date date ,
	Quantity int ,
	Total_Amount numeric (10,2)

);

select * from books ; 
select * from customers ;
select * from orders ;

 -- copy / import books data 
copy books (Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
from 'C:/postgresql/Books.csv'
delimiter ','
csv header ;


 -- copy / import customers data 
copy customers (Customer_ID,Name,Email,Phone,City,Country)
from 'C:/postgresql/Customers.csv'
delimiter ','
csv header ;


 -- copy / import orders data 
copy orders (Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'C:/postgresql/Orders.csv'
delimiter ','
csv header ;


-- retrive all books in the "fiction" genre ,
select * from books
where genre = 'Fiction';

-- find books published after 1950 ,

select title 
from books 
where published_year > 1950 ;

-- ------------------------------------------------

select * from books ; 
select * from customers ;
select * from orders ;

-- ------------------------------------------------

-- list all customers from canada ,

select name 
from customers 
where country = 'Canada';

-- show all the orders placed in november 2023 ,

select * from orders 
where order_date between '2023-11-01' and '2023-11-30';

-- retrive the total stock of books available ,

select sum (stock) as total_stock_available 
from books ;

-- find the detail of the most expemsive book available ,

select max(price) as most_expensive_book  
from books ;

select * from books order by price desc 
limit 1 ;

-- ------------------------------------------------

select * from books ; 
select * from customers ;
select * from orders ;

-- ------------------------------------------------
	
-- show all customer who ordered more than one quantity of book ,

select * from orders
where quantity > 1 ;

-- retrive all orders where the total exceeds $20 ,

select * from orders 
where total_amount > 20 ;

-- list all the genere available in the books , 

select distinct genre 
from books;

-- find the book with the lowest stock ,

select * from books 
order by stock asc
limit 1 ;

select min (stock)
from books ;

-- ------------------------------------------------

select * from books ; 
select * from customers ;
select * from orders ;

-- ------------------------------------------------
-- calculate the total revenue generated from all orders 

select sum (total_amount) as total_revenue 
from orders ;

-- advance quarries 

-- retrive the total number of books sold for each genre ,

select b.genre ,  sum(o.quantity) as total_books_sold
from books b
join 
orders o 
on b.book_id = o.book_id 
group by b.genre ;

-- ------------------------------------------------

select * from books ; 
select * from customers ;
select * from orders ;

-- ------------------------------------------------

-- find the average price of the books in the fantasy genre
 
select avg (price) as average_price 
from books 
where genre = 'Fantasy';

-- list customers who placed atleast 2 orders 

select c.name , c.customer_id , count (o.order_id) as order_count 
from orders o 
join 
customers c
on 
c.customer_id = o.customer_id
group by c.customer_id , c.name 
having count (order_id) >=2 ;

-- ------------------------------------------------

select * from books ; 
select * from customers ;
select * from orders ;

-- ------------------------------------------------

-- find the most frequently ordered books 

select b.title , b.book_id , count (o.order_id) as copies_sold 
from orders o 
join 
books b
on  b.book_id = o.book_id 
group by b.book_id , b.title 
order by copies_sold desc
limit 1 ;

--top three most expansive book of fantasy genre 

select * 
from books 
where genre = 'Fantasy'
order by price desc 
limit 3 ;

-- ------------------------------------------------

select * from books ; 
select * from customers ;
select * from orders ;

-- ------------------------------------------------
-- retrive the total quantity of books sold by each author 

select b.author , sum (o.quantity) as copies_sold 
from books b 
join 
orders o  
on 
b.book_id = o.book_id 
group by author ;

-- list the cities where customers who spend over $30 are located 

select distinct c.city , total_amount
from orders o
join 
customers c 
on 
c.customer_id = o.customer_id 
where total_amount > 30 

-- find the customer who spend the most on orders 

select c.customer_id , c.name , sum (o.total_amount) as total_spend 
from customers c 
join 
orders o
on  
c.customer_id = o.customer_id 
group by c.customer_id , c.name
order by total_spend desc 
limit 1 ;

-- ------------------------------------------------

select * from books ; 
select * from customers ;
select * from orders ;

-- ------------------------------------------------
-- calculate the stock remaning after full filling the orders 

select b.book_id , b.title , b.stock ,
coalesce (sum(o.quantity),0) as ordered_quantity ,
b.stock - coalesce (sum(o.quantity),0) as remaning_stock 
from books b 
left join 
orders o 
on b.book_id = o.book_id 
group by b.book_id ;

	   