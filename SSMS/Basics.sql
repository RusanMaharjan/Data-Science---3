use BikeStores;

/*
Projection    JOIN       Selection

	SQL Execution Flow
	--------------------
	1. From
	2. Join
	3. Where
	4. Group by
	5. Having
	6. Select
	7. Order by
	8. Limit (MySQL / PgSQL) / Top (SQL Server) / Offset Fetch (SQL Server / Oracle)
*/


select top 5
	customer_id, first_name, last_name, phone, email, street, city, state, zip_code 
from sales.customers
order by city;

-- offset -> number of rows to skip
-- fetch -> extract number of rows after skipping.

select
	customer_id, first_name, last_name, phone, email, street, city, state, zip_code 
from sales.customers
order by city
offset 0 rows fetch next 5 rows only;


-- AND, OR, Between, IN, Like

-- Find order details of 2016 January.
select * from sales.orders where order_date between '2016-01-01' and '2016-01-31';

-- Find product details whose list price is in range of 200 to 800.
select * from production.products where list_price > 200 and list_price < 800;

select * from production.products where list_price between 200 and 800;

-- Find product details of brand 2 and 6.
select * from production.products where brand_id = 2 or brand_id = 6;

select * from production.products where brand_id in (2, 6);

-- Like
-- wildcards (%, _)
select * from production.products;

-- Find product details whose name starts with letter 'T'.
select * from production.products where product_name like 'T%' and product_name like '%2018';

select * from production.products where product_name like '%2018';

select * from production.products where product_name like '___l%';

select * from sales.customers where first_name like '____';


-- Concat Function and Concatenation Operator (+) (Oracle (||))
select
	CONCAT(first_name, ' ', last_name) as full_name
from sales.customers;

select
	(first_name + ' ' + last_name) as full_name
from sales.customers;

--Find 'Debra Burks' customer details
select
	CONCAT(first_name, ' ', last_name) as full_name
from sales.customers where CONCAT(first_name, ' ', last_name) = 'Debra Burks';

-- Substring
-- substring(column_name, start_length, number_of_letters)
select 
	first_name, SUBSTRING(first_name, 2, 3) as mid_letters
from sales.customers;

--left and right
select
	first_name, left(first_name, 3) as first_3
from sales.customers;

select
	first_name, right(first_name, 3) as last_3
from sales.customers;


-- customer_id - first_name(3, 2) - last_name (last 4) - email (5, 6) - street (first 2) - city (2, 3) - state - zip_code (2, 3)
select * from sales.customers;


select
	CONCAT(
		customer_id, '-', SUBSTRING(first_name, 3, 2), '-', right(last_name, 4), '-', SUBSTRING(email, 5, 6),
		'-', left(street, 2), '-', SUBSTRING(city, 2, 3), '-', state, '-', SUBSTRING(zip_code, 2, 3)
	) as cust_id, first_name, last_name, email, street, city, state, zip_code
from sales.customers;

select
	CONCAT(first_name, phone) as data,
	(first_name + phone) as data1
from sales.customers;

select 
	--concat(product_name, '------', list_price) as p_data
	(product_name + '------' + list_price) as p_data
from production.products;


--Time Series Analysis / Cohort Analysis
select
	order_date,
	Year(order_date) as o_year,
	Month(order_date) as o_month,
	Day(order_date) as o_day,
	DATENAME(MONTH, order_date) as or_month,
	DATENAME(WEEKDAY, order_date) as or_day,
	DATEPART(WEEKDAY, order_date) as dp_day,
	DATEPART(WEEK, order_date) as dp_wk,
	DATEPART(QUARTER, order_date) as dp_qt,
	FORMAT(order_date, 'MMMM') as order_month,
	FORMAT(order_date, 'dddd') as order_day
from sales.orders;

select
	order_date, shipped_date,
	DATEDIFF(day, order_date, isnull(shipped_date, getdate())) as day_diff,
	DATEDIFF(MONTH, order_date, isnull(shipped_date, getdate())) as month_diff,
	DATEADD(day, 3, order_date) as add_day
from sales.orders;


-- IsNull
-- Coalesce


-- To fill data temporarily
select
	shipped_date, 
	ISNULL(shipped_date, GETDATE()),
	Coalesce(shipped_date, GetDate())
from sales.orders;

-- SQL Case
/*
	select
		case
			when condition then value
			when condition then value
		end
	from table_name;
*/

/*
	0 - 1000 -> Low Price Product
	1001 - 2500 -> Average Price Product
	> 2500 -> High Price Product
*/
select
	product_id, product_name, model_year, list_price,
	case
		when list_price <= 1000 then 'Low Price Product'
		--when list_price > 1000 and list_price <= 2500 then 'Average Price Product'
		when list_price between 1000 and 2500 then 'Average Price Product'
		when list_price > 2500 then 'High Price Product'
		Else 'Invalid data'
	End as price_label
from production.products
order by list_price desc;


--1 -> Pending, 2 -> Processing, 3 -> Rejected, 4 -> Completed
/*
Find order details and show order status label. After labeling filter data showing orders which is currently 
in processing and also show how many exact days required to deliver that order.
*/
select
	order_id, order_date, required_date, order_status, DATEDIFF(day, order_date, required_date) as days_to_deliver,
	case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
	End as order_status_label
from sales.orders
where order_status = 2;

/*
	- Find order item details and its total price. For each item purchased by customer 13% of vat must be added in 
	total price. After calculating total price show price label as:
	i. 0 - 3000 -> Low Price Purchase
	ii. > 3000 to 8000 -> Average Price Purchase
	iii. > 8000 -> High Price Purchase
*/
select 
	order_id, item_id, product_id, quantity, list_price, discount,
	(((list_price * quantity) * (1 - discount))*1.13) as total_price,
	case
		when (((list_price * quantity) * (1 - discount))*1.13) between 0 and 3000 then 'Low Price Purchase'
		when (((list_price * quantity) * (1 - discount))*1.13) > 3000 and (((list_price * quantity) * (1 - discount))*1.13) <= 8000 then 'Average Price Purchase'
		when (((list_price * quantity) * (1 - discount))*1.13) > 8000 then 'High Price Purchase'
	End as price_label
from sales.order_items;




