use ecommerce_db_dw;

-- FACT_PAYMENTS
alter table FACT_PAYMENTS add constraint FK_ORDER_PAYMENT
foreign key(order_id) REFERENCES DIM_ORDERS(IDSK);

alter table FACT_PAYMENTS add constraint FK_CUSTOMER_PAYMENT
foreign key(customer_id) REFERENCES DIM_CUSTOMERS(IDSK);

alter table FACT_PAYMENTS add constraint FK_PAYMENT_TYPE
foreign key(payment_type_id) REFERENCES DIM_PAYMENT_TYPES(IDSK);

-- FACT_PAYMENTS TIME KEYS

alter table FACT_PAYMENTS add constraint FK_ORDER_PURCHASE_PAYMENT
foreign key(order_purchase_timestamp_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_PAYMENTS add constraint FK_ORDER_APPROVED_PAYMENT
foreign key(order_approved_at_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_PAYMENTS add constraint FK_ORDER_DELIVERED_CARRIER_PAYMENT
foreign key(order_delivered_carrier_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_PAYMENTS add constraint FK_ORDER_DELIVERED_CUSTOMER_PAYMENT
foreign key(order_delivered_customer_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_PAYMENTS add constraint FK_ORDER_ESTIMATED_DELIVERED_PAYMENT
foreign key(order_estimated_delivery_date_id) REFERENCES DIM_TIME(IDSK);

-- FACT_REVIEWS

alter table FACT_REVIEWS add constraint FK_ORDER_REVIEW
foreign key(order_id) REFERENCES DIM_ORDERS(IDSK);

alter table FACT_REVIEWS add constraint FK_CUSTOMER_REVIEW
foreign key(customer_id) REFERENCES DIM_CUSTOMERS(IDSK);

-- FACT_REVIEWS TIME KEYS

alter table FACT_REVIEWS add constraint FK_ORDER_PURCHASE_REVIEW
foreign key(order_purchase_timestamp_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_REVIEWS add constraint FK_ORDER_APPROVED_REVIEW
foreign key(order_approved_at_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_REVIEWS add constraint FK_ORDER_DELIVERED_CARRIER_REVIEW
foreign key(order_delivered_carrier_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_REVIEWS add constraint FK_ORDER_DELIVERED_CUSTOMER_REVIEW
foreign key(order_delivered_customer_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_REVIEWS add constraint FK_ORDER_ESTIMATED_DELIVERED_REVIEW
foreign key(order_estimated_delivery_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_REVIEWS add constraint FK_REVIEW_CREATION
foreign key(review_creation_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_REVIEWS add constraint FK_REVIEW_ANSWER
foreign key(review_answer_timestamp_id) REFERENCES DIM_TIME(IDSK);

-- FACT_ITEMS

alter table FACT_ITEMS add constraint FK_ORDER_ITEM
foreign key(order_id) REFERENCES DIM_ORDERS(IDSK);

alter table FACT_ITEMS add constraint FK_CUSTOMER_ITEM
foreign key(customer_id) REFERENCES DIM_CUSTOMERS(IDSK);

alter table FACT_ITEMS add constraint FK_PRODUCT_ITEM
foreign key(product_id) REFERENCES DIM_PRODUCTS(IDSK);

alter table FACT_ITEMS add constraint FK_SELLER_ITEM
foreign key(seller_id) REFERENCES DIM_SELLERS(IDSK);

-- FACT_ITEMS TIME KEYS

alter table FACT_ITEMS add constraint FK_ORDER_PURCHASE_ITEM
foreign key(order_purchase_timestamp_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_ITEMS add constraint FK_ORDER_APPROVED_ITEM
foreign key(order_approved_at_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_ITEMS add constraint FK_ORDER_DELIVERED_CARRIER_ITEM
foreign key(order_delivered_carrier_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_ITEMS add constraint FK_ORDER_DELIVERED_CUSTOMER_ITEM
foreign key(order_delivered_customer_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_ITEMS add constraint FK_ORDER_ESTIMATED_DELIVERED_ITEM
foreign key(order_estimated_delivery_date_id) REFERENCES DIM_TIME(IDSK);

alter table FACT_ITEMS add constraint FK_ITEM_SHIPPING
foreign key(shipping_limit_date_id) REFERENCES DIM_TIME(IDSK);