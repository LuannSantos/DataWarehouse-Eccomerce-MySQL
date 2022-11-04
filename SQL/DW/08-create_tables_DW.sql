use ecommerce_db_dw;

create table DIM_CUSTOMERS
(	
	IDSK INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	customer_id VARCHAR(32) NOT NULL,
	customer_unique_id VARCHAR(32) NOT NULL,
	customer_city VARCHAR(50) NOT NULL,
	customer_state VARCHAR(2) NOT NULL,
	geolocation_lat DECIMAL(20,18),
	geolocation_lng DECIMAL(20,18)
);

create table DIM_PRODUCTS
(
	IDSK INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	product_id VARCHAR(32) NOT NULL,
	INICIO DATETIME,
	FIM DATETIME,
	product_category_name VARCHAR(50),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g DECIMAL(9,2) NOT NULL,
	product_length_cm DECIMAL(9,2) NOT NULL,
	product_height_cm DECIMAL(9,2) NOT NULL,
	product_width_cm DECIMAL(9,2) NOT NULL
);

create table DIM_SELLERS
(
	IDSK INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	INICIO DATETIME,
	FIM DATETIME,
	seller_id VARCHAR(32) NOT NULL,
	seller_city VARCHAR(50) NOT NULL,
	seller_state VARCHAR(2) NOT NULL,
	seller_zip_code_prefix VARCHAR(5) NOT NULL,
	geolocation_lat DECIMAL(20,18),
	geolocation_lng DECIMAL(20,18)
);

create table DIM_ORDERS
(
	IDSK INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	order_id VARCHAR(32) NOT NULL,
	order_status VARCHAR(15) NOT NULL
);

create table DIM_PAYMENT_TYPES
(
	IDSK INT PRIMARY KEY NOT NULL,
	payment_type VARCHAR(50) NOT NULL
);

create table DIM_TIME
(
	IDSK INT PRIMARY KEY AUTO_INCREMENT,
	FULL_DATE DATETIME,
	DAYMONTH CHAR(2),
	WEEKDAY VARCHAR(10),
	MONTH_NUM CHAR(2),
	MONTH_NAME VARCHAR(20),
	QUARTER_NUM TINYINT,
	YEAR_NUM CHAR(4),
	SEASON VARCHAR(20),
	WEEKEND TINYINT,
	DATE_TEXT VARCHAR(10),
	HOUR_NUM CHAR(2),
	CONSTRAINT UC_TIME UNIQUE(FULL_DATE)
);

create table FACT_PAYMENTS
(
	order_id INT NOT NULL,
	customer_id INT NOT NULL,
	payment_type_id INT NOT NULL,
	payment_installments INT NOT NULL,
	payment_value DECIMAL(9,2) NOT NULL,
	order_purchase_timestamp_id INT NOT NULL,
	order_approved_at_id INT,
	order_delivered_carrier_date_id INT,
	order_delivered_customer_date_id INT,
	order_estimated_delivery_date_id INT
);

create table FACT_REVIEWS
(
	id_tb_order_reviews INT NOT NULL,
	order_id INT NOT NULL,
	customer_id INT NOT NULL,
	order_purchase_timestamp_id INT NOT NULL,
	order_approved_at_id INT,
	order_delivered_carrier_date_id INT,
	order_delivered_customer_date_id INT,
	order_estimated_delivery_date_id INT,
	review_score INT NOT NULL,
	review_comment_title VARCHAR(80),
	review_comment_message TEXT,
	review_creation_date_id INT NOT NULL,
	review_answer_timestamp_id INT NOT NULL

);

create table FACT_ITEMS
(
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	seller_id INT NOT NULL,
	customer_id INT NOT NULL,
	order_purchase_timestamp_id INT NOT NULL,
	order_approved_at_id INT,
	order_delivered_carrier_date_id INT,
	order_delivered_customer_date_id INT,
	order_estimated_delivery_date_id INT,
	shipping_limit_date_id INT NOT NULL,
	price DECIMAL(9,2) NOT NULL,
	freight_value DECIMAL(9,2) NOT NULL
);