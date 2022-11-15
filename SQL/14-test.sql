use ecommerce_db;

-- Script para testar o datawarehouse

-- tb_customers
insert into tb_customers (customer_id, customer_unique_id, customer_city, customer_state, customer_zip_code_prefix)
values
('9ba6dd3b8118412e8c54d11a1f0c0570', 'cd117bfa4f7b46d99c64af4c041235fd', 'alegre', 'ES',  '29500');

-- tb_orders
insert into tb_orders (order_id,customer_id,order_status,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,
	order_delivered_customer_date,order_estimated_delivery_date)
values
('1237cf50038b4d95a495d64c6aeee4f8', '9ba6dd3b8118412e8c54d11a1f0c0570', 'delivered',
	'2018-10-02 10:56:33','2018-10-02 11:07:15','2018-10-04 19:55:00','2018-10-10 21:25:13','2018-10-18 00:00:00');

-- tb_products
insert into tb_products (product_id,product_category_name,product_name_lenght,product_description_lenght,product_photos_qty,
	product_weight_g,product_length_cm,product_height_cm,product_width_cm)
values
('e86bd722e498463981ec34b8d170fbe5','esporte_lazer',15,2000,2,500,16,2,16 );

update tb_products
set product_weight_g = 300
where product_id = '1e9e8ef04dbcff4541ed26657ea517e5' ;

-- tb_sellers
insert into tb_sellers (seller_id,seller_zip_code_prefix,seller_city,seller_state)
values
('96438b0d6adb4e2bb21e4a99cc14f22a', '29500', 'alegre', 'ES');

update tb_sellers
set seller_zip_code_prefix = '29500',
seller_city = 'alegre',
seller_state = 'ES'
where seller_id = '3442f8959a84dea7ee197c632cb2df15';

-- tb_order_items
insert into tb_order_items (order_id,order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value)
values
('1237cf50038b4d95a495d64c6aeee4f8', 1, 'e86bd722e498463981ec34b8d170fbe5',
'96438b0d6adb4e2bb21e4a99cc14f22a', '2018-10-06 11:07:15', 30, 9);

-- tb_order_payments
insert into tb_order_payments (order_id,payment_sequential,payment_type,payment_installments,payment_value)
values
('1237cf50038b4d95a495d64c6aeee4f8', 1, 'credit_card',1,39);

-- tb_order_reviews
insert into tb_order_reviews (review_id,order_id,review_score,review_comment_title,review_comment_message,
	review_creation_date,review_answer_timestamp)
values
('62a6108ab0194558a02dbfb759675ccd','1237cf50038b4d95a495d64c6aeee4f8', 5, 'Tudo OK', 'Ótimo produto',
	'2018-10-11 00:00:00','2018-10-12 03:43:48');

use ecommerce_db_stage;

call sp_data_load_STAGE();

use ecommerce_db_dw;

call sp_data_load_DW();

