/*
	SubQuery
	----------
	1. Single Row SubQuery
		- If inner query provides with single row and single column data
		- Comparison Operator -> =, !=, <, >, <=, >=

	2. Multi Row SubQuery
		- If inner query provides with multiple row and single column data
		-> In, (Any, All -> Comparison Operator)

	select * from table_name where col_name < (select col_name from table_name);
*/

-- Find all product details whose price is less than its average list price.

select AVG(list_price) as avg_price from production.products;

select * from production.products
where list_price < 1520.591401;


select
	*
from production.products where list_price <  (
	select avg(list_price) from production.products
);


-- Find second highest list price from product details.
select * from production.products where list_price = (
	select max(list_price) from production.products where list_price < (
		select max(list_price) from production.products where list_price < (
			select max(list_price) from production.products
		)
	)
);

-- Find customer details whose orders has been rejected.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, sc.email, sc.street, sc.city, sc.state, sc.zip_code
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where order_status = 3;


select 
	CONCAT(first_name, ' ', last_name) as customer_name, email, street, city, state, zip_code
from sales.customers where customer_id in (
	select customer_id from sales.orders where order_status = 3
);


-- Find customer details whose order status is completed and who has spent more than 8000 in total.
select top 5
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, sc.email, sc.street, sc.city, sc.state, sc.zip_code
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on soi.order_id = so.order_id
where order_status = 4
and ((soi.list_price * soi.quantity) * (1 - soi.discount)) > 8000
order by ((soi.list_price * soi.quantity) * (1 - soi.discount)) desc;


select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, sc.email, sc.street, sc.city, sc.state, sc.zip_code
from sales.customers sc where customer_id in (
	select top 5
		so.customer_id
	from sales.order_items soi join
	sales.orders so
	on soi.order_id = so.order_id
	where order_status = 4
	and ((list_price * quantity) * (1 - discount)) > 8000
	order by ((list_price * quantity) * (1 - discount)) desc
);

/*
	ANY -> OR
	All -> AND
*/
select * from production.products
order by list_price asc;


-- Find all proudcts whose list price is less than 209.99 / 250.99.

select
	*
from production.products
where list_price < any (
	select list_price from production.products where list_price in (209.99, 250.99)
) order by list_price;

-- Find all products whose list price is less than 209.99 and 250.99.
select
	*
from production.products
where list_price < all (
	select list_price from production.products where list_price in (209.99, 250.99)
) order by list_price;

-- Find customer details who bought products whose price is less than 209.99 and 250.99.
select first_name, last_name, email, state, city, street, zip_code from sales.customers where
customer_id in (
	select customer_id from sales.orders where order_id in (
		select order_id from sales.order_items where product_id in (
			select product_id from production.products
			where list_price < all (
				select list_price from production.products where list_price in (209.99, 250.99)
			)
		)
	)
);

-- Find staff details who have managed orders which was rejected and sold products whose price is more than 1000
-- whose model year is 2017.

select first_name, last_name, email, phone from sales.staffs where staff_id in (
	select staff_id from sales.orders where order_id in (
		select order_id from sales.order_items where product_id in (
			select product_id from production.products where list_price > 1000 and model_year = 2017
		)
	) and order_status = 3
);