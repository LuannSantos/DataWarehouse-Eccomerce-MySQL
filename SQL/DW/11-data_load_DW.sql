use ecommerce_db_dw;

DELIMITER ;;

CREATE PROCEDURE printf(thetext TEXT)
BEGIN

  select thetext as ``;

 END;

;;

delimiter ;

delimiter //


create procedure sp_data_load_DW ()
begin

	-- DIM_CUSTOMERS
	insert into DIM_CUSTOMERS (customer_id, customer_unique_id, customer_city, customer_state, geolocation_lat, geolocation_lng)
	select c.customer_id, c.customer_unique_id, c.customer_city, c.customer_state, c.geolocation_lat, c.geolocation_lng
	from ecommerce_db_stage.ST_CUSTOMERS c
	where c.customer_id not in (select customer_id from DIM_CUSTOMERS);

	call printf('Dados inseridos na tabela DIM_CUSTOMERS');

	-- DIM_PRODUCTS

	-- Seta valor em variável que será usada para a coluna INICIO
	SET @countProducts = (select count(*) from DIM_PRODUCTS);
	
	insert into DIM_PRODUCTS (product_id,product_category_name,product_name_lenght,product_description_lenght,
		product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm, INICIO)
	select product_id,product_category_name,product_name_lenght,product_description_lenght,
		product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm, 
		if (@countProducts > 0, now(), "20160101")
	from ecommerce_db_stage.ST_PRODUCTS
	where product_id not in (select product_id from DIM_PRODUCTS);

	call printf('Dados inseridos na tabela DIM_PRODUCTS');

	update DIM_PRODUCTS pd
	inner join ecommerce_db_stage.ST_PRODUCTS p 
	on pd.product_id = p.product_id 
	set
	pd.FIM = now()
	where 
	pd.product_category_name <> p.product_category_name
	or pd.product_name_lenght <> p.product_name_lenght
	or pd.product_description_lenght <> p.product_description_lenght
	or pd.product_photos_qty <> p.product_photos_qty
	or pd.product_weight_g <> p.product_weight_g
	or pd.product_length_cm <> p.product_length_cm
	or pd.product_height_cm <> p.product_height_cm
	or pd.product_width_cm <> p.product_width_cm;

	call printf('Finalização de dados antigos na tabela DIM_PRODUCTS');

	insert into DIM_PRODUCTS (product_id,product_category_name,product_name_lenght,product_description_lenght,
		product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm, INICIO)
	select p.product_id, p.product_category_name, p.product_name_lenght,p.product_description_lenght,
		p.product_photos_qty,p.product_weight_g,p.product_length_cm,p.product_height_cm,p.product_width_cm, now()
	from ecommerce_db_stage.ST_PRODUCTS p
	inner join DIM_PRODUCTS pd on pd.product_id = p.product_id and pd.FIM is null
	where 
	pd.product_category_name <> p.product_category_name
	or pd.product_name_lenght <> p.product_name_lenght
	or pd.product_description_lenght <> p.product_description_lenght
	or pd.product_photos_qty <> p.product_photos_qty
	or pd.product_weight_g <> p.product_weight_g
	or pd.product_length_cm <> p.product_length_cm
	or pd.product_height_cm <> p.product_height_cm
	or pd.product_width_cm <> p.product_width_cm;

	call printf('Dados atualizados na tabela DIM_PRODUCTS');

	-- DIM_SELLERS

	-- Seta valor em variável que será usada para a coluna INICIO
	SET @countSellers = (select count(*) from DIM_SELLERS);

	insert into DIM_SELLERS ( seller_id, seller_city, seller_state, seller_zip_code_prefix, geolocation_lat, geolocation_lng, INICIO)
	select seller_id, seller_city, seller_state, seller_zip_code_prefix ,geolocation_lat, geolocation_lng,
	if( @countSELLERS > 0, now(), "20160101")
	from ecommerce_db_stage.ST_SELLERS
	where seller_id not in (select seller_id from DIM_SELLERS);

	call printf('Dados inseridos na tabela DIM_SELLERS');

	update DIM_SELLERS sd
	inner join ecommerce_db_stage.ST_SELLERS s
	on s.seller_id = sd.seller_id
	set
	sd.FIM = now()
	where 
	s.seller_city <> sd.seller_city
	or s.seller_state <> sd.seller_state
	or s.seller_zip_code_prefix <> sd.seller_zip_code_prefix;

	call printf('Finalização de dados antigos na tabela DIM_SELLERS');

	insert into DIM_SELLERS (seller_id, seller_city, seller_state, seller_zip_code_prefix, geolocation_lat, geolocation_lng, INICIO)
	select s.seller_id, s.seller_city, s.seller_state, s.seller_zip_code_prefix, s.geolocation_lat, s.geolocation_lng, now()
	from ecommerce_db_stage.ST_SELLERS s
	inner join DIM_SELLERS sd on s.seller_id = sd.seller_id and sd.FIM is null
	where 
	s.seller_city <> sd.seller_city
	or s.seller_state <> sd.seller_state
	or s.seller_zip_code_prefix <> sd.seller_zip_code_prefix;

	call printf('Dados atualizados na tabela DIM_SELLERS');

	-- DIM_ORDERS
	insert into DIM_ORDERS (order_id, order_status )
	select order_id, order_status
	from ecommerce_db_stage.ST_ORDERS
	where order_id not in (select order_id from DIM_ORDERS);

	call printf('Dados inseridos na tabela DIM_ORDERS');

	update DIM_ORDERS od
	inner join ecommerce_db_stage.ST_ORDERS  o on 
	o.order_id = od.order_id
	set od.order_status = o.order_status	
	where 
	o.order_status <> od.order_status;

	call printf('Dados atualizados na tabela DIM_ORDERS');

	-- DIM_PAYMENT_TYPES
	insert into DIM_PAYMENT_TYPES ( IDSK,payment_type )
	select payment_type_id, payment_type
	from ecommerce_db_stage.ST_PAYMENT_TYPES
	where payment_type not in (select payment_type from DIM_PAYMENT_TYPES);

	call printf('Dados inseridos na tabela DIM_PAYMENT_TYPES');

	-- FACT_PAYMENTS
	insert into FACT_PAYMENTS (order_id, customer_id, payment_type_id, payment_installments, payment_value,
	order_purchase_timestamp_id, order_approved_at_id, order_delivered_carrier_date_id, order_delivered_customer_date_id, 
	order_estimated_delivery_date_id)
	select o.IDSK, c.IDSK, p.payment_type_id, p.payment_installments, p.payment_value,
	opt.IDSK, oat.IDSK, odc.IDSK, odcd.IDSK, oed.IDSK
	from ecommerce_db_stage.ST_PAYMENTS p
	inner join DIM_ORDERS o on o.order_id = p.order_id
	inner join DIM_CUSTOMERS c on c.customer_id = p.customer_id
	inner join DIM_TIME opt on date_format(p.order_purchase_timestamp, "%Y-%m-%d %H:00:00.000000") = opt.FULL_DATE
	left join DIM_TIME oat on date_format(p.order_approved_at, "%Y-%m-%d %H:00:00.000000") = oat.FULL_DATE 
	left join DIM_TIME odc on date_format(p.order_delivered_carrier_date, "%Y-%m-%d %H:00:00.000000") = odc.FULL_DATE 
	left join DIM_TIME odcd on date_format(p.order_delivered_customer_date, "%Y-%m-%d %H:00:00.000000") = odcd.FULL_DATE 
	left join DIM_TIME oed on date_format(p.order_estimated_delivery_date, "%Y-%m-%d %H:00:00.000000") = oed.FULL_DATE 
	where o.IDSK not in (select order_id from FACT_PAYMENTS);

	call printf('Dados inseridos na tabela FACT_PAYMENTS');

	update FACT_PAYMENTS pd
	inner join DIM_ORDERS o on o.IDSK = pd.order_id
	inner join ecommerce_db_stage.ST_PAYMENTS p on p.order_id = o.order_id
	inner join DIM_TIME oat on date_format(p.order_approved_at, "%Y-%m-%d %H:00:00.000000") = oat.FULL_DATE 
	left join DIM_TIME odc on date_format(p.order_delivered_carrier_date, "%Y-%m-%d %H:00:00.000000") = odc.FULL_DATE 
	left join DIM_TIME odcd on date_format(p.order_delivered_customer_date, "%Y-%m-%d %H:00:00.000000") = odcd.FULL_DATE 
	left join DIM_TIME oed on date_format(p.order_estimated_delivery_date, "%Y-%m-%d %H:00:00.000000") = oed.FULL_DATE 
	set 
	pd.order_approved_at_id = oat.IDSK , 
	pd.order_delivered_carrier_date_id = odc.IDSK, 
	pd.order_delivered_customer_date_id = odcd.IDSK, 
	pd.order_estimated_delivery_date_id = oed.IDSK
	where 
	pd.order_approved_at_id <> oat.IDSK 
	or pd.order_delivered_carrier_date_id <> odc.IDSK
	or pd.order_delivered_customer_date_id <> odcd.IDSK 
	or pd.order_estimated_delivery_date_id <> oed.IDSK;

	call printf('Dados atualizados na tabela FACT_PAYMENTS');

	-- FACT_REVIEWS
	insert into FACT_REVIEWS (id_tb_order_reviews,order_id, customer_id,  order_purchase_timestamp_id, order_approved_at_id, 
	order_delivered_carrier_date_id, order_delivered_customer_date_id,  order_estimated_delivery_date_id,
	review_score, review_comment_title, review_comment_message, review_creation_date_id, review_answer_timestamp_id )
	select r.id_tb_order_reviews, o.IDSK, c.IDSK,  opt.IDSK, oat.IDSK, odc.IDSK, odcd.IDSK, oed.IDSK,
	r.review_score, r.review_comment_title, r.review_comment_message, rcd.IDSK, rat.IDSK
	from ecommerce_db_stage.ST_REVIEWS r
	inner join DIM_ORDERS o on o.order_id = r.order_id
	inner join DIM_CUSTOMERS c on c.customer_id = r.customer_id
	inner join DIM_TIME opt on date_format(r.order_purchase_timestamp, "%Y-%m-%d %H:00:00.000000") = opt.FULL_DATE
	left join DIM_TIME oat on date_format(r.order_approved_at, "%Y-%m-%d %H:00:00.000000") = oat.FULL_DATE 
	left join DIM_TIME odc on date_format(r.order_delivered_carrier_date, "%Y-%m-%d %H:00:00.000000") = odc.FULL_DATE 
	left join DIM_TIME odcd on date_format(r.order_delivered_customer_date, "%Y-%m-%d %H:00:00.000000") = odcd.FULL_DATE 
	left join DIM_TIME oed on date_format(r.order_estimated_delivery_date, "%Y-%m-%d %H:00:00.000000") = oed.FULL_DATE
	left join DIM_TIME rcd on date_format(r.review_creation_date, "%Y-%m-%d %H:00:00.000000") = rcd.FULL_DATE 
	left join DIM_TIME rat on date_format(r.review_answer_timestamp, "%Y-%m-%d %H:00:00.000000") = rat.FULL_DATE
	where r.id_tb_order_reviews not in (select id_tb_order_reviews from FACT_REVIEWS);

	call printf('Dados inseridos na tabela FACT_REVIEWS');

	update FACT_REVIEWS rd
	inner join DIM_ORDERS o on o.IDSK = rd.order_id
	inner join ecommerce_db_stage.ST_REVIEWS r on 
	r.order_id = o.order_id
	inner join DIM_TIME oat on date_format(r.order_approved_at, "%Y-%m-%d %H:00:00.000000") = oat.FULL_DATE 
	left join DIM_TIME odc on date_format(r.order_delivered_carrier_date, "%Y-%m-%d %H:00:00.000000") = odc.FULL_DATE 
	left join DIM_TIME odcd on date_format(r.order_delivered_customer_date, "%Y-%m-%d %H:00:00.000000") = odcd.FULL_DATE 
	left join DIM_TIME oed on date_format(r.order_estimated_delivery_date, "%Y-%m-%d %H:00:00.000000") = oed.FULL_DATE 
	set 
	rd.order_approved_at_id = oat.IDSK , 
	rd.order_delivered_carrier_date_id = odc.IDSK, 
	rd.order_delivered_customer_date_id = odcd.IDSK, 
	rd.order_estimated_delivery_date_id = oed.IDSK
	where 
	rd.order_approved_at_id <> oat.IDSK 
	or rd.order_delivered_carrier_date_id <> odc.IDSK
	or rd.order_delivered_customer_date_id <> odcd.IDSK 
	or rd.order_estimated_delivery_date_id <> oed.IDSK;

	call printf('Dados atualizados na tabela FACT_REVIEWS');

	-- FACT_ITEMS
	insert into FACT_ITEMS (order_id, customer_id, product_id, seller_id, order_purchase_timestamp_id, 
	order_approved_at_id, order_delivered_carrier_date_id, order_delivered_customer_date_id, order_estimated_delivery_date_id, 
	shipping_limit_date_id, price, freight_value)
	select o.IDSK, c.IDSK, p.IDSK, s.IDSK, opt.IDSK, oat.IDSK, odc.IDSK, odcd.IDSK, oed.IDSK, 
	sld.IDSK, i.price, i.freight_value
	from ecommerce_db_stage.ST_ITEMS i
	inner join DIM_ORDERS o on o.order_id = i.order_id
	inner join DIM_CUSTOMERS c on c.customer_id = i.customer_id
	inner join DIM_PRODUCTS p on p.product_id = i.product_id and p.FIM is null
	inner join DIM_SELLERS s on s.seller_id = i.seller_id and s.FIM is null
	inner join DIM_TIME opt on date_format(i.order_purchase_timestamp, "%Y-%m-%d %H:00:00.000000") = opt.FULL_DATE
	left join DIM_TIME oat on date_format(i.order_approved_at, "%Y-%m-%d %H:00:00.000000") = oat.FULL_DATE 
	left join DIM_TIME odc on date_format(i.order_delivered_carrier_date, "%Y-%m-%d %H:00:00.000000") = odc.FULL_DATE 
	left join DIM_TIME odcd on date_format(i.order_delivered_customer_date, "%Y-%m-%d %H:00:00.000000") = odcd.FULL_DATE 
	left join DIM_TIME oed on date_format(i.order_estimated_delivery_date, "%Y-%m-%d %H:00:00.000000") = oed.FULL_DATE
	left join DIM_TIME sld on date_format(i.shipping_limit_date, "%Y-%m-%d %H:00:00.000000") = sld.FULL_DATE
	where o.IDSK not in (select order_id from FACT_ITEMS);

	call printf('Dados inseridos na tabela FACT_ITEMS');

	update FACT_ITEMS id
	inner join DIM_ORDERS o on o.IDSK = id.order_id
	inner join ecommerce_db_stage.ST_ITEMS i on 
	i.order_id = o.order_id
	inner join DIM_TIME oat on date_format(i.order_approved_at, "%Y-%m-%d %H:00:00.000000") = oat.FULL_DATE 
	left join DIM_TIME odc on date_format(i.order_delivered_carrier_date, "%Y-%m-%d %H:00:00.000000") = odc.FULL_DATE 
	left join DIM_TIME odcd on date_format(i.order_delivered_customer_date, "%Y-%m-%d %H:00:00.000000") = odcd.FULL_DATE 
	left join DIM_TIME oed on date_format(i.order_estimated_delivery_date, "%Y-%m-%d %H:00:00.000000") = oed.FULL_DATE 
	set 
	id.order_approved_at_id = oat.IDSK , 
	id.order_delivered_carrier_date_id = odc.IDSK, 
	id.order_delivered_customer_date_id = odcd.IDSK, 
	id.order_estimated_delivery_date_id = oed.IDSK
	where 
	id.order_approved_at_id <> oat.IDSK 
	or id.order_delivered_carrier_date_id <> odc.IDSK
	or id.order_delivered_customer_date_id <> odcd.IDSK 
	or id.order_estimated_delivery_date_id <> oed.IDSK;

	call printf('Dados atualizados na tabela FACT_ITEMS');

end;

//
delimiter ;