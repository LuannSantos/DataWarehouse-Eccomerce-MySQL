use ecommerce_db_stage;

create table ST_CUSTOMERS
(
	customer_id VARCHAR(32) NOT NULL,
	customer_unique_id VARCHAR(32) NOT NULL,
	customer_city VARCHAR(50) NOT NULL,
	customer_state VARCHAR(2) NOT NULL,
	geolocation_lat DECIMAL(20,18),
	geolocation_lng DECIMAL(20,18)
);		

create table ST_PRODUCTS
(
	product_id VARCHAR(32) NOT NULL,
	product_category_name VARCHAR(50),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g DECIMAL(9,2) NOT NULL,
	product_length_cm DECIMAL(9,2) NOT NULL,
	product_height_cm DECIMAL(9,2) NOT NULL,
	product_width_cm DECIMAL(9,2) NOT NULL
);

create table ST_SELLERS
(
	seller_id VARCHAR(32) NOT NULL,
	seller_city VARCHAR(50) NOT NULL,
	seller_state VARCHAR(2) NOT NULL,
	seller_zip_code_prefix VARCHAR(5) NOT NULL,
	geolocation_lat DECIMAL(20,18),
	geolocation_lng DECIMAL(20,18)
);

create table ST_ORDERS
(
	order_id VARCHAR(32) NOT NULL,
	order_status VARCHAR(15) NOT NULL
);

create table ST_PAYMENT_TYPES
(
	payment_type_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	payment_type VARCHAR(50) NOT NULL
);

create table ST_PAYMENTS
(
	order_id VARCHAR(32) NOT NULL,
	customer_id VARCHAR(32) NOT NULL,
	payment_type_id INT NOT NULL,
	payment_installments INT NOT NULL,
	payment_value DECIMAL(9,2) NOT NULL,
	order_purchase_timestamp DATETIME NOT NULL,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME
);

create table ST_REVIEWS
(
	id_tb_order_reviews INT NOT NULL,
	order_id VARCHAR(32) NOT NULL,
	customer_id VARCHAR(32) NOT NULL,
	order_purchase_timestamp DATETIME NOT NULL,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME,
	review_score INT NOT NULL,
	review_comment_title VARCHAR(80),
	review_comment_message TEXT,
	review_creation_date DATETIME NOT NULL,
	review_answer_timestamp DATETIME NOT NULL

);

create table ST_ITEMS
(
	order_id VARCHAR(32) NOT NULL,
	product_id VARCHAR(32) NOT NULL,
	seller_id VARCHAR(32) NOT NULL,
	customer_id VARCHAR(32) NOT NULL,
	order_purchase_timestamp DATETIME NOT NULL,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME,
	shipping_limit_date DATETIME NOT NULL,
	price DECIMAL(9,2) NOT NULL,
	freight_value DECIMAL(9,2) NOT NULL
);