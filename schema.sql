-- StoreTrack Database Schema
-- Run this script once to initialise the database

CREATE DATABASE IF NOT EXISTS storetrack;
USE storetrack;

-- Users
CREATE TABLE IF NOT EXISTS users (
    id         INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(100)  NOT NULL,
    email      VARCHAR(100)  UNIQUE NOT NULL,
    password   VARCHAR(255)  NOT NULL,
    role       ENUM('ADMIN','CASHIER','STOCK_MANAGER') NOT NULL,
    is_active  TINYINT(1)    DEFAULT 1,
    created_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- Categories
CREATE TABLE IF NOT EXISTS categories (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100)  NOT NULL,
    description VARCHAR(255),
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- Products
CREATE TABLE IF NOT EXISTS products (
    id            INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(150)   NOT NULL,
    category_id   INT            NOT NULL,
    buying_price  DECIMAL(10,2)  NOT NULL,
    selling_price DECIMAL(10,2)  NOT NULL,
    quantity      INT            DEFAULT 0,
    min_quantity  INT            DEFAULT 5,
    unit          VARCHAR(20)    DEFAULT 'pcs',
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Suppliers
CREATE TABLE IF NOT EXISTS suppliers (
    id         INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(150) NOT NULL,
    phone      VARCHAR(15),
    email      VARCHAR(100),
    address    TEXT,
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Stock Entries
CREATE TABLE IF NOT EXISTS stock_entries (
    id             INT PRIMARY KEY AUTO_INCREMENT,
    product_id     INT NOT NULL,
    supplier_id    INT,
    quantity_added INT NOT NULL,
    added_by       INT NOT NULL,
    added_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id)  REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (added_by)    REFERENCES users(id)
);

-- Sales
CREATE TABLE IF NOT EXISTS sales (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    cashier_id   INT           NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    tax_amount   DECIMAL(10,2) DEFAULT 0.00,
    sale_date    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cashier_id) REFERENCES users(id)
);

-- Sale Items
CREATE TABLE IF NOT EXISTS sale_items (
    id         INT PRIMARY KEY AUTO_INCREMENT,
    sale_id    INT           NOT NULL,
    product_id INT           NOT NULL,
    quantity   INT           NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal   DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (sale_id)    REFERENCES sales(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_products_category  ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_stock_product       ON stock_entries(product_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_sale     ON sale_items(sale_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_product  ON sale_items(product_id);
CREATE INDEX IF NOT EXISTS idx_sales_date          ON sales(sale_date);

-- Seed: default admin — password is "admin123"
INSERT IGNORE INTO users (name, email, password, role)
VALUES ('Admin', 'admin@storetrack.com',
        '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN');

-- Seed categories
INSERT IGNORE INTO categories (id, name, description) VALUES
(1, 'Beverages',   'Drinks and liquid refreshments'),
(2, 'Snacks',      'Chips, biscuits, and packaged snacks'),
(3, 'Dairy',       'Milk, cheese, butter, and dairy products'),
(4, 'Stationery',  'Pens, notebooks, and office supplies');

-- Seed suppliers
INSERT IGNORE INTO suppliers (id, name, phone, email, address) VALUES
(1, 'Metro Wholesale',  '9876543210', 'metro@example.com',   'MG Road, Mumbai'),
(2, 'FreshDairy Co.',   '9123456789', 'freshdairy@example.com', 'Pune, Maharashtra');

-- Seed products
INSERT IGNORE INTO products (id, name, category_id, buying_price, selling_price, quantity, min_quantity, unit) VALUES
(1, 'Coca-Cola 500ml',    1, 20.00,  28.00,  50,  10, 'bottles'),
(2, 'Lays Classic 40g',   2, 15.00,  20.00,   8,  15, 'packets'),
(3, 'Amul Butter 500g',   3, 220.00, 260.00, 20,   5, 'pcs'),
(4, 'Classmate Notebook', 4, 35.00,  50.00,  30,  10, 'pcs');
