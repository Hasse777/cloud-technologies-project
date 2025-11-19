CREATE SCHEMA IF NOT EXISTS cdm;


CREATE TABLE IF NOT EXISTS cdm.user_product_counters(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id UUID NOT NULL,
	product_id UUID NOT NULL,
	product_name VARCHAR(50) NOT NULL,
	order_cnt INT NOT NULL CHECK(order_cnt >= 0),
	CONSTRAINT un_user_id_product_id UNIQUE (user_id, product_id)
);


CREATE TABLE IF NOT EXISTS cdm.user_category_counters(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id UUID NOT NULL,
	category_id UUID NOT NULL,
	category_name VARCHAR(50) NOT NULL,
	order_cnt INT NOT NULL CHECK(order_cnt >= 0),
	CONSTRAINT un_user_id_category_id UNIQUE (user_id, category_id)
);


CREATE TABLE IF NOT EXISTS stg.order_events(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	object_id INT NOT NULL,
	object_type VARCHAR(50) NOT NULL,
	payload JSON NOT NULL,
	sent_dttm TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS dds.h_user(
	h_user_pk UUID PRIMARY KEY,
	user_id VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL
);


CREATE TABLE IF NOT EXISTS dds.h_product(
	h_product_pk UUID PRIMARY KEY,
	product_id VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL
);


CREATE TABLE IF NOT EXISTS dds.h_category(
	h_category_pk UUID PRIMARY KEY,
	category_name VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL
);


CREATE TABLE IF NOT EXISTS dds.h_restaurant(
	h_restaurant_pk UUID PRIMARY KEY,
	restaurant_id VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL
);


CREATE TABLE IF NOT EXISTS dds.h_order(
	h_order_pk UUID PRIMARY KEY,
	order_id INT NOT NULL,
	order_dt TIMESTAMP NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL
);



CREATE TABLE IF NOT EXISTS dds.l_order_product(
	hk_order_product_pk UUID PRIMARY KEY,
	h_product_pk UUID NOT NULL,
	h_order_pk UUID NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_product_pk FOREIGN KEY (h_product_pk) REFERENCES dds.h_product(h_product_pk),
	CONSTRAINT fk_h_order_pk FOREIGN KEY (h_order_pk) REFERENCES dds.h_order(h_order_pk)
);


CREATE TABLE IF NOT EXISTS dds.l_product_restaurant(
	hk_product_restaurant_pk UUID PRIMARY KEY,
	h_product_pk UUID NOT NULL,
	h_restaurant_pk UUID NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_product_l_product_restaurant_pk FOREIGN KEY (h_product_pk) REFERENCES dds.h_product(h_product_pk),
	CONSTRAINT fk_h_restaurant_l_product_restaurant FOREIGN KEY (h_restaurant_pk) REFERENCES dds.h_restaurant(h_restaurant_pk)
);


CREATE TABLE IF NOT EXISTS dds.l_product_category(
	hk_product_category_pk UUID PRIMARY KEY,
	h_product_pk UUID NOT NULL,
	h_category_pk UUID NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_product_l_product_category_pk FOREIGN KEY (h_product_pk) REFERENCES dds.h_product(h_product_pk),
	CONSTRAINT fk_h_category_l_product_category_pk FOREIGN KEY (h_category_pk) REFERENCES dds.h_category(h_category_pk)
);


CREATE TABLE IF NOT EXISTS dds.l_order_user(
	hk_order_user_pk UUID PRIMARY KEY,
	h_user_pk UUID NOT NULL,
	h_order_pk UUID NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_user_l_order_user FOREIGN KEY (h_user_pk) REFERENCES dds.h_user (h_user_pk),
	CONSTRAINT fk_h_order_l_order_user FOREIGN KEY (h_order_pk) REFERENCES dds.h_order (h_order_pk)
);


CREATE TABLE IF NOT EXISTS dds.s_user_names(
	hk_user_names_hashdiff UUID PRIMARY KEY,
	h_user_pk UUID NOT NULL,
	username VARCHAR NOT NULL,
	userlogin VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_user_s_user_names FOREIGN KEY (h_user_pk) REFERENCES dds.h_user (h_user_pk)
);


CREATE TABLE IF NOT EXISTS dds.s_product_names(
	hk_product_names_hashdiff UUID PRIMARY KEY,
	h_product_pk UUID NOT NULL,
	name VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_product_s_product_names FOREIGN KEY(h_product_pk) REFERENCES dds.h_product(h_product_pk)
);



CREATE TABLE IF NOT EXISTS dds.s_restaurant_names(
	hk_restaurant_names_hashdiff UUID PRIMARY KEY,
	h_restaurant_pk UUID NOT NULL,
	name VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_restaurant_pk_restaurant_names FOREIGN KEY(h_restaurant_pk) REFERENCES dds.h_restaurant(h_restaurant_pk)
);


CREATE TABLE IF NOT EXISTS dds.s_order_cost(
	hk_order_cost_hashdiff UUID PRIMARY KEY,
	h_order_pk UUID NOT NULL,
	cost DECIMAL(19, 5) NOT NULL,
	payment DECIMAL(19, 5) NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_order_s_order_cost FOREIGN KEY(h_order_pk) REFERENCES dds.h_order(h_order_pk)
);


CREATE TABLE IF NOT EXISTS dds.s_order_status(
	hk_order_status_hashdiff UUID PRIMARY KEY,
	h_order_pk UUID NOT NULL,
	status VARCHAR NOT NULL,
	load_dt TIMESTAMP NOT NULL DEFAULT NOW(),
	load_src VARCHAR NOT NULL,
	CONSTRAINT fk_h_order_s_order_status FOREIGN KEY(h_order_pk) REFERENCES dds.h_order(h_order_pk)
);
