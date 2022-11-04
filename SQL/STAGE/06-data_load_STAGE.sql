use ecommerce_db_stage;

DELIMITER ;;

CREATE PROCEDURE printf(thetext TEXT)
BEGIN

  select thetext as ``;

 END;

;;

delimiter ;

delimiter //

create procedure sp_data_load_STAGE ()
begin
	-- tabela temporária que irá ter a média das latitudes e longitudes baseados nos 5 dígitos do CEP
	CREATE TEMPORARY TABLE IF NOT EXISTS TEMP_tb_geolocation 
	(
	geolocation_zip_code_prefix VARCHAR(5) NOT NULL,
	geolocation_lat DECIMAL(20,18) NOT NULL,
	geolocation_lng DECIMAL(20,18) NOT NULL
	); 

	call printf('Tabela temporária criada');

	delete from TEMP_tb_geolocation;

	insert into TEMP_tb_geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng)
	select geolocation_zip_code_prefix, avg(geolocation_lat), avg(geolocation_lng) from ecommerce_db.tb_geolocation
	group by geolocation_zip_code_prefix;

	call printf('Dados inseridos na tabela temporária');
	
	-- CUSTOMERS
	insert into ST_CUSTOMERS (customer_id, customer_unique_id, customer_city, customer_state, geolocation_lat, geolocation_lng)
	select c.customer_id, c.customer_unique_id, c.customer_city, c.customer_state, g.geolocation_lat, g.geolocation_lng 
	from ecommerce_db.tb_customers c
	left join TEMP_tb_geolocation g on g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
	where c.customer_id not in (select c.customer_id from ST_CUSTOMERS);

	call printf('Dados inseridos na tabela ST_CUSTOMERS');

	-- PRODUCTS
	insert into ST_PRODUCTS (product_id,product_category_name,product_name_lenght,product_description_lenght,
		product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm)
	select product_id,product_category_name,product_name_lenght,product_description_lenght,
		product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm 
	from ecommerce_db.tb_products 
	where product_id not in (select product_id from ST_PRODUCTS);

	call printf('Dados inseridos na tabela ST_PRODUCTS');

	update ST_PRODUCTS ps
	inner join ecommerce_db.tb_products p on 
	p.product_id = ps.product_id
	set 
	ps.product_category_name = p.product_category_name,
	ps.product_name_lenght = p.product_name_lenght,
	ps.product_description_lenght = p.product_description_lenght,
	ps.product_photos_qty = p.product_photos_qty,
	ps.product_weight_g = p.product_weight_g,
	ps.product_length_cm = p.product_length_cm,
	ps.product_height_cm = p.product_height_cm,
	ps.product_width_cm = p.product_width_cm
	where 
	ps.product_category_name <> p.product_category_name
	or ps.product_name_lenght <> p.product_name_lenght
	or ps.product_description_lenght <> p.product_description_lenght
	or ps.product_photos_qty <> p.product_photos_qty
	or ps.product_weight_g <> p.product_weight_g
	or ps.product_length_cm <> p.product_length_cm
	or ps.product_height_cm <> p.product_height_cm
	or ps.product_width_cm <> p.product_width_cm;

	delete from ST_PRODUCTS
	where product_id not in (select product_id from ecommerce_db.tb_products );

	call printf('Dados atualizados na tabela ST_PRODUCTS');

	-- SELLERS
	insert into ST_SELLERS (seller_id, seller_city, seller_state, seller_zip_code_prefix,geolocation_lat, geolocation_lng)
	select s.seller_id, s.seller_city, s.seller_state, s.seller_zip_code_prefix, g.geolocation_lat, g.geolocation_lng
	from ecommerce_db.tb_sellers s
	left join TEMP_tb_geolocation g on g.geolocation_zip_code_prefix = s.seller_zip_code_prefix
	where s.seller_id not in (select seller_id from ST_SELLERS);

	call printf('Dados inseridos na tabela ST_SELLERS');

	update ST_SELLERS ss
	inner join ecommerce_db.tb_sellers s on
	s.seller_id =  ss.seller_id
	left join TEMP_tb_geolocation g on 
	g.geolocation_zip_code_prefix = s.seller_zip_code_prefix
	set 
	ss.seller_city = s.seller_city, 
	ss.seller_state = s.seller_state,
	ss.seller_zip_code_prefix = s.seller_zip_code_prefix,  
	ss.geolocation_lat = g.geolocation_lat, 
	ss.geolocation_lng = g.geolocation_lng
	where 
	s.seller_city <> ss.seller_city
	or s.seller_state <> ss.seller_state
	or s.seller_zip_code_prefix <> ss.seller_zip_code_prefix
	or g.geolocation_lat <> ss.geolocation_lat
	or g.geolocation_lng <> ss.geolocation_lng;

	call printf('Dados atualizados na tabela ST_SELLERS');

	-- ORDERS
	insert into ST_ORDERS (order_id, order_status )
	select order_id, order_status
	from ecommerce_db.tb_orders
	where order_id not in (select order_id from ST_ORDERS);

	call printf('Dados inseridos na tabela ST_ORDERS');

	update ST_ORDERS os
	inner join ecommerce_db.tb_orders  o on 
	o.order_id = os.order_id
	set os.order_status = o.order_status	
	where 
	o.order_status <> os.order_status;

	call printf('Dados atualizados na tabela ST_ORDERS');

	-- ST_PAYMENT_TYPES
	insert into ST_PAYMENT_TYPES ( payment_type )
	select distinct payment_type
	from ecommerce_db.tb_order_payments
	where payment_type not in (select payment_type from ST_PAYMENT_TYPES);

	call printf('Dados inseridos na tabela ST_PAYMENT_TYPES');

	-- ST_PAYMENTS
	insert into ST_PAYMENTS (order_id, customer_id, payment_type_id, payment_installments, payment_value,
	order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, 
	order_estimated_delivery_date )
	select p.order_id, c.customer_id, pt.payment_type_id, p.payment_installments, p.payment_value,
	o.order_purchase_timestamp, o.order_approved_at, o.order_delivered_carrier_date, o.order_delivered_customer_date, 
	o.order_estimated_delivery_date
	from ecommerce_db.tb_order_payments p
	inner join ecommerce_db.tb_orders o on o.order_id = p.order_id
	inner join ST_PAYMENT_TYPES pt on pt.payment_type = p.payment_type
	inner join ecommerce_db.tb_customers c on c.customer_id = o.customer_id
	where p.order_id not in (select order_id from ST_PAYMENTS);

	call printf('Dados inseridos na tabela ST_PAYMENTS');

	update ST_PAYMENTS ps
	inner join ecommerce_db.tb_orders o on 
	o.order_id = ps.order_id
	set 
	ps.order_approved_at = o.order_approved_at, 
	ps.order_delivered_carrier_date = o.order_delivered_carrier_date, 
	ps.order_delivered_customer_date = o.order_delivered_customer_date, 
	ps.order_estimated_delivery_date = o.order_estimated_delivery_date
	where 
	ps.order_approved_at <> o.order_approved_at 
	or ps.order_delivered_carrier_date <> o.order_delivered_carrier_date
	or ps.order_delivered_customer_date <> o.order_delivered_customer_date 
	or ps.order_estimated_delivery_date <> o.order_estimated_delivery_date;

	call printf('Dados atualizados na tabela ST_PAYMENTS');

	-- ST_REVIEWS
	insert into ST_REVIEWS (id_tb_order_reviews,order_id, customer_id,  order_purchase_timestamp, order_approved_at, 
	order_delivered_carrier_date, order_delivered_customer_date,  order_estimated_delivery_date,
	review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp )
	select r.id_tb_order_reviews, o.order_id, c.customer_id,  o.order_purchase_timestamp, o.order_approved_at, 
	o.order_delivered_carrier_date, o.order_delivered_customer_date,  o.order_estimated_delivery_date,
	r.review_score, r.review_comment_title, r.review_comment_message, r.review_creation_date, r.review_answer_timestamp
	from ecommerce_db.tb_order_reviews r
	inner join ecommerce_db.tb_orders o on o.order_id = r.order_id
	inner join ecommerce_db.tb_customers c on c.customer_id = o.customer_id
	where r.id_tb_order_reviews not in (select id_tb_order_reviews from ST_REVIEWS);

	call printf('Dados inseridos na tabela ST_REVIEWS');

	update ST_REVIEWS rs
	inner join ecommerce_db.tb_orders o on
	o.order_id = rs.order_id
	set 
	rs.order_approved_at = o.order_approved_at, 
	rs.order_delivered_carrier_date = o.order_delivered_carrier_date, 
	rs.order_delivered_customer_date = o.order_delivered_customer_date, 
	rs.order_estimated_delivery_date = o.order_estimated_delivery_date
	where 
	rs.order_approved_at <> o.order_approved_at 
	or rs.order_delivered_carrier_date <> o.order_delivered_carrier_date
	or rs.order_delivered_customer_date <> o.order_delivered_customer_date 
	or rs.order_estimated_delivery_date <> o.order_estimated_delivery_date;

	call printf('Dados atualizados na tabela ST_REVIEWS');

	-- ST_ITEMS
	insert into ST_ITEMS (order_id, customer_id, product_id, seller_id, order_purchase_timestamp, 
	order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date, 
	shipping_limit_date, price, freight_value)
	select oi.order_id, c.customer_id, oi.product_id, oi.seller_id, o.order_purchase_timestamp, 
	o.order_approved_at, o.order_delivered_carrier_date, o.order_delivered_customer_date, o.order_estimated_delivery_date, 
	oi.shipping_limit_date, oi.price, oi.freight_value
	from ecommerce_db.tb_order_items oi
	inner join ecommerce_db.tb_orders o on o.order_id = oi.order_id
	inner join ecommerce_db.tb_customers c on c.customer_id = o.customer_id
	where oi.order_id not in (select order_id from ST_ITEMS);

	call printf('Dados inseridos na tabela ST_ITEMS');

	update ST_ITEMS its
	inner join ecommerce_db.tb_orders o on
	o.order_id = its.order_id
	set 
	its.order_approved_at = o.order_approved_at, 
	its.order_delivered_carrier_date = o.order_delivered_carrier_date, 
	its.order_delivered_customer_date = o.order_delivered_customer_date, 
	its.order_estimated_delivery_date = o.order_estimated_delivery_date
	where
	its.order_approved_at <> o.order_approved_at 
	or its.order_delivered_carrier_date <> o.order_delivered_carrier_date
	or its.order_delivered_customer_date <> o.order_delivered_customer_date 
	or its.order_estimated_delivery_date <> o.order_estimated_delivery_date;

	call printf('Dados atualizados na tabela ST_ITEMS');
end;
//
delimiter ;
