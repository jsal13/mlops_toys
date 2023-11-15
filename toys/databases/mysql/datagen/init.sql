use mysql;

CREATE TABLE customers (
    id VARCHAR(128),
    name varchar(256),
    PRIMARY KEY (id)
);

LOAD DATA INFILE '/data/raw_customers.csv'
INTO TABLE customers 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE items (
    id VARCHAR(128),
    order_id VARCHAR(128),
    sku VARCHAR(128),
    PRIMARY KEY (id)
);

LOAD DATA INFILE '/data/raw_items.csv'
INTO TABLE items 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

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

LOAD DATA INFILE '/data/raw_orders.csv'
INTO TABLE orders 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE products (
    sku VARCHAR(128),
    name VARCHAR(128),
    type VARCHAR(128),
    price INT,
    description VARCHAR(128),
    PRIMARY KEY (sku)
);

LOAD DATA INFILE '/data/raw_products.csv'
INTO TABLE products 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE stores (
    id VARCHAR(128),
    name VARCHAR(128),
    opened_at TIMESTAMP,
    tax_rate float,
    PRIMARY KEY (id)
);

LOAD DATA INFILE '/data/raw_stores.csv'
INTO TABLE stores 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE supplies (
    id VARCHAR(128),
    name VARCHAR(128),
    cost INT,
    perishable BOOLEAN,
    sku VARCHAR(128)
);

LOAD DATA INFILE '/data/raw_supplies.csv'
INTO TABLE supplies 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
