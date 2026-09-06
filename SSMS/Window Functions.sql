select * from [Fraud Detection Dataset];

/*
	Window Functions
	----------------------
	Row Number -> Duplicate Data
	Rank -> Data Ranking -> Skip Value
	Dense Rank -> Data Ranking -> Doesnot skip value

	
	-- Accepts arguments
	NTile -> divides data
	Lead -> Next Value
	Lag -> Previous

	syntax
	-------------
	select
		col1, col2, col3, window_function() Over(partition by col_name order_by col_name asc/desc)
	from table_name;
*/
-- Row Number
-- Finding duplicate records using row number.
select
	Transaction_ID, user_id, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
	Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
	Payment_Method, Fraudulent,
	ROW_NUMBER() Over(partition by Transaction_ID order by transaction_amount) as rn
from [Fraud Detection Dataset];

-- Removing duplicate records
with fraud_duplicate_data as (
	select
		Transaction_ID, user_id, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
		Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
		Payment_Method, Fraudulent,
		ROW_NUMBER() Over(partition by Transaction_ID order by transaction_amount) as rn
	from [Fraud Detection Dataset]
)
delete from fraud_duplicate_data where rn > 1;


-- Rank
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	RANK() Over(partition by brand_id order by list_price)
from production.products;

-- Dense Rank
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	DENSE_RANK() Over(partition by brand_id order by list_price)
from production.products;

select product_id, product_name, brand_id, category_id, model_year, list_price from (
	select
		product_id, product_name, brand_id, category_id, model_year, list_price,
		DENSE_RANK() Over(order by list_price desc) as rn
	from production.products
) as data
where rn = 3;


-- NTile
select 
	Transaction_ID, user_id, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
	Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
	Payment_Method, Fraudulent,
	NTILE(10) Over(partition by Time_of_Transaction order by transaction_amount)
from [Fraud Detection Dataset];

-- Lead
select 
	Transaction_ID, user_id, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
	Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
	Payment_Method, Fraudulent,
	Lead(Transaction_Type) Over(order by transaction_amount)
from [Fraud Detection Dataset];

-- Lag
select 
	Transaction_ID, user_id, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
	Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
	Payment_Method, Fraudulent,
	Lag(Transaction_Type) Over(order by transaction_amount)
from [Fraud Detection Dataset];


select
	*
from sales.stores;

-- index
-- create index idx_name on table (column_name);

create index idx_store_name on sales.stores(store_name);

-- Views
create view customer_rejected_orders as
select
	sc.customer_id, sc.first_name, sc.last_name, sc.phone, sc.email, sc.street,
	sc.city, sc.state, sc.zip_code
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where so.order_status = 3;

select * from customer_rejected_orders;

select * from cro;

-- synonym
create synonym cro for customer_rejected_orders;


-- Stored Procedure
--create procedure customer_orders
--as
--Begin
--	select
--		sc.customer_id, sc.first_name, sc.last_name, sc.phone, sc.email, sc.street,
--		sc.city, sc.state, sc.zip_code
--	from sales.customers sc
--	join sales.orders so
--	on sc.customer_id = so.customer_id
--	where so.order_status = 3;
--End;

create or alter procedure customer_orders (
	@state_name varchar(max)
)
as
Begin
	select
		sc.customer_id, sc.first_name, sc.last_name, sc.phone, sc.email, sc.street,
		sc.city, sc.state, sc.zip_code
	from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	where so.order_status = 3
	and state = @state_name;
End;

exec customer_orders 'CA';







