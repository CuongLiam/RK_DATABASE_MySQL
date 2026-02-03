CREATE DATABASE ss5ep4;
USE ss5ep4;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'inactive'
);

CREATE TABLE orders(
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    total_amount DECIMAL (10,2) NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (full_name, email, city, status) VALUES
('David brown', 'david@gmail.com', 'TP.HCM', 'active'),
('alice robinson', 'alice@gmail.com', 'texas', 'inactive'),
('marques downey', 'ok@gmail.com', 'washington dc', 'active');

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 10000000, '2026-2-2', 'completed'),
(1, 69, '2026-2-28', 'cancelled'),
(3, 1000, '2026-2-1', 'completed');

SELECT *
FROM orders
WHERE status = 'completed';

UPDATE orders
SET total_amount = 6900000
WHERE order_id = 1;

SELECT *
FROM orders
WHERE total_amount > 5000000;

SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 2;

SELECT *
FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;