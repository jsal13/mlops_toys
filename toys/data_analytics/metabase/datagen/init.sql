

CREATE TABLE customers (
    id VARCHAR(128),
    name varchar(256),
    PRIMARY KEY (id)
);

COPY customers FROM '/docker-entrypoint-initdb.d/raw_customers.csv' csv header;

CREATE TABLE items (
    id VARCHAR(128),
    order_id VARCHAR(128),
    sku VARCHAR(128),
    PRIMARY KEY (id)
);

COPY items FROM '/docker-entrypoint-initdb.d/raw_items.csv' csv header;

CREATE TABLE orders (
    id VARCHAR(128),
    customer VARCHAR(128),
    ordered_at TIMESTAMP,
    store_id VARCHAR(128),
    subtotal INT,
    tax_paid INT,
    order_total INT,
    PRIMARY KEY (id)
);

COPY orders FROM '/docker-entrypoint-initdb.d/raw_orders.csv' csv header;

CREATE TABLE products (
    sku VARCHAR(128),
    name VARCHAR(128),
    type VARCHAR(128),
    price INT,
    description VARCHAR(128),
    PRIMARY KEY (sku)
);


COPY products FROM '/docker-entrypoint-initdb.d/raw_products.csv' csv header;

CREATE TABLE stores (
    id VARCHAR(128),
    name VARCHAR(128),
    opened_at TIMESTAMP,
    tax_rate float,
    PRIMARY KEY (id)
);

COPY stores FROM '/docker-entrypoint-initdb.d/raw_stores.csv' csv header;

CREATE TABLE supplies (
    id VARCHAR(128),
    name VARCHAR(128),
    cost INT,
    perishable BOOLEAN,
    sku VARCHAR(128)
);

COPY supplies FROM '/docker-entrypoint-initdb.d/raw_supplies.csv' csv header;