use ecommerce_db;


-- tb_order_items
alter table tb_order_items add constraint FK_ORDER
foreign key(order_id) REFERENCES tb_orders(order_id);

alter table tb_order_items add constraint FK_PRODUCT
foreign key(product_id) REFERENCES tb_products(product_id);

alter table tb_order_items add constraint FK_SELLER
foreign key(seller_id) REFERENCES tb_sellers(seller_id);

-- tb_order_payments
alter table tb_order_payments add constraint FK_ORDER_PAYMENT
foreign key(order_id) REFERENCES tb_orders(order_id);

-- tb_order_reviews
alter table tb_order_reviews add constraint FK_ORDER_REVIEW
foreign key(order_id) REFERENCES tb_orders(order_id);

-- tb_orders
alter table tb_orders add constraint FK_CUSTOMER
foreign key(customer_id) REFERENCES tb_customers(customer_id);

-- tb_products
alter table tb_products add constraint FK_CATEGORY
foreign key(product_category_name) REFERENCES tb_product_category_name_translation(product_category_name);
