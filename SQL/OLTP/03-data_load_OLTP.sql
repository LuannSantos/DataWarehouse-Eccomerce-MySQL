use ecommerce_db;

-- tb_customers
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_customers_dataset.csv"
INTO TABLE tb_customers
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- tb_geolocation
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_geolocation_dataset.csv"
INTO TABLE tb_geolocation
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@geolocation_zip_code_prefix,@geolocation_lat,@geolocation_lng,@geolocation_city,@geolocation_state)
set
geolocation_zip_code_prefix = @geolocation_zip_code_prefix ,
geolocation_lat = @geolocation_lat ,
geolocation_lng = @geolocation_lng ,
geolocation_city = @geolocation_city ,
geolocation_state = @geolocation_state 

-- tb_order_items
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_order_items_dataset.csv"
INTO TABLE tb_order_items
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
( @order_id,@order_item_id,@product_id,@seller_id,@shipping_limit_date,@price,@freight_value)
set 
order_id = @order_id,
order_item_id = @order_item_id,
product_id = @product_id,
seller_id = @seller_id,
shipping_limit_date = @shipping_limit_date,
price = @price,
freight_value = @freight_value;

-- tb_order_payments
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_order_payments_dataset.csv"
INTO TABLE tb_order_payments
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
( @order_id,@payment_sequential,@payment_type,@payment_installments,@payment_value)
set 
order_id = @order_id ,
payment_sequential = @payment_sequential ,
payment_type = @payment_type ,
payment_installments = @payment_installments ,
payment_value = @payment_value;

-- tb_order_reviews
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_order_reviews_dataset.csv"
INTO TABLE tb_order_reviews
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
( @review_id,@order_id,@review_score,@review_comment_title,@review_comment_message,@review_creation_date,@review_answer_timestamp)
set 
review_id = @review_id,
order_id = @order_id,
review_score = @review_score,
review_comment_title = @review_comment_title,
review_comment_message = @review_comment_message,
review_creation_date = @review_creation_date,
review_answer_timestamp = @review_answer_timestamp;

-- tb_orders
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_orders_dataset.csv"
INTO TABLE tb_orders
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@order_id,@customer_id,@order_status,@order_purchase_timestamp,@order_approved_at,@order_delivered_carrier_date,
	@order_delivered_customer_date,@order_estimated_delivery_date)
set
order_id = @order_id,
customer_id = @customer_id,
order_status = @order_status,
order_purchase_timestamp = @order_purchase_timestamp,
order_approved_at = if(rtrim(@order_approved_at) = '', null, @order_approved_at),
order_delivered_carrier_date = if(rtrim(@order_delivered_carrier_date) = '', null, @order_delivered_carrier_date),
order_delivered_customer_date = if(rtrim(@order_delivered_customer_date) = '', null, @order_delivered_customer_date),
order_estimated_delivery_date = if(rtrim(@order_estimated_delivery_date) = '', null, @order_estimated_delivery_date);

-- tb_products
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_products_dataset.csv"
INTO TABLE tb_products
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@product_id,@product_category_name,@product_name_lenght,@product_description_lenght,@product_photos_qty,@product_weight_g,
	@product_length_cm,@product_height_cm,@product_width_cm)
set
product_id = @product_id,
product_category_name = if(rtrim(@product_category_name) = '', null, @product_category_name ),
product_name_lenght = @product_name_lenght,
product_description_lenght = @product_description_lenght,
product_photos_qty = @product_photos_qty,
product_weight_g = @product_weight_g,
product_length_cm = @product_length_cm,
product_height_cm = @product_height_cm,
product_width_cm = @product_width_cm;

-- tb_sellers
LOAD DATA LOCAL INFILE "[DIRETORIO]/olist_sellers_dataset.csv"
INTO TABLE tb_sellers
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- tb_product_category_name_translation
LOAD DATA LOCAL INFILE "[DIRETORIO]/product_category_name_translation.csv"
INTO TABLE tb_product_category_name_translation
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;