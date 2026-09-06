/*
	SQL Join
	==========
	1. Inner Join
	2. Left Join
	3. Right Join
	4. Outer Join
	5. Self Join
	6. Natural Join
	7. Cross Join

	syntax
	=========
	select
		t1.col1, t1.col2, t1.col3, t2.col4
	from table1 t1
	join table2 t2
	on t1.pk = t2.fk;

	ambigious column col1.
*/

select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
	sc.email, sc.street, sc.city, sc.state, sc.zip_code,
	so.order_status, so.customer_id, so.order_date, so.required_date, so.shipped_date
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id;

-- Find total amount spent by each customers. Display customer full name and total price.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, 
	sum((soi.list_price * soi.quantity) * (1 - soi.discount)) as total_price
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
group by CONCAT(sc.first_name, ' ', sc.last_name)
order by total_price desc;


select
	first_name, count(pp.product_id) as total_product
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on soi.product_id = pp.product_id
group by first_name;

select
	first_name, count(pp.product_id) as total_product
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.stores ss
on ss.store_id = so.store_id
join production.stocks ps
on ps.store_id = ss.store_id
join production.products pp
on ps.product_id = pp.product_id
group by first_name;


select * from sales.customers; -- 1445

select * from sales.orders; --1615
-- 2333675

select 
	*
from sales.customers
cross join sales.orders;

-- Find customer name and product name they have bought and from which store they orderd that product.
-- Only show those orders from 2017 which has been delivered successfully.

select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, pp.product_name, ss.store_name
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.stores ss
on ss.store_id = so.store_id
join production.stocks ps
on ps.store_id = ss.store_id
join production.products pp
on ps.product_id = pp.product_id
where YEAR(order_date) = 2017 and order_status = 4;
 

 -- Self Join
 -- Find manager name and staff names.
 select 
	CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
	CONCAT(s2.first_name, ' ', s2.last_name) as staff_name
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Find total staffs and total customers handled by each manager.
select
	CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
	count(distinct s2.staff_id) as total_staffs,
	count(distinct sc.customer_id) as total_customers
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id
join sales.orders so
on s1.staff_id = so.staff_id
join sales.customers sc
on sc.customer_id = so.customer_id
group by CONCAT(s1.first_name, ' ', s1.last_name);


-- Left Join
select
	*
from sales.customers sc
left join sales.orders so
on sc.customer_id = so.customer_id;

select
	*
from sales.staffs s1
left join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Right Join
select
	*
from sales.staffs s1
right join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Outer Join
select
	*
from sales.staffs s1
full outer join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Natural Join
select
	*
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id;

select
	sc.first_name, sc.last_name, sc.state, so.order_status, so.order_date, soi.list_price
from sales.customers sc, sales.orders so, sales.order_items soi
where sc.customer_id = so.customer_id
	and so.order_id = soi.order_id
	and sc.state = 'TX' and so.order_status = 2;





