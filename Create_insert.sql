-- =========================================================
-- LIMPIEZA
-- =========================================================

DROP TABLE IF EXISTS orderlines;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- =========================================================
-- TABLA CUSTOMERS
-- =========================================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    gender VARCHAR(20),
    created_at DATE DEFAULT CURRENT_DATE
);

-- =========================================================
-- TABLA PRODUCTS
-- =========================================================

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);

-- =========================================================
-- TABLA ORDERS
-- =========================================================

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- =========================================================
-- TABLA ORDERLINES
-- =========================================================

CREATE TABLE orderlines (
    orderline_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderlines_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_orderlines_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- =========================================================
-- INSERT CUSTOMERS
-- =========================================================

INSERT INTO customers (customer_name, email, gender, created_at) VALUES
('Juan Pérez', 'juan@test.com', 'Male', '2023-01-10'),
('María López', 'maria@test.com', 'Female', '2023-02-15'),
('Carlos Ruiz', 'carlos@test.com', 'Male', '2023-03-01'),
('Ana Torres', 'ana@test.com', 'Female', '2023-03-20'),
('Lucía Gómez', 'lucia@test.com', 'Female', '2023-04-11'),
('Pedro Sánchez', 'pedro@test.com', 'Male', '2023-04-25'),
('Laura Díaz', 'laura@test.com', 'Female', '2023-05-02'),
('Miguel Castro', 'miguel@test.com', 'Male', '2023-05-18'),
('Elena Martín', 'elena@test.com', 'Female', '2023-06-01'),
('David Romero', 'david@test.com', 'Male', '2023-06-14'),
('Sara Navarro', 'sara@test.com', 'Female', '2023-06-20'),
('Javier Gil', 'javier@test.com', 'Male', '2023-07-03'),
('Patricia León', 'patricia@test.com', 'Female', '2023-07-15'),
('Alberto Vega', 'alberto@test.com', 'Male', '2023-08-01'),
('Cristina Mora', 'cristina@test.com', 'Female', '2023-08-19'),
('Raúl Ortega', 'raul@test.com', 'Male', '2023-09-10'),
('Natalia Cruz', 'natalia@test.com', 'Female', '2023-09-15'),
('Sergio Ramos', 'sergio@test.com', 'Male', '2023-10-01'),
('Mónica Flores', 'monica@test.com', 'Female', '2023-10-12'),
('Iván Herrera', 'ivan@test.com', 'Male', '2023-11-01');

-- =========================================================
-- INSERT PRODUCTS
-- =========================================================

INSERT INTO products (product_name, category, price) VALUES
('Laptop Lenovo', 'Electronics', 850.00),
('iPhone 15', 'Electronics', 1200.00),
('Monitor LG 27"', 'Electronics', 220.00),
('Teclado Mecánico', 'Accessories', 90.00),
('Ratón Logitech', 'Accessories', 45.00),
('Silla Gaming', 'Furniture', 300.00),
('Escritorio', 'Furniture', 250.00),
('Auriculares Sony', 'Audio', 180.00),
('Tablet Samsung', 'Electronics', 450.00),
('Webcam HD', 'Accessories', 70.00),
('Disco SSD 1TB', 'Storage', 130.00),
('Memoria USB', 'Storage', 20.00),
('Impresora HP', 'Office', 160.00),
('Smartwatch', 'Wearables', 280.00),
('Altavoz Bluetooth', 'Audio', 95.00),
('Cargador USB-C', 'Accessories', 25.00),
('Micrófono', 'Audio', 150.00),
('Dock Station', 'Accessories', 110.00),
('Router WiFi', 'Networking', 140.00),
('Cámara Canon', 'Photography', 950.00);

-- =========================================================
-- INSERT ORDERS
-- =========================================================

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-10', 940.00),
(2, '2024-01-11', 1290.00),
(1, '2024-02-01', 220.00),
(3, '2024-02-05', 390.00),
(4, '2024-02-10', 1600.00),
(5, '2024-02-15', 95.00),
(6, '2024-02-18', 130.00),
(2, '2024-03-01', 450.00),
(7, '2024-03-05', 325.00),
(8, '2024-03-10', 1500.00),
(9, '2024-03-12', 70.00),
(10, '2024-03-15', 180.00),
(11, '2024-03-18', 275.00),
(12, '2024-03-20', 1100.00),
(13, '2024-04-01', 90.00),
(14, '2024-04-05', 540.00),
(15, '2024-04-10', 850.00),
(16, '2024-04-12', 45.00),
(17, '2024-04-15', 250.00),
(18, '2024-04-20', 1200.00);

-- =========================================================
-- INSERT ORDERLINES
-- =========================================================

INSERT INTO orderlines (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 850.00),
(1, 5, 2, 45.00),

(2, 2, 1, 1200.00),
(2, 16, 2, 25.00),

(3, 3, 1, 220.00),

(4, 6, 1, 300.00),
(4, 5, 2, 45.00),

(5, 2, 1, 1200.00),
(5, 8, 2, 180.00),

(6, 15, 1, 95.00),

(7, 11, 1, 130.00),

(8, 9, 1, 450.00),

(9, 6, 1, 300.00),
(9, 16, 1, 25.00),

(10, 20, 1, 950.00),
(10, 14, 1, 280.00),
(10, 5, 6, 45.00),

(11, 10, 1, 70.00),

(12, 8, 1, 180.00),

(13, 7, 1, 250.00),
(13, 12, 1, 20.00),

(14, 1, 1, 850.00),
(14, 17, 1, 150.00),

(15, 4, 1, 90.00),

(16, 9, 1, 450.00),
(16, 5, 2, 45.00),

(17, 1, 1, 850.00),

(18, 5, 1, 45.00),

(19, 7, 1, 250.00),

(20, 2, 1, 1200.00);
