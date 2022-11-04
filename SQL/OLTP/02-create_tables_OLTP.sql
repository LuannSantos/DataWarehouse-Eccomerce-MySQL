use ecommerce_db;

create table tb_customers
(
	customer_id VARCHAR(32) PRIMARY KEY NOT NULL,
	customer_unique_id VARCHAR(32) NOT NULL,
	customer_zip_code_prefix VARCHAR(5) NOT NULL,
	customer_city VARCHAR(50) NOT NULL,
	customer_state VARCHAR(2) NOT NULL
);

create table tb_geolocation
(
	id_geolocation INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	geolocation_zip_code_prefix VARCHAR(5) NOT NULL,
	geolocation_lat DECIMAL(20,18) NOT NULL,
	geolocation_lng DECIMAL(20,18) NOT NULL,
	geolocation_city VARCHAR(50) NOT NULL,
	geolocation_state VARCHAR(2) NOT NULL,
	CONSTRAINT UC_GEOLOCATION UNIQUE(geolocation_lat, geolocation_lng)
);

create table tb_order_items
(
	id_tb_order_items INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	order_id VARCHAR(32) NOT NULL,
	order_item_id VARCHAR(32) NOT NULL,
	product_id VARCHAR(32) NOT NULL,
	seller_id VARCHAR(32) NOT NULL,
	shipping_limit_date DATETIME NOT NULL,
	price DECIMAL(9,2) NOT NULL,
	freight_value DECIMAL(9,2) NOT NULL,
	CONSTRAINT UC_ITEMS UNIQUE(order_id, order_item_id)
);

create table tb_order_payments
(
	id_tb_order_payments INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	order_id VARCHAR(32) NOT NULL,
	payment_sequential INT NOT NULL,
	payment_type VARCHAR(50) NOT NULL,
	payment_installments INT NOT NULL,
	payment_value DECIMAL(9,2) NOT NULL,
	CONSTRAINT UC_PAYMENT UNIQUE (order_id, payment_sequential)
);

create table tb_order_reviews
(
	id_tb_order_reviews INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	review_id VARCHAR(32) NOT NULL,
	order_id VARCHAR(32) NOT NULL,
	review_score INT NOT NULL,
	review_comment_title VARCHAR(80),
	review_comment_message TEXT,
	review_creation_date DATETIME NOT NULL,
	review_answer_timestamp DATETIME NOT NULL,
	CONSTRAINT UC_REVIEW UNIQUE(review_id, order_id)
);

create table tb_orders
(
	order_id VARCHAR(32) PRIMARY KEY NOT NULL ,
	customer_id VARCHAR(32) NOT NULL,
	order_status VARCHAR(15) NOT NULL,
	order_purchase_timestamp DATETIME NOT NULL,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME
);

create table tb_products
(
	product_id VARCHAR(32) PRIMARY KEY NOT NULL,
	product_category_name VARCHAR(50),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g DECIMAL(9,2) NOT NULL,
	product_length_cm DECIMAL(9,2) NOT NULL,
	product_height_cm DECIMAL(9,2) NOT NULL,
	product_width_cm DECIMAL(9,2) NOT NULL
);

create table tb_sellers
(
	seller_id VARCHAR(32) PRIMARY KEY NOT NULL,
	seller_zip_code_prefix VARCHAR(5) NOT NULL,
	seller_city VARCHAR(50) NOT NULL,
	seller_state VARCHAR(2) NOT NULL
);

create table tb_product_category_name_translation
(
	product_category_name VARCHAR(50) NOT NULL PRIMARY KEY ,
	product_category_name_english VARCHAR(50) NOT NULL
);